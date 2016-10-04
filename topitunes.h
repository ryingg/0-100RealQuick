#ifndef TOPITUNES_H
#define TOPITUNES_H

#include <QObject>
#include <QNetworkAccessManager> // for network access
#include <QXmlStreamReader> // read xml
#include <QXmlStreamAttributes>
#include <QNetworkReply>
#include <QTemporaryFile> // for xml file writing
#include <QMediaPlaylist>

#include "song.h"

const QString ITUNES_URL = "https://itunes.apple.com/us/rss/topsongs/limit=100/xml";

// top itunes qobject with network access and song list object
class TopItunes : public QObject {
    Q_OBJECT
public:
    explicit TopItunes(QObject *parent = 0);
    QList<QObject*> songList(); // song list accessor
    QMediaPlaylist* playlist(); // playlist accessor
private:
    QList<QObject*> m_song_list; // member var list of song info
    QMediaPlaylist* m_playlist; // media playlist of song audio files
    QNetworkAccessManager *m_network_access_manager; // network access manager
    int song_count; // number of songs
signals:
    void songListCreated(); // signal after song list has been created
private slots:
    void fileIsReady(QNetworkReply* p_reply); // slot to build song list from file
};

#endif
