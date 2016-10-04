#include <QDebug>
#include "song.h"

Song::Song(QObject *parent)
    : QObject(parent) {
}

Song::Song(const QString &index, const QString &title, const QString &artist, const QString &album, const QString &image_url, const QString &song_file_url, QObject *parent)
    : QObject(parent), m_index(index), m_title(title), m_artist(artist), m_album(album), m_image_url(image_url), m_song_file_url(song_file_url) {
}

QString Song::index() const {
    return m_index;
}

QString Song::title() const {
    return m_title;
}

void Song::setTitle(const QString &title) {
    if (title != m_title) {
        m_title = title;
        emit titleChanged();
    }
}

QString Song::artist() const {
    return m_artist;
}

QString Song::album() const {
    return m_album;
}

QString Song::image_url() const {
    return m_image_url;
}
