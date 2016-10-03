#ifndef TOPITUNES_H
#define TOPITUNES_H

#include <QObject>
#include <QNetworkAccessManager> // for network access
#include <QXmlStreamReader> // read xml
#include <QNetworkReply>
#include <QTemporaryFile> // for xml file writing

#include "song.h"

const QString ITUNES_URL = "https://itunes.apple.com/us/rss/topsongs/limit=100/xml";

// top itunes qobject with network access and song list object
class TopItunes : public QObject {
    Q_OBJECT
public:
    explicit TopItunes(QObject *parent = 0);
    QList<QObject*> songList(); // song list accessor
private:
    QList<QObject*> m_songList; // member var list of songs
signals:
    void songListCreated(); // signal after song list has been created
private slots:
    void fileIsReady(QNetworkReply* p_reply); // slot to build song list from file
};

#endif
