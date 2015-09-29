/****************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Dmitry Rozhkov <dmitry.rozhkov@jolla.com>
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

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
