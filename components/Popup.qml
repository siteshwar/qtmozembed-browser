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

MouseArea {
    id: promptPopup

    property alias contentBackground: popupBox
    default property alias popupChildren: popupBox.children

    signal accepted
    signal rejected
    signal done

    function show() {
        opacity = 1.0
        scaleAnimator.easing.type = Easing.InCubic
        popupBox.scale = 1.0
    }

    function hide() {
        opacity = 0.0
        scaleAnimator.easing.type = Easing.OutCubic
        popupBox.scale = 0.0
    }

    opacity: 0.0
    anchors.fill: parent
    enabled: opacity == 1.0

    onOpacityChanged: {
        if (opacity == 0.0) {
            parent.popupActive = false
            promptPopup.destroy()
        }
    }

    onDone: hide()

    Behavior on opacity { FadeAnimation { duration: 300 } }

    onClicked: {
        rejected()
        done()
    }

    Rectangle {
        anchors.fill: parent
        color: "#202020"
        opacity: 0.8
    }

    Rectangle {
        id: popupBox

        color: "black"
        radius: Theme.paddingSmall
        scale: 0.0

        Behavior on scale {
            ScaleAnimator {
                id: scaleAnimator
                duration: 300
            }
        }
    }

    Component.onCompleted: parent.popupActive = true
    Component.onDestruction: parent.popupActive = false
}
