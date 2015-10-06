/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.2
import Sailfish.Silica 1.0

Popup {
    id: contextPopup

    property string linkHref
    property string linkTitle
    property string imageSrc
    property string contentType
    property QtObject webPage

    property int contextPositionX
    property int contextPositionY

    function close() {
        hide()
    }

    contentBackground {
        width: contextPopup.width * 0.5
        height: content.height + Theme.paddingLarge * 2
        x: Math.max(0, (Math.max(contextPositionX, contextPopup.width - width) - width / 4))
        y: Math.max(contextPositionY, contextPopup.height - height)
    }

    Column {
        id: content

        property Item highlightedItem

        function highlightItem(yPos) {
            var xPos = width/2
            var child = childAt(xPos, yPos)
            if (!child) {
                setHighlightedItem(null)
                return
            }
            var parentItem
            while (child) {
                if (child && child.hasOwnProperty("__silica_menuitem") && child.enabled) {
                    setHighlightedItem(child)
                    break
                }
                parentItem = child
                yPos = parentItem.mapToItem(child, xPos, yPos).y
                child = parentItem.childAt(xPos, yPos)
            }
        }

        function setHighlightedItem(item) {
            if (item === highlightedItem) {
                return
            }
            if (highlightedItem) {
                highlightedItem.down = false
            }
            highlightedItem = item
            if (highlightedItem) {
                highlightedItem.down = true
            }
        }

        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge

        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            visible: contextPopup.linkTitle.length > 0
            text: contextPopup.linkTitle
            width: parent.width - Theme.paddingMedium * 2
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            height: Theme.paddingMedium
            width: 1
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: contextPopup.imageSrc.length > 0 ? contextPopup.imageSrc : contextPopup.linkHref
            width: parent.width - Theme.paddingMedium * 2
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 4
            font.pixelSize: title.visible ? Theme.fontSizeMedium : Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
        }

        MenuItem {
            visible: contextPopup.linkHref.length > 0 && contextPopup.imageSrc.length === 0
            text: "Open link"

            onClicked: {
                webPage.load(contextPopup.linkHref)
                contextPopup.close()
            }
        }

        MenuItem {
            visible: contextPopup.linkHref.length > 0 && contextPopup.imageSrc.length === 0
            text: "Share"
        }

        MenuItem {
            visible: contextPopup.imageSrc.length > 0
            text: "Save to Gallery"
            onClicked: {
                console.log("Saving to gallery...")
            }
        }

        MenuItem {
            visible: contextPopup.linkHref.length > 0 && contextPopup.imageSrc.length === 0
            text: "Copy to clipboard"

            onClicked: {
                Clipboard.text = contextPopup.linkHref
                contextPopup.close()
            }
        }

        MenuItem {
            visible: imageSrc.length > 0
            text: "Open image"

            onClicked: {
                webPage.load(contextPopup.imageSrc)
                contextPopup.close()
            }
        }
    }

    MouseArea {
        anchors.fill: content
        onPressed: content.highlightItem(mouse.y - content.y)
        onPositionChanged: content.highlightItem(mouse.y - content.y)
        onCanceled:  content.setHighlightedItem(null)
        onReleased: {
            if (content.highlightedItem !== null) {
                content.highlightedItem.down = false
                content.highlightedItem.clicked()
            } else {
                onClicked: contextPopup.close()
            }
        }
    }
}
