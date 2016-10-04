#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <qqmlcontext.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>
#include "song.h"
#include "ituneslist.h"

// music player controller
class Player : public QObject {
    Q_OBJECT
public:
    explicit Player(QObject *parent = 0);
    QQuickView* view(); // quick view accessor
    ItunesList *itunes_list;
private:
    QQuickView* m_view; // quick view
    QMediaPlayer* m_player; // qmediaplayer
    QMediaPlaylist* m_playlist; // qmediaplaylist
signals:
private slots:
public slots:
    void play(QString index);
    void stop(QMediaPlayer::State state);
    void fadeout(qint64 position);
};


#endif // PLAYER_H
