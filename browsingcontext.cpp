/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "browsingcontext.h"

#include <qmozcontext.h>

BrowsingContext::BrowsingContext(QObject *parent)
    : QObject(parent)
{
    connect(QMozContext::GetInstance(), SIGNAL(onInitialized()), this, SIGNAL(completed()));
}

qreal BrowsingContext::pixelRatio() const
{
    return QMozContext::GetInstance()->pixelRatio();
}

void BrowsingContext::setPixelRatio(qreal pixelRatio)
{
    QMozContext::GetInstance()->setPixelRatio(pixelRatio);
}

void BrowsingContext::setPreference(const QString &name, const QVariant &value)
{
    QMozContext::GetInstance()->setPref(name, value);
}
