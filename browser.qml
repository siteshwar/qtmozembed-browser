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
                        var alertDialog = pageStack.push("components/PromptDialog.qml", {
                                                         "text": data.text
                                                     })

                        alertDialog.done.connect(function() {
                            webPage.sendAsyncMessage("alertresponse", {"winid": winid})
                        })

                        break
                    }
                    case "embed:confirm": {
                        var confirmDialog = pageStack.push("components/PromptDialog.qml",
                                                           {"text": data.text})
                        confirmDialog.accepted.connect(function() {
                            webPage.sendAsyncMessage("confirmresponse",
                                             {"winid": winid, "accepted": true})
                        })
                        confirmDialog.rejected.connect(function() {
                            webPage.sendAsyncMessage("confirmresponse",
                                             {"winid": winid, "accepted": false})
                        })
                        break
                    }
                    case "Content:ContextMenu": {
                        // This example does not differ from what could be done on other implementations.
                        // "components/ContextPopup.qml"
                        var contextMenuComponent = Qt.createComponent("components/ContextMenu.qml")

                        var linkHref = data.linkURL;
                        var linkTitle = data.linkTitle.trim();
                        var imageSrc = data.mediaURL;

                        if (linkHref || linkTitle || imageSrc) {
                            var contextMenu = contextMenuComponent.createObject(webView.chrome,
                                                                                {
                                                                                    "linkHref": linkHref,
                                                                                    "linkTitle": linkTitle,
                                                                                    "imageSrc": imageSrc,
                                                                                    "contentType": data.contentType,
                                                                                    "webPage": webPage,
                                                                                    "contextPositionX": data.xPos * BrowsingContext.pixelRatio,
                                                                                    "contextPositionY": data.yPos * BrowsingContext.pixelRatio
                                                                                })
                            contextMenu.show()
                        }
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
                    url = "file:///home/nemo/testwebprompts.html"
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
