#include "ituneslist.h"

/* Top itunes list QObject with network access and song list object
 *
 * Private variables:       m_network_access_manager, m_song_list, m_player_song_list, m_song_count
 * Public functions:
 *      songList()          song list accessor for ListView returns QList<QObject*>
 *      playerSongList()    song list accessor for Player returns QList<Song*>
 * Signals:
 *      songListCreated()   signal that song list has been created
 * Private Slots:
 *      buildSongList(QNetworkReply*)   slot to build song list from file
 */

/* gets xml content from itunes url */
ItunesList::ItunesList(QObject *parent) : QObject(parent) {
    m_network_access_manager = new QNetworkAccessManager(this);
    connect(m_network_access_manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(buildSongList(QNetworkReply*))); // get url content signal to build songlist slot
    m_network_access_manager->get(QNetworkRequest(QUrl(ITUNES_URL))); // get reply from url
}

/* song list accessor
 * params:  none
 * return:  m_song_list, the song list for ListView model
 */
QList<QObject*> ItunesList::songList() {
    return m_song_list;
}

/* player song list accessor
 * params:  none
 * return:  m_player_song_list, the song list for QMediaPlaylist
 */
QList<Song*> ItunesList::playerSongList() {
    return m_player_song_list;
}

/* slot to build song list from network reply
 * params:  reply, the network reply
 * return:  void
 */
void ItunesList::buildSongList( QNetworkReply * reply) {
    int song_index = 0;
    QTemporaryFile temp_file; // create temp xml file
    temp_file.open();
    temp_file.write(reply->readAll());
    temp_file.seek(0); //go to the begining of file

    QXmlStreamReader reader(&temp_file); // create xml stream reader from file
    while (!reader.atEnd() && !reader.hasError()) {
        reader.readNext();
        if (reader.isStartElement() && reader.name() == "entry") { // parse each song
            song_index++; // increment index
            while(reader.name()!="name") reader.readNextStartElement(); // read song title
            QString title = reader.readElementText();
            while(reader.name()!="link") reader.readNextStartElement(); // read itunes url
            QString itunes_url = reader.attributes().value("href").toString();
            while(reader.name()!="contentType") reader.readNextStartElement(); // skip to next element
            while(reader.name()!="link") reader.readNextStartElement(); // read song url
            QString song_file_url = reader.attributes().value("href").toString();
            while(reader.name()!="artist") reader.readNextStartElement(); // read artist
            QString artist = reader.readElementText();
            while(reader.name()!="image") reader.readNextStartElement(); // read image
            reader.readNextStartElement(); // skip 55x55 image
            reader.readNextStartElement(); // skip 60x60 image
            QString image_url = reader.readElementText();
            while(reader.name()!="collection") reader.readNextStartElement(); // read album
            while(reader.name()!="name") reader.readNextStartElement();
            QString album = reader.readElementText();
            Song *song = new Song(QString::number(song_index), title, artist, album, image_url, itunes_url, song_file_url);
            m_song_list.append(song); // create song entry
            m_player_song_list.append(song);
        }
    }
    emit songListCreated(); // finished appending data, signal to Player
}
