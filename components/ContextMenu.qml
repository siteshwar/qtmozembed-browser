/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Dmitry Rozhkov <dmitry.rozhkov@jolla.com>
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

import QtQuick 2.1
import Sailfish.Silica 1.0

Item {
    id: root

    property string linkHref
    property string linkTitle
    property string imageSrc
    property string contentType
    property QtObject webPage

    readonly property bool active: visible

    function show() {
        opacity = 1.0
    }

    function close() {
        opacity = 0.0
    }

    opacity: 0.0
    width: parent.width
    height: parent.height

    onOpacityChanged: {
        if (opacity == 0.0) {
            root.destroy()
        }
    }

    Behavior on opacity { FadeAnimation { duration: 300 } }

    Rectangle {
        color: "black"
        opacity: 0.9
        anchors.fill: parent
    }

    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge*2

        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.linkTitle.length > 0
            text: root.linkTitle
            width: root.width - Theme.paddingLarge*2
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraLarge
            horizontalAlignment: Text.AlignHCenter
            opacity: .6
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: root.imageSrc.length > 0 ? root.imageSrc : root.linkHref
            width: root.width - Theme.paddingLarge*2
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 4
            font.pixelSize: title.visible ? Theme.fontSizeMedium : Theme.fontSizeExtraLarge
            horizontalAlignment: Text.AlignHCenter
            opacity: .6
        }
    }

    Column {
        id: menu

        property Item highlightedItem

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.itemSizeSmall
        width: parent.width

        MenuItem {
            visible: root.linkHref.length > 0 && root.imageSrc.length === 0
            text: "Open link"

            onClicked: {
                webPage.load(root.linkHref)
                root.close()
            }
        }

        MenuItem {
            visible: root.linkHref.length > 0 && root.imageSrc.length === 0
            text: "Share"
        }

        MenuItem {
            visible: root.imageSrc.length > 0
            text: "Save to Gallery"
            onClicked: {
                console.log("Saving to gallery...")
            }
        }

        MenuItem {
            visible: root.linkHref.length > 0 && root.imageSrc.length === 0
            text: "Copy to clipboard"

            onClicked: {
                Clipboard.text = root.linkHref
                root.close()
            }
        }

        MenuItem {
            visible: imageSrc.length > 0
            text: "Open image"

            onClicked: {
                webPage.load(root.imageSrc)
                root.close()
            }
        }

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
    }

    MouseArea {
        anchors.fill: parent
        onPressed: menu.highlightItem(mouse.y - menu.y)
        onPositionChanged: menu.highlightItem(mouse.y - menu.y)
        onCanceled:  menu.setHighlightedItem(null)
        onReleased: {
            if (menu.highlightedItem !== null) {
                menu.highlightedItem.down = false
                menu.highlightedItem.clicked()
            } else {
                onClicked: root.close()
            }
        }
    }

    Component.onCompleted: parent.popupActive = true
    Component.onDestruction: {
        console.log("Parent...", parent)
        parent.popupActive = false
    }
}
