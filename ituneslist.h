#ifndef ITUNESLIST_H
#define ITUNESLIST_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QXmlStreamReader>
#include <QTemporaryFile>
#include "song.h"

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

const QString ITUNES_URL = "https://itunes.apple.com/us/rss/topsongs/limit=100/xml";

class ItunesList : public QObject {
    Q_OBJECT
public:
    explicit ItunesList(QObject *parent = 0);
    QList<QObject*> songList();
    QList<Song*> playerSongList();
private:
    QNetworkAccessManager *m_network_access_manager;    // network access manager
    QList<QObject*> m_song_list;                        // list of song info for ListView
    QList<Song*> m_player_song_list;                    // list of song info for QMediaPlaylist
signals:
    void songListCreated();
private slots:
    void buildSongList(QNetworkReply*);
};

#endif
