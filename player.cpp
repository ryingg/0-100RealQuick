#include "player.h"

/* Music player controller qobject with qquickview, qmediaplayer, and qmediaplaylist
 * Public methods: view()
 * Creates ituneslist, qmediaplayer, qmediaplaylist, and appropriate settings
 * Waits for ituneslist to populate with songs
 * Sets view's context with data model of song list
 * Populates qmediaplaylist with song list audio files
 * Various controller methods to receive and send signals to model / view
 */
Player::Player(QObject *parent) : QObject(parent) {
    itunes_list = new ItunesList(); // itunes song list
    m_view = new QQuickView; // quick view
    m_player = new QMediaPlayer;
    m_player->setNotifyInterval(10); // shorten the notify interval for song progress
    m_player->setVolume(100); // set the volume
    m_playlist = new QMediaPlaylist; // create audio playlist
    m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce); // disable auto play

    QEventLoop loop; // wait for songListCreated signal
    QObject::connect((QObject*)itunes_list, SIGNAL(songListCreated()), &loop, SLOT(quit()));
    loop.exec();

    foreach(Song* song, itunes_list->playerSongList()) // populate qmediaplaylist with songs from itunes_list
    {
        m_playlist->addMedia(QUrl(song->songFileUrl())); // create playlist entry
    }
    m_player->setPlaylist(m_playlist); // set playlist
    m_playlist->setCurrentIndex(-1); // to invoke songchange on initial play

    m_view->setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = m_view->rootContext();
    ctxt->setContextProperty("songListModel", QVariant::fromValue(itunes_list->songList())); // expose songList as a model in QML
    m_view->setSource(QUrl("qrc:/view.qml"));
    m_view->show();
    QObject *root = m_view->rootObject();
    if(root)
        connect(root, SIGNAL(playPauseView(qint32)), this, SLOT(playPause(qint32))); // signal when stopped playing
    connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(finished(QMediaPlayer::State))); // signal when stopped playing
    connect(m_player, SIGNAL(positionChanged(qint64)), this, SLOT(position(qint64))); // signal when song position changed
}

// quick view accessor
QQuickView* Player::view() {
    return m_view;
}

// toggle play pause
void Player::playPause(qint32 index) {
    bool songChanged = false;
    if(m_playlist->currentIndex() != index) {
        m_playlist->setCurrentIndex(index);
        songChanged = true;
        QObject *controller = m_view->rootObject()->findChild<QObject*>("controller");;
        if(controller) {
            Song *curr_song = itunes_list->playerSongList()[index];
            QVariant title = curr_song->title();
            QVariant artist = curr_song->artist();
            QVariant url = curr_song->itunesUrl();
            qDebug() << "song changed to "+QString::number(index)+" "+title.toString()+" - "+artist.toString();
            QMetaObject::invokeMethod(controller, "setSongInfo", Q_ARG(QVariant, title), Q_ARG(QVariant, artist), Q_ARG(QVariant, url));
        }
    }

    if(!songChanged && m_player->state() == 1)
        m_player->pause();
    else
        m_player->play();
}

// change view and set next song if finished media
void Player::finished(QMediaPlayer::State state) {
    qDebug()<<"player state changed "<<state;
    QObject *root = m_view->rootObject();
    if(root) {
        if(state == QMediaPlayer::StoppedState) {
            qDebug("song ended");
//            QVariant returnedValue;
            QVariant index = m_playlist->currentIndex();
            QMetaObject::invokeMethod(root, "setStopState", // set next song
//                    Q_RETURN_ARG(QVariant, returnedValue),
                    Q_ARG(QVariant, index));
//            qDebug() << "QML function returned:" << returnedValue.toString();
        }
    }
}

//fade out song if less than 2 seconds left, update progress bar
void Player::position(qint64 position) {
    int time_left = (m_player->duration()-position);
    QObject *controller = m_view->rootObject()->findChild<QObject*>("controller");;
    if(controller) {
        int duration = m_player->duration(); //calculate % song finished
        float percent = 0;
        if(duration != 0) {
            percent = (float)position/(float)duration;
        }
//        qDebug()<<QString::number(percent);
        QMetaObject::invokeMethod(controller, "setPosition", Q_ARG(QVariant, percent));
    }
//    qDebug() << "time left "+QString::number(time_left);
    // fade out song
    if(time_left < 2500 && time_left > 0) { // vol stays for curr song
        qDebug()<<"lower volume "+QString::number(time_left/25);
        m_player->setVolume(time_left/25);
    }
    else { // vol resets for new song
        m_player->setVolume(100);
    }

}
