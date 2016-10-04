import QtQuick 2.0

Rectangle { // grey background root element
    id: viewer
    property bool playing: false // paused or playing
    width: 1000
    height: 800
    color: "#F5F5F5"
    FontLoader { id: brandon; source: "qrc:/fonts/brandonregular.ttf"}
    FontLoader { source: "qrc:/fonts/brandonmedium.ttf" }
    FontLoader { source: "qrc:/fonts/brandonbold.ttf" }
    FontLoader { source: "qrc:/fonts/brandonblack.ttf" }

    ListView {
        id: list
        objectName: "view"
        anchors.fill: parent
        model: songListModel
        highlightMoveDuration: 0
        highlight: Highlight {}
        header: Header {}
        delegate: Song {}
        Component.onCompleted: { // set initial index to none
            currentIndex = -1
        }
        function setSong(idx) {
            list.currentIndex = idx
            if(idx == -1) // song played to end
                playing = false
            console.log("song index ", idx)
        }
    }

}
