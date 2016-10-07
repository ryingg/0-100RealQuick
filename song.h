#ifndef SONG_H
#define SONG_H

#include <QObject>

/* Song QObject holding information for ListView model and QMediaPlaylist
 *
 * QObject properties:  index, title, artist, album, album image
 * Private variables:   m_index, m_title, m_artist, m_album, m_image_url, m_itunes_url, m_song_file_url
 * Public functions:
 *      index()         index accessor for QObject returns QString
 *      title()         title accessor for QObject returns QString
 *      artist()        artist accessor for QObject returns QString
 *      album()         album accessor for QObject returns QString
 *      imageUrl()      album image accessor for QOBject returns QString
 *      itunesUrl()     iTunes URL accessor for QOBject returns QString
 *      songFileUrl()   song file accessor for QMediaPlaylist returns QString
 *
 */

class Song : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString index READ index CONSTANT)
    Q_PROPERTY(QString title READ title CONSTANT)
    Q_PROPERTY(QString artist READ artist CONSTANT)
    Q_PROPERTY(QString album READ album CONSTANT)
    Q_PROPERTY(QString imageUrl READ imageUrl CONSTANT)
public:
    explicit Song(QObject *parent=0);
    explicit Song(const QString &index, const QString &title, const QString &artist, const QString &album,
                  const QString &image_url, const QString &itunes_url, const QString &song_file_url, QObject *parent=0);
    QString index() const;
    QString title() const;
    QString artist() const;
    QString album() const;
    QString imageUrl() const;
    QString itunesUrl() const;
    QString songFileUrl() const;
private:
    const QString m_index;          // song index
    const QString m_title;          // song title
    const QString m_artist;         // artist
    const QString m_album;          // album title
    const QString m_image_url;      // album image
    const QString m_itunes_url;     // itunes link
    const QString m_song_file_url;  // song file
};

#endif
