#include <QDebug>
#include "song.h"

Song::Song(QObject *parent)
    : QObject(parent) {
}

Song::Song(const QString &index, const QString &title, const QString &artist, const QString &album, const QString &image_url, const QString &itunes_url, const QString &song_file_url, QObject *parent)
    : QObject(parent), m_index(index), m_title(title), m_artist(artist), m_album(album), m_image_url(image_url), m_itunes_url(itunes_url), m_song_file_url(song_file_url) {
}

QString Song::index() const {
    return m_index;
}

QString Song::title() const {
    return m_title;
}

QString Song::artist() const {
    return m_artist;
}

QString Song::album() const {
    return m_album;
}

QString Song::imageUrl() const {
    return m_image_url;
}

QString Song::itunesUrl() const {
    return m_itunes_url;
}

QString Song::songFileUrl() const {
    return m_song_file_url;
}
