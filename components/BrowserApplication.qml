/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.1
import QtMozEmbed.Browser 1.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: window

    property alias backgroundWindow: window._mainWindow

    allowedOrientations: Orientation.Portrait

    // Not for public use!
    _backgroundVisible: false
    _clippingItem.clip: false
    _clippingItem.opacity: 1.0

    cover: null
}
