/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Window 2.1 as QtQuick
import QtMozEmbed.Browser 1.0
import Sailfish.Silica 1.0

Page {
    id: chrome

    readonly property rect inputMask: inputMaskForOrientation(orientation)
    property bool active: chrome.status == PageStatus.Active
    property bool popupActive
    property alias toolbar: toolbar

    signal windowChanged(QtObject window)

    function inputMaskForOrientation(orientation) {
        // mask is in portrait window coordinates
        var mask = Qt.rect(0, 0, Screen.width, Screen.height)
        if (chrome.active && !chrome.popupActive) {
            var visibleHeight = chrome.height - toolbar.y

            switch (orientation) {
            case Orientation.None:
            case Orientation.Portrait:
                mask.y = toolbar.y
                // fallthrough
            case Orientation.PortraitInverted:
                mask.height = visibleHeight
                break

            case Orientation.LandscapeInverted:
                mask.x = toolbar.y
                // fallthrough
            case Orientation.Landscape:
                mask.width = visibleHeight
            }
        }
        return mask
    }

    Item {
        id: toolbar

        property alias url: searchField.text

        width: chrome.width
        height: Math.max(searchField.height, buttons.height)
        y: webView.currentItem && webView.currentItem.chrome ? chrome.height - height : chrome.height

        onWindowChanged: chrome.windowChanged(window)

        Behavior on y {
            enabled: webView.currentItem && webView.currentItem.chromeGestureEnabled
            NumberAnimation { duration: 200 }
        }

        Rectangle {
            color: "black"
            opacity: 0.9
            anchors.top: searchField.top
            width: parent.width
            height: width
        }

        Rectangle {
            id: progressBar

            anchors.bottom: parent.bottom
            height: Theme.paddingSmall * 0.8
            width: parent.width * (webView.currentItem ?
                                       (webView.currentItem.loadProgress / 100.0) : 0)
            color: Theme.highlightBackgroundColor
            opacity: webView.currentItem && webView.currentItem.loading ? 1.0 : 0.0

            Behavior on width {
                enabled: progressBar.opacity == 1.0
                SmoothedAnimation {
                    velocity: 480; duration: 200
                }
            }
            Behavior on opacity { FadeAnimation {} }
        }

        TextField {
            id: searchField
            anchors.bottom: parent.bottom
            width: parent.width - buttons.width
            background: null
            labelVisible: false
            placeholderText: webView.currentItem && webView.currentItem.url ? webView.currentItem && webView.currentItem.url : "Enter url"
            textTopMargin: Theme.paddingMedium
            inputMethodHints: Qt.ImhNoAutoUppercase

            onFocusChanged: {
                if (focus) {
                    selectAll()
                } else {
                    deselect()
                }
            }

            EnterKey.onClicked: {
                if (webView.currentItem) {
                    webView.currentItem.load(text)
                    chrome.focus = true
                    searchField.text = Qt.binding(function() {
                        return webView.currentItem.url
                    })
                }
            }
        }

        Row {
            id: buttons

            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            spacing: Theme.paddingMedium

            IconButton {
                icon.source: "image://theme/icon-m-back"
                enabled: webView.currentItem && webView.currentItem.canGoBack
                onClicked: webView.currentItem.goBack()
            }

            IconButton {
                icon.source: "image://theme/icon-m-forward"
                enabled: webView.currentItem && webView.currentItem.canGoForward
                onClicked: webView.currentItem.goForward()
            }

            IconButton {
                icon.source: webView.currentItem && webView.currentItem.loading
                             ? "image://theme/icon-m-reset"
                             : "image://theme/icon-m-refresh"
                onClicked: {
                    if (webView.currentItem.loading) {
                        webView.currentItem.stop()
                    } else {
                        webView.currentItem.reload()
                    }
                }
            }
        }
    }

    InputRegion {
        window: webView.chromeWindow
        x: inputMask.x
        y: inputMask.y
        width: inputMask.width
        height: inputMask.height
    }
}

