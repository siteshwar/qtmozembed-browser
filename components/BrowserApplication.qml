/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

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
