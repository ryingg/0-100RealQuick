#include <QGuiApplication>

#include <QDebug>

#include "player.h"

/* Main function instantiates player and executes app */
int main(int argc, char ** argv) {
    QGuiApplication app(argc, argv); // start app and engine
    Player *player = new Player(); // create music player and view
    (void)player; // suppress unused warning
    return app.exec();
}
