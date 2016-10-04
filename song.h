#ifndef SONG_H
#define SONG_H

#include <QObject>
#include <QColor>

// song object holds song info
class Song : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString index READ index CONSTANT)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist CONSTANT)
    Q_PROPERTY(QString album READ album CONSTANT)
    Q_PROPERTY(QString image_url READ image_url CONSTANT)

public:
    explicit Song(QObject *parent=0);
    explicit Song(const QString &index, const QString &title, const QString &artist, const QString &album, const QString &image_url, const QString &song_url, QObject *parent=0);

    QString index() const;
    QString title() const;
    void setTitle(const QString &title);
    QString artist() const;
    QString album() const;
    QString image_url() const;

signals:
    void titleChanged();

private:
    const QString m_index;
    QString m_title;
    const QString m_artist;
    const QString m_album;
    const QString m_image_url;
    const QString m_song_url;
};

#endif
