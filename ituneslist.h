#ifndef ITUNESLIST_H
#define ITUNESLIST_H

#include <QObject>
#include <QNetworkAccessManager> // for network access
#include <QXmlStreamReader> // read xml
#include <QXmlStreamAttributes>
#include <QNetworkReply>
#include <QTemporaryFile> // for xml file writing

#include "song.h"

const QString ITUNES_URL = "https://itunes.apple.com/us/rss/topsongs/limit=100/xml";

/* Top itunes list qobject with network access and song list object
 * Public methods: songList(), playerSongList()
 * Signals: songListCreated()
 */
class ItunesList : public QObject {
    Q_OBJECT
public:
    explicit ItunesList(QObject *parent = 0);
    QList<QObject*> songList(); // song list accessor
    QList<Song*> playerSongList(); // player song list accessor
private:
    QNetworkAccessManager *m_network_access_manager; // network access manager
    QList<QObject*> m_song_list; // member var list of song info
    QList<Song*> m_player_song_list; // song list for player's qmediaplaylist
    int song_count; // number of songs
signals:
    void songListCreated(); // signal after song list has been created
private slots:
    void buildSongList(QNetworkReply* p_reply); // slot to build song list from file
};

#endif
