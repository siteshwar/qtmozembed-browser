import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: chrome

    property Item webPage

    onWebPageChanged: {
        webPage.parent = chrome
        webPage.z = -1
    }

    Rectangle {
        color: "black"
        opacity: 0.8
        anchors.fill: searchField

    }

    TextField {
        id: searchField
        anchors.bottom: parent.bottom
        width: parent.width
        background: null
        labelVisible: false
        placeholderText: "Enter url"
        textTopMargin: Theme.paddingMedium
        inputMethodHints: Qt.ImhNoAutoUppercase

        EnterKey.onClicked: {
            webPage.load(text)
            webPage.focus = true
        }
    }
}

