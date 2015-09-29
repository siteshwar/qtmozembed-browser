/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Window 2.1 as QtQuick
import Sailfish.Silica 1.0
import QtMozEmbed.Browser 1.0
import "components"

BrowserApplication {
    id: browserApp

    property alias webView: webView

    backgroundWindow: webView

    WebView {
        id: webView

        property bool active: Qt.application.active
        readonly property bool fullscreenChrome: chrome.height == Screen.height
        property alias chrome: chrome

        width: Screen.width
        height: Screen.height

        delegate: Component {
            WebPage {
                id: webPage

                width: Screen.width
                height: Screen.height

                active: enabled
                readyToPaint: enabled
                enabled: webView.visible

                chromeGestureThreshold: Theme.paddingLarge * 2
                chromeGestureEnabled: webView.fullscreenChrome

                // message and JSON data arguments.
                onRecvAsyncMessage: {
                    var winid = data.winid
                    switch (message) {
                    case "embed:alert": {
                        // Platform provides PageStack...
                        var alertDialog = pageStack.push("components/PromptDialog.qml", {
                                                        "text": data.text
                                                    })

                        alertDialog.done.connect(function() {
                            webPage.sendAsyncMessage("alertresponse", {"winid": winid})
                        })

                        break
                    }
                    case "embed:confirm": {
                        var dialog = pageStack.push("components/PromptDialog.qml",
                                                    {"text": data.text})
                        dialog.accepted.connect(function() {
                            webPage.sendAsyncMessage("confirmresponse",
                                             {"winid": winid, "accepted": true})
                        })
                        dialog.rejected.connect(function() {
                            webPage.sendAsyncMessage("confirmresponse",
                                             {"winid": winid, "accepted": false})
                        })
                        break
                    }
                    case "Content:ContextMenu": {
                        var contextMenuComponent = Qt.createComponent("components/ContextMenu.qml")
                        if (contextMenuComponent.status === Component.Error) {
                            console.debug("errorString", contextMenuComponent.errorString())
                        }

                        var contextMenu = contextMenuComponent.createObject(webView.chrome,
                                                                            {
                                                                                "linkHref": data.linkURL,
                                                                                "linkTitle": data.linkTitle.trim(),
                                                                                "imageSrc": data.mediaURL,
                                                                                "contentType": data.contentType,
                                                                                "webPage": webPage
                                                                            })
                        contextMenu.show()
                        break
                    }
                    }
                }

                onCompletedChanged: {
                    // Three message message examples.
                    addMessageListener("embed:alert")
                    addMessageListener("embed:confirm")
                    addMessageListener("Content:ContextMenu")

                    //url = "about:blank"
                    url = "file:///opt/tests/sailfish-browser/manual/testpage.html"
                }
            }
        }
    }

    initialPage: Chrome {
        id: chrome
        anchors.fill: parent
        onWindowChanged: {
            webView.chromeWindow = window ? window : null
        }
    }
}
