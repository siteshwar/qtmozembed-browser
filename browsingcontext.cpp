/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

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
