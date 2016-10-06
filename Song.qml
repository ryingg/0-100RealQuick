import QtQuick 2.0
import QtGraphicalEffects 1.0

/* Song delegate item in listview, with click handlers
 * data populated from songListModel by Player from Itunes List
 */
Rectangle {
    id: song
    height: 50
    width: parent.width
    color: index == viewer.active+1 ? "#E9E9E9" : "transparent" // darker if active

    Rectangle { // bottom border
        height: 1
        width: parent.width
        color: "#E9E9E9"
        anchors.bottom: parent.bottom
    }
    Rectangle { // album filler
        height: 50
        width: 50
        color: "#E9E9E9"
        anchors.left: parent.left
    }
    Image { // album art
        height: 50
        width: 50
        source: imageUrl
        anchors.left: parent.left
    }
    Image { // volume indicator
        source: "qrc:/images/volume.png"
        width: 16
        height: 12
        visible: viewer.playing && index == viewer.active+1 // visible if active song and playing
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 75
    }
    SongText { // index
        text: index
        color: "#888888"
        visible: !(viewer.playing && index == viewer.active+1) // visible if not active song or playing
        anchors.leftMargin: 75
    }
    SongText { // song title
        id: song_title
        Component.onCompleted: { // if text longer than max width, fade text
            if(song_title.width > 280) { // max width
                song_active.start = Qt.point(220, 0) //max width - 60
                song_highlight.start = Qt.point(220, 0) //max width - 60
            }
        }
        LinearGradient { // fade away long text for active song
            id: song_active
            anchors.fill: parent
            start: Qt.point(270, 0) //max width - 10
            end: Qt.point(270, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: viewer.playing && index == viewer.active+1 ? "#E9E9E9" : "#F5F5F5" }
            }
        }
        LinearGradient { // fade away long text for for highlight inactive song
            id: song_highlight
            anchors.fill: parent
            start: Qt.point(270, 0) //max width - 10
            end: Qt.point(270, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem && !(viewer.playing && index == viewer.active+1) ? "#FAFAFA" : "transparent" }
            }
        }
        text: title
        anchors.leftMargin: 114
    }
    SongText { // artist
        id: artist_title
        Component.onCompleted: { // if text longer than max width, fade text
            if(artist_title.width > 220) {
                artist_active.start = Qt.point(160, 0)
                artist_highlight.start = Qt.point(160, 0)
            }
        }
        LinearGradient { // fade away long text for active song
            id: artist_active
            anchors.fill: parent
            start: Qt.point(210, 0) //max width - 10
            end: Qt.point(210, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: viewer.playing && index == viewer.active+1 ? "#E9E9E9" : "#F5F5F5" }
            }
        }
        LinearGradient { // fade away long text for for highlight inactive song
            id: artist_highlight
            anchors.fill: parent
            start: Qt.point(210, 0) //max width - 10
            end: Qt.point(210, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem && !(viewer.playing && index == viewer.active+1) ? "#FAFAFA" : "transparent" }
            }
        }
        text: artist
        anchors.leftMargin: 407
    }
    SongText { // album title
        id: album_title
        Component.onCompleted: { // if text longer than max width, fade text
            if(album_title.width > 360) {
                album_active.start = Qt.point(300, 0)
                album_highlight.start = Qt.point(300, 0)
            }
        }
        LinearGradient { // fade away long text for active song
            id: album_active
            anchors.fill: parent
            start: Qt.point(350, 0) //max width - 10
            end: Qt.point(350, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: viewer.playing && index == viewer.active+1 ? "#E9E9E9" : "#F5F5F5" }
            }
        }
        LinearGradient { // fade away long text for for highlight inactive song
            id: album_highlight
            anchors.fill: parent
            start: Qt.point(350, 0) //max width - 10
            end: Qt.point(350, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem && !(viewer.playing && index == viewer.active+1) ? "#FAFAFA" : "transparent" }
            }
        }
        text: album
        anchors.leftMargin: 632
    }

    // click listener to play new song / pause current song
    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            if(index == viewer.active+1) { // restart current song
                viewer.setRestartState()
            }
            else { // play selected song
                list.currentIndex = index-1 // set current index
                viewer.setPlayState(index-1)
            }
        }
        onClicked: { // highlight selected song
            list.currentIndex = index-1
        }

//        onClicked: { // optimized for touch screens
//            if(viewer.playstate == 1 && index == viewer.active+1) { // pause current song
//                viewer.setPauseState()
//            }
//            else { // play selected song
//                list.currentIndex = index-1 // set current index
//                viewer.setPlayState(index-1)
//            }
//        }
    }
}

