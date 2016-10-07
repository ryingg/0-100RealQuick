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
    m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce); // disable autoplay

    QEventLoop loop; // wait for songListCreated signal
    QObject::connect((QObject*)itunes_list, SIGNAL(songListCreated()), &loop, SLOT(quit()));
    loop.exec();

    foreach(Song* song, itunes_list->playerSongList()) // populate qmediaplaylist with songs from itunes_list
    {
        m_playlist->addMedia(QUrl(song->songFileUrl())); // create playlist entry
    }
    m_player->setPlaylist(m_playlist); // set playlist
    m_playlist->setCurrentIndex(-1); // to invoke songchange on initial play

    itunes_list->songList().append(new Song("000", "title", "artist", "album", "image_url", "itunes_url", "song_file_url"));

    m_view->setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = m_view->rootContext();
    ctxt->setContextProperty("songListModel", QVariant::fromValue(itunes_list->songList())); // expose songList as a model in QML
    m_view->setSource(QUrl("qrc:/view.qml"));
    m_view->show();
    QObject *root = m_view->rootObject();
    if(root) {
        m_controller = root->findChild<QObject*>("controller");
        connect(root, SIGNAL(playView(qint32)), this, SLOT(play(qint32))); // view play signal
        connect(root, SIGNAL(pauseView()), this, SLOT(pause())); // view pause signal
        connect(root, SIGNAL(restartView()), this, SLOT(restart())); // view restart signal
        if(m_controller) {
            connect(m_controller, SIGNAL(setPositionView(qreal)), this, SLOT(setPosition(qreal))); // view position signal
            connect(m_controller, SIGNAL(setAutoplayView(bool)), this, SLOT(setAutoplay(bool))); // set autoplay signal
        }
    }
    connect(m_player, SIGNAL(currentMediaChanged(QMediaContent)), this, SLOT(setSongView(QMediaContent))); // signal when stopped playing
    connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(finished(QMediaPlayer::State))); // signal when stopped playing
    connect(m_player, SIGNAL(positionChanged(qint64)), this, SLOT(position(qint64))); // signal when song qmediaplayer position changed
}

// quick view accessor
QQuickView* Player::view() {
    return m_view;
}

// play song
void Player::play(qint32 index) {
    if(m_playlist->currentIndex() != index) { // new song
        m_playlist->setCurrentIndex(index); // set index in playlist
    }
    m_player->play();
}

// pause song
void Player::pause() {
    m_player->pause();
}

// restart song
void Player::restart() {
    m_player->setPosition(0);
    m_player->play();
}

// set song view
void Player::setSongView(QMediaContent) {
    int index = m_playlist->currentIndex();
    if(index != -1) { // not in stopped state
        qDebug()<<"set song view "<<index;
        QObject *root = m_view->rootObject(); // set view active song
        QMetaObject::invokeMethod(root, "setActive", Q_ARG(QVariant, index));

        if(m_controller) { // set controller song info
            Song *curr_song = itunes_list->playerSongList()[index];
            QVariant title = curr_song->title();
            QVariant artist = curr_song->artist();
            QVariant url = curr_song->itunesUrl();
            QMetaObject::invokeMethod(m_controller, "setSongInfo", Q_ARG(QVariant, title), Q_ARG(QVariant, artist), Q_ARG(QVariant, url));
        }

    }
}

// slot to send signal to view to set stop state
void Player::finished(QMediaPlayer::State state) {
    qDebug()<<"player state changed "<<state;
    QObject *root = m_view->rootObject();
    if(state == QMediaPlayer::StoppedState) {
        QMetaObject::invokeMethod(root, "setStopState"); // stop view
    }
}

// slot to receive qmediaplayer position, fade out if <2 seconds left, update progress bar
void Player::position(qint64 position) {
    int time_left = (m_player->duration()-position);
    if(m_controller) {
        int duration = m_player->duration(); //calculate % song finished
        float percent = 0;
        if(duration != 0) {
            percent = (float)position/(float)duration;
        }
        QMetaObject::invokeMethod(m_controller, "setPosition", Q_ARG(QVariant, percent));
    }
    // fade out song
    if(time_left < 2500 && time_left > 0) { // vol lowers for curr song
        m_player->setVolume(time_left/25);
    }
    else { // vol resets for new song
        m_player->setVolume(100);
    }

}

// slot to set qmediaplayer position
void Player::setPosition(qreal percent) {
    long long int position = percent*m_player->duration(); // calculate position
    m_player->setPosition(position);
    qDebug()<<"pos set perc "+QString::number(percent)+" pos "+QString::number(position);
}

// slot to set autoplay
void Player::setAutoplay(bool autoplay) {
    if (autoplay) // enable auto play
        m_playlist->setPlaybackMode(QMediaPlaylist::Sequential);
    else // disable autoplay
        m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
}
