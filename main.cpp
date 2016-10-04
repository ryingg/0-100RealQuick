#include <QGuiApplication>
#include <qqmlengine.h>
#include <qqmlcontext.h>
#include <qqml.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>

#include <QDebug>

#include "song.h"
#include "topitunes.h"
#include "player.h"

/*
   This example illustrates exposing a QList<QObject*> as a
   model in QML
*/
int main(int argc, char ** argv) {
    QGuiApplication app(argc, argv); // start app and engine
    QQmlEngine engine;
    TopItunes *top_itunes = new TopItunes(); // create new top itunes object

    QEventLoop loop; // wait for songListCreated signal
    QObject::connect((QObject*)top_itunes, SIGNAL(songListCreated()), &loop, SLOT(quit()));
    loop.exec();

    QQuickView view; // expose songList as a model in QML
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("songListModel", QVariant::fromValue(top_itunes->songList()));
    view.setSource(QUrl("qrc:/view.qml"));
    view.show();

//    Player *player = new Player();
    QMediaPlayer *player = new QMediaPlayer;
    player->setPlaylist(top_itunes->playlist());
    player->setVolume(50);
    player->play();

    return app.exec();
}


