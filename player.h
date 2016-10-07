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

/* Music player controller qobject with qquickview, qmediaplayer, and qmediaplaylist
 * Public methods: view()
 */
class Player : public QObject {
    Q_OBJECT
public:
    explicit Player(QObject *parent = 0);
    QQuickView* view(); // quick view accessor
private:
    QQuickView* m_view; // quick view
    QObject* m_controller; // view controller
    QMediaPlayer* m_player; // qmediaplayer
    QMediaPlaylist* m_playlist; // qmediaplaylist
    ItunesList *itunes_list; // itunes list object
signals:
private slots:
    void play(qint32 index); // play media
    void pause(); // pause media
    void restart(); // pause media
    void setSongView(QMediaContent); // set song view
    void finished(QMediaPlayer::State state); // finished media
    void position(qint64 position); // update view position
    void setPosition(qreal percent); // update qmedia position
    void setAutoplay(bool autoplay); // set autoplay
};

#endif // PLAYER_H
