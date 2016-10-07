#ifndef PLAYER_H
#define PLAYER_H

#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <qqmlcontext.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>
#include "song.h"
#include "ituneslist.h"

/* Music player controller QObject with QQuickView, QMediaPlayer, and QMediaPlaylist
 *
 * Private variables:                   m_view, m_controller, m_player, m_playlist, itunes_list
 * Private Slots:
 *      play(qint32)                    play song at index
 *      pause()                         pause song
 *      restart(qint32)                 restart song at index
 *      setSongView()                   set QML view to current song
 *      finished(QMediaPlayer::State)   set stop state
 *      position(qint64)                set QML view progress bar position and adj volume
 *      setPosition(qreal)              set QMediaPlayer position from view
 *      setAutoPlay(bool)               set QMediaPlaylist autoplay
 *      error()                         handle media error
 */

class Player : public QObject {
    Q_OBJECT

public:
    explicit Player(QObject *parent = 0);

private:
    QQuickView* m_view;         // quick view QML
    QObject* m_controller;      // view controller QML
    QMediaPlayer* m_player;     // backend media player
    QMediaPlaylist* m_playlist; // backend media playlist
    ItunesList *itunes_list;    // itunes list object
private slots:
    void play(qint32);
    void pause();
    void restart(qint32);
    void setSongView();
    void finished(QMediaPlayer::State);
    void position(qint64);
    void setPosition(qreal);
    void setAutoplay(bool);
    void error();
};

#endif // PLAYER_H
