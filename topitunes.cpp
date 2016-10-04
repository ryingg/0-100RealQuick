#include "topitunes.h"
// itunes object made to parse itunes xml, can easily be refactored into other feeds
// top itunes qobject with network access and song list object
TopItunes::TopItunes(QObject *parent) : QObject(parent) {
    m_network_access_manager = new QNetworkAccessManager(this);
    connect(m_network_access_manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(fileIsReady(QNetworkReply*))); // call fileisready after loaded
    m_network_access_manager->get(QNetworkRequest(QUrl(ITUNES_URL))); // get reply from url
}

// song list accessor
QList<QObject*> TopItunes::songList() {
    return m_song_list;
}

// playlist accessor
QMediaPlaylist* TopItunes::playlist() {
    return m_playlist;
}

// slot to build song list from file
void TopItunes::fileIsReady( QNetworkReply * reply) {
    m_playlist = new QMediaPlaylist; // create audio playlist

    QTemporaryFile temp_file; // create temp xml file
    temp_file.open();
    temp_file.write(reply->readAll());
    temp_file.seek(0); //go to the begining

    QXmlStreamReader reader(&temp_file); // create xml stream reader from file
    song_count = 0; // count items
    while (!reader.atEnd() && !reader.hasError()) {
        reader.readNext();
        if (reader.isStartElement() && reader.name() == "entry") {
            song_count++;
            while(reader.name()!="name") reader.readNextStartElement(); // read song title
            QString title = reader.readElementText();
            while(reader.name()!="link") reader.readNextStartElement(); // read itunes url
            while(reader.name()!="contentType") reader.readNextStartElement(); // skip to next element
            while(reader.name()!="link") reader.readNextStartElement(); // read song url
            QString song_url = reader.attributes().value("href").toString();
            while(reader.name()!="artist") reader.readNextStartElement(); // read artist
            QString artist = reader.readElementText();
            while(reader.name()!="image") reader.readNextStartElement(); // read image
            QString image_url = reader.readElementText();
            while(reader.name()!="collection") reader.readNextStartElement(); // read album
            while(reader.name()!="name") reader.readNextStartElement();
            QString album = reader.readElementText();
            m_song_list.append(new Song(QString::number(song_count), title, artist, album, image_url, song_url)); // create song entry
            m_playlist->addMedia(QUrl(song_url)); // create playlist entry
        }
    }
    m_playlist->setCurrentIndex(1);
    qDebug() << "length" << m_song_list.length();
    emit songListCreated(); // finished appending data
}
