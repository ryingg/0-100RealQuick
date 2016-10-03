#include <QDebug>
#include "song.h"

Song::Song(QObject *parent)
    : QObject(parent)
{
}

Song::Song(const QString &name, const QString &test, const QColor &qcolor, QObject *parent)
    : QObject(parent), m_name(name), m_test(test), m_qcolor(qcolor)
{
}

QString Song::name() const
{
    return m_name;
}

void Song::setName(const QString &name)
{
    if (name != m_name) {
        m_name = name;
        emit nameChanged();
    }
}

QString Song::test() const
{
    return m_test;
}

void Song::setTest(const QString &test)
{
    if (test != m_test) {
        m_test = test;
        emit testChanged();
    }
}

QColor Song::qcolor() const
{
    return m_qcolor;
}

void Song::setQcolor(const QColor &qcolor)
{
    if (qcolor != m_qcolor) {
        m_qcolor = qcolor;
        emit qcolorChanged();
    }
}
