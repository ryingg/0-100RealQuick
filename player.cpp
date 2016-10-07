#include "player.h"


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

/* Instantiates ItunesList, QMediaPlayer, QMediaPlaylist, signals/slots, and default settings */
Player::Player(QObject *parent) : QObject(parent) {
    itunes_list = new ItunesList();
    m_view = new QQuickView;
    m_player = new QMediaPlayer;
    m_playlist = new QMediaPlaylist;
    m_player->setNotifyInterval(10); // shorten the notify interval for song progress
    m_player->setVolume(100); // set the volume
    m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce); // disable autoplay

    /* wait for songListCreated signal */
    QEventLoop loop;
    QObject::connect((QObject*)itunes_list, SIGNAL(songListCreated()), &loop, SLOT(quit()));
    loop.exec();

    /* populate qmediaplaylist with songs from itunes_list and set up signal/slots for player */
    foreach(Song* song, itunes_list->playerSongList())
        m_playlist->addMedia(QUrl(song->songFileUrl())); // create playlist entry
    m_player->setPlaylist(m_playlist); // set playlist
    m_playlist->setCurrentIndex(-1); // to disable highlight on load
    connect(m_player, SIGNAL(currentMediaChanged(QMediaContent)), this, SLOT(setSongView())); // signal when stopped playing
    connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(finished(QMediaPlayer::State))); // signal when stopped playing
    connect(m_player, SIGNAL(positionChanged(qint64)), this, SLOT(position(qint64))); // signal when song qmediaplayer position changed
    connect(m_player, SIGNAL(error(QMediaPlayer::Error)), this, SLOT(error())); // signal when qmediaplayer errors

    /* set song list as model for the QML view */
    m_view->setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = m_view->rootContext();
    ctxt->setContextProperty("songListModel", QVariant::fromValue(itunes_list->songList()));
    m_view->setSource(QUrl("qrc:/view.qml"));
    m_view->show();

    /* setup signal/slot connections with the QML view and controller */
    QObject *root = m_view->rootObject();
    if(root) {
        m_controller = root->findChild<QObject*>("controller");
        connect(root, SIGNAL(playView(qint32)), this, SLOT(play(qint32))); // view play signal
        connect(root, SIGNAL(pauseView()), this, SLOT(pause())); // view pause signal
        connect(root, SIGNAL(restartView(qint32)), this, SLOT(restart(qint32))); // view restart signal
        if(m_controller) {
            connect(m_controller, SIGNAL(setPositionView(qreal)), this, SLOT(setPosition(qreal))); // view position signal
            connect(m_controller, SIGNAL(setAutoplayView(bool)), this, SLOT(setAutoplay(bool))); // set autoplay signal
        }
    }
}

/* play song at index
 * params:  index, the song index
 * return:  void
 */
void Player::play(qint32 index) {
    if(m_playlist->currentIndex() != index) { // new song
        m_playlist->setCurrentIndex(index); // set index in playlist
    }
    m_player->play();
}

/* pause song
 * params:  none
 * return:  void
 */
void Player::pause() {
    m_player->pause();
}

/* restart song at index
 * params:  index, the song index
 * return:  void
 */
void Player::restart(qint32 index) {
    if(m_playlist->currentIndex() != index) { // new song, if from stopped position
        m_playlist->setCurrentIndex(index); // set index in playlist
    }
    m_player->setPosition(0);
    m_player->play();
}

/* set QML view to current song
 * params:  none
 * return:  void
 */
void Player::setSongView() {
    int index = m_playlist->currentIndex();
    if(index != -1) { // not in stopped state
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

/* set stop state and send signal to view if no error
 * params:  state, the QMediaPlayer state
 * return:  void
 */
void Player::finished(QMediaPlayer::State state) {
    if(state == QMediaPlayer::StoppedState && m_player->error() == 0) { // if no error
        QObject *root = m_view->rootObject();
        QMetaObject::invokeMethod(root, "setStopState"); // stop view
    }
}

/* set QML view progress bar position and fade song if <2.5 seconds left
 * params:  position, the QMediaPlayer position
 * return:  void
 */
void Player::position(qint64 position) {
    int time_left = (m_player->duration()-position);
    if(m_controller) {
        int duration = m_player->duration(); //calculate % song finished
        float percent = 0;
        if(duration != 0)
            percent = (float)position/(float)duration;
        QMetaObject::invokeMethod(m_controller, "setPosition", Q_ARG(QVariant, percent)); // set view
    }
    /* fade out end of song */
    if(time_left < 2500 && time_left > 0) // vol lowers for curr song
        m_player->setVolume(time_left/25);
    else // vol resets for new song
        m_player->setVolume(100);
}

/* set QMediaPlayer position from view
 * params:  percent, the percent position of total progress bar clicked
 * return:  void
 */
void Player::setPosition(qreal percent) {
    long long int position = percent*m_player->duration(); // calculate player position
    m_player->setPosition(position);
}

/* set QMediaPlaylist autoplay
 * params:  autoplay, true or false
 * return:  void
 */
void Player::setAutoplay(bool autoplay) {
    if (autoplay) // enable auto play
        m_playlist->setPlaybackMode(QMediaPlaylist::Sequential);
    else // disable autoplay
        m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
}

/* handle media error, disables autoplay and sets view
 * params:  none
 * return:  void
 */
void Player::error() {
    m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce); // disable auto play
    QObject *root = m_view->rootObject();
    QMetaObject::invokeMethod(root, "setError"); // error view
}
