/****************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Dmitry Rozhkov <dmitry.rozhkov@jollamobile.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.1
import Sailfish.Silica 1.0

DialogBase {
    id: dialog
    property alias acceptText: header.acceptText
    property alias text: label.text
    property alias title: header.title

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: !label.largeFont ? Theme.paddingLarge : Theme.itemSizeSmall

            DialogHeader {
                id: header
                dialog: dialog
                _glassOnly: true
            }

            PromptLabel {
                id: label
            }
        }
    }
}
