import QtQuick 2.7
import QtGraphicalEffects 1.0

// song element
Rectangle {
    id: song
    height: 50
    width: 1000
    color: "transparent"
    SongText {
        text: index
        anchors.leftMargin: 20
    }
    SongText {
        LinearGradient { // fade away long text
            anchors.fill: parent
            start: Qt.point(400, 0)
            end: Qt.point(600, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem ? "#E9E9E9" : "#F5F5F5" } // change text gradient for highlight
            }
        }
        text: title + " - " + artist + " in " + album
        anchors.leftMargin: 40
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { // when clicking song entry
            playPause(index) // send signal to update play pause
            if(viewer.playing && index == list.currentIndex+1) { // pause
                console.log("pause")
                list.currentIndex = -1
                viewer.playing = false
            }
            else { // play song
                list.highlightFollowsCurrentItem = true
                list.currentIndex = -1 // necessary to disable initial highlight animation
                console.log("play")
                list.currentIndex = index-1
                viewer.playing = true
            }


        }
    }
}

