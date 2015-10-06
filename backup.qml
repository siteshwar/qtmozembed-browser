/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.0

Rectangle {
    width: 100
    height: 62

// No platform style alert
    var alertComponent = Qt.createComponent("components/PromptPopup.qml")
    var alertDialog = alertComponent.createObject(webView.chrome,
                                                        {
                                                            "text": data.text,
                                                            "showCancel": false
                                                        })
    alertDialog.show()

// No platform style confirm
    var confirmComponent = Qt.createComponent("components/PromptPopup.qml")
    var confirmDialog = confirmComponent.createObject(webView.chrome,
                                               {
                                                   "text": data.text
                                               })
    confirmDialog.show()



}

