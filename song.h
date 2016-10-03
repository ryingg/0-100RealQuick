#ifndef SONG_H
#define SONG_H

#include <QObject>
#include <QColor>

// song object holds song info
class Song : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString test READ test WRITE setTest NOTIFY testChanged)
    Q_PROPERTY(QColor qcolor READ qcolor WRITE setQcolor NOTIFY qcolorChanged)

public:
    explicit Song(QObject *parent=0);
    explicit Song(const QString &name, const QString &test, const QColor &qcolor, QObject *parent=0);

    QString name() const;
    void setName(const QString &name);

    QString test() const;
    void setTest(const QString &test);

    QColor qcolor() const;
    void setQcolor(const QColor &qcolor);

signals:
    void nameChanged();
    void testChanged();
    void qcolorChanged();

private:
    QString m_name;
    QString m_test;
    QColor m_qcolor;
};

#endif
