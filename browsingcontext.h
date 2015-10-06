/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */


#ifndef BROWSING_CONTEXT_H
#define BROWSING_CONTEXT_H

#include <QObject>

class BrowsingContext : public QObject {
    Q_OBJECT
    Q_PROPERTY(qreal pixelRatio READ pixelRatio WRITE setPixelRatio NOTIFY pixelRatioChanged FINAL)

public:
    BrowsingContext(QObject *parent = 0);

    qreal pixelRatio() const;
    void setPixelRatio(qreal pixelRatio);

    Q_INVOKABLE void setPreference(const QString& name, const QVariant& value);

signals:
    void pixelRatioChanged();
    void completed();
};

#endif // BROWSING_CONTEXT_H
