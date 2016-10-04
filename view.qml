import QtQuick 2.7

Rectangle { // grey background
    id: viewer
    property int active: -1 // which song is active
    property bool playing: false // paused or playing
    width: 1000
    height: 800
    color: "#F5F5F5"

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
            Text {
                text: "Itunes Top 100"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
        }

        delegate: Song {

        }
        function myQmlFunction(msg) {
            active = -1
            list.currentIndex = -1
            playing = false
            console.log("Got message:", msg)
            return "some return value"
        }
    }

}
