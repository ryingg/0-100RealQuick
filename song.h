#ifndef SONG_H
#define SONG_H

#include <QObject>

// song object holds song info
class Song : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString index READ index CONSTANT)
    Q_PROPERTY(QString title READ title CONSTANT)
    Q_PROPERTY(QString artist READ artist CONSTANT)
    Q_PROPERTY(QString album READ album CONSTANT)
    Q_PROPERTY(QString imageUrl READ imageUrl CONSTANT)

public:
    explicit Song(QObject *parent=0);
    explicit Song(const QString &index, const QString &title, const QString &artist, const QString &album, const QString &image_url, const QString &itunes_url, const QString &song_file_url, QObject *parent=0);

    QString index() const;
    QString title() const;
    QString artist() const;
    QString album() const;
    QString imageUrl() const;
    QString itunesUrl() const;
    QString songFileUrl() const;

signals:
private:
    const QString m_index;
    const QString m_title;
    const QString m_artist;
    const QString m_album;
    const QString m_image_url;
    const QString m_itunes_url;
    const QString m_song_file_url;
};

#endif
