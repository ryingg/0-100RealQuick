#include "ituneslist.h"

/* Top itunes list qobject with network access and song list object which can easily be refactored into other feeds
 * Public methods: songList(), playerSongList()
 * Signals: songListCreated()
 * Creates temp file from URL with networkaccessmanager
 * Then parses into Song object from temp file with QXmlStreamReader
 * Appends to m_song_list and m_player_song_list for listviewmodel and qmediaplaylist respectively
 */
ItunesList::ItunesList(QObject *parent) : QObject(parent) {
    m_network_access_manager = new QNetworkAccessManager(this);
    connect(m_network_access_manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(buildSongList(QNetworkReply*))); // build song list from reply
    m_network_access_manager->get(QNetworkRequest(QUrl(ITUNES_URL))); // get reply from url
}

// song list accessor
QList<QObject*> ItunesList::songList() {
    return m_song_list;
}

// player song list accessor
QList<Song*> ItunesList::playerSongList() {
    return m_player_song_list;
}

// slot to build song list from file
void ItunesList::buildSongList( QNetworkReply * reply) {

    QTemporaryFile temp_file; // create temp xml file
    temp_file.open();
    temp_file.write(reply->readAll());
    temp_file.seek(0); //go to the begining

    QXmlStreamReader reader(&temp_file); // create xml stream reader from file
    song_count = 0; // count items
    while (!reader.atEnd() && !reader.hasError()) {
        reader.readNext();
        if (reader.isStartElement() && reader.name() == "entry") { // parse xml info
            song_count++;
            while(reader.name()!="name") reader.readNextStartElement(); // read song title
            QString title = reader.readElementText();
            while(reader.name()!="link") reader.readNextStartElement(); // read itunes url
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
            Song *song = new Song(QString::number(song_count), title, artist, album, image_url, song_file_url);
            m_song_list.append(song); // create song entry
            m_player_song_list.append(song);
        }
    }

    emit songListCreated(); // finished appending data
}
