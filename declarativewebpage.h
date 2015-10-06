/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DECLARATIVEWEBPAGE_H
#define DECLARATIVEWEBPAGE_H

#include <qopenglwebpage.h>
#include <qqml.h>


class DeclarativeWebPage : public QOpenGLWebPage {
    Q_OBJECT

public:
    DeclarativeWebPage(QObject *parent = 0);
};

#endif // DECLARATIVEWEBPAGE_H
