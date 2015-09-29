/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

#ifndef INPUTREGION_PRIVATE_H
#define INPUTREGION_PRIVATE_H

#include <QObject>
#include <QWindow>
#include "inputregion.h"

class InputRegionPrivate {
public:
    InputRegionPrivate(InputRegion *q);

    void scheduleUpdate();
    void update();

    qreal x;
    qreal y;
    qreal width;
    qreal height;
    QWindow *window;
    InputRegion *q_ptr;
    int updateTimerId;

    Q_DECLARE_PUBLIC(InputRegion)
};

#endif
