QT += qml quick network multimedia

SOURCES += main.cpp \
    song.cpp \
    player.cpp \
    ituneslist.cpp
HEADERS += \
    song.h \
    player.h \
    ituneslist.h
RESOURCES += 0-100RealQuick.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
