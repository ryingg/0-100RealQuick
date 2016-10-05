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
    QMediaPlayer* m_player; // qmediaplayer
    QMediaPlaylist* m_playlist; // qmediaplaylist
    ItunesList *itunes_list; // itunes list object
signals:
private slots:
    void playPause(qint32 index); // toggle play or pause media
    void finished(QMediaPlayer::State state); // finished media
    void position(qint64 position); // fade out song
};

#endif // PLAYER_H
