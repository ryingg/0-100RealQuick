import QtQuick 2.7

Rectangle { // grey background root element
    id: viewer
    property bool playing: false // paused or playing
    width: 1000
    height: 800
    color: "#F5F5F5"
    FontLoader { // load font
        id: brandonRegular
        source: "qrc:/fonts/brandonregular.ttf"
    }

    ListView {
        id: list
        objectName: "view"
        anchors.fill: parent
        model: songListModel
        highlight: Highlight {}
        highlightFollowsCurrentItem: false
        highlightMoveDuration: 0
        header: Rectangle {
            objectName: "header"
            height: 50
            width: 1000
            SongText {
                text: "Itunes Top 100"
                anchors.leftMargin: 20
            }
        }

        delegate: Song {

        }
        function setSong(idx) {
            list.currentIndex = idx
            if(idx == -1) // song played to end
                playing = false
            console.log("song index ", idx)
        }
    }

}
