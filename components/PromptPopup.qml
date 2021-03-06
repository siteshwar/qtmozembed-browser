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
    id: promptPopup

    property alias text: label.text
    property alias showCancel: cancelButton.visible

    contentBackground {
        width: Math.max(promptPopup.width * 0.7, buttons.width + Theme.paddingLarge * 2)
        height: content.height
        anchors.centerIn: promptPopup
    }

    Column {
        id: content

        width: parent.width
        spacing: Theme.paddingMedium

        PromptLabel {
            id: label
            maximumLineCount: 3
            elide: Text.ElideRight
            wrapMode: Text.Wrap
        }

        Row {
            id: buttons

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium
            Button {
                id: cancelButton
                text: "Cancel"
                onClicked: {
                    promptPopup.rejected()
                    promptPopup.done()
                }
            }


            Button {
                text: "Ok"
                onClicked: {
                    promptPopup.accepted()
                    promptPopup.done()
                }
            }
        }

        Item {
            width: 1
            height: Theme.paddingMedium
        }
    }
}
