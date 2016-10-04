#include "player.h"

Player::Player(QObject *parent) : QObject(parent) {
    itunes_list = new ItunesList(); // itunes song list
    m_view = new QQuickView; // quick view
    m_player = new QMediaPlayer;
    m_player->setNotifyInterval(100); // shorten the notify interval
    m_player->setVolume(100); // set the volume
    m_playlist = new QMediaPlaylist; // create audio playlist
    m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);

    QEventLoop loop; // wait for songListCreated signal
    QObject::connect((QObject*)itunes_list, SIGNAL(songListCreated()), &loop, SLOT(quit()));
    loop.exec();

    m_view->setResizeMode(QQuickView::SizeRootObjectToView); // expose songList as a model in QML
    QQmlContext *ctxt = m_view->rootContext();
    ctxt->setContextProperty("songListModel", QVariant::fromValue(itunes_list->songList()));
    m_view->setSource(QUrl("qrc:/view.qml"));
    m_view->show();

    foreach(Song* song, itunes_list->playerSongList()) // populate qmediaplaylist with songs from itunes_list
    {
        connect(song, SIGNAL(playPause(QString)), this, SLOT(play(QString)));
        m_playlist->addMedia(QUrl(song->songFileUrl())); // create playlist entry
    }
    m_player->setPlaylist(m_playlist); // set playlist
    connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(stop(QMediaPlayer::State))); // signal when stopped playing
    connect(m_player, SIGNAL(positionChanged(qint64)), this, SLOT(fadeout(qint64))); // signal when song position xhanged
}

// quick view accessor
QQuickView* Player::view() {
    return m_view;
}

void Player::play(QString index) {
    int list_index = index.toInt()-1;
    bool songChanged = false;
    if(m_playlist->currentIndex() != list_index) {
        qDebug() << "changed to "+index;
        m_playlist->setCurrentIndex(list_index);
        songChanged = true;
    }
    if(!songChanged && m_player->state() == 1)
        m_player->pause();
    else
        m_player->play();
}

void Player::stop(QMediaPlayer::State state) {
    qDebug("status changed");
    QObject *root = m_view->rootObject();
    if(root) {
        qDebug()<<state;
        if(state == QMediaPlayer::StoppedState) {
            qDebug("ended");

            auto rect = root->findChild<QObject *>("view");
            QVariant returnedValue;
            QVariant msg = "Hello from C++";
            QMetaObject::invokeMethod(rect, "myQmlFunction",
                    Q_RETURN_ARG(QVariant, returnedValue),
                    Q_ARG(QVariant, msg));
            qDebug() << "QML function returned:" << returnedValue.toString();
        }
    }
}

//fade out song if less than 2 seconds left
void Player::fadeout(qint64 position) {
    int time_left = (m_player->duration()-position);
    qDebug() << "time left "+QString::number(time_left);
    if(time_left < 2000 && time_left > 0) {
        qDebug()<<"lower volume "+QString::number(time_left/20);
        m_player->setVolume(time_left/20);
    }
    else {
        qDebug()<<"volume 100";
        m_player->setVolume(100);
    }

}
