#include <QGuiApplication>

#include <QDebug>

#include "player.h"

/*
   main method
*/
int main(int argc, char ** argv) {
    QGuiApplication app(argc, argv); // start app and engine
    Player *player = new Player(); // create music player from song list
    (void)player; // suppress unused warning
    return app.exec();
}


