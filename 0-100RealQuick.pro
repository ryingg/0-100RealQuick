QT += qml quick network

SOURCES += main.cpp \
    song.cpp \
    topitunes.cpp
HEADERS += \
    song.h \
    topitunes.h
RESOURCES += 0-100RealQuick.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
