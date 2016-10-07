import QtQuick 2.0
import QtGraphicalEffects 1.0

/* Song delegate item in listview, with click handlers
 * data populated from songListModel by Player from Itunes List
 */
Rectangle {
    id: song
    height: 50
    width: parent.width
    color: index == viewer.active+1 && viewer.playstate !== 0 ? "#E9E9E9" : "transparent" // darker if active and not stopped

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
        visible: viewer.playstate == 1 && index == viewer.active+1 // visible if active song and playing
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 75
    }
    SongText { // index
        text: index
        color: "#888888"
        visible: !(viewer.playstate == 1 && index == viewer.active+1) // visible if not active song or playing
        anchors.leftMargin: 75
    }
    SongText { // song title
        id: song_title
        text: title
        anchors.leftMargin: 114
        Component.onCompleted: { // if text longer than max width, fade text
            if(song_title.width > 280) { // max width
                song_active.start = Qt.point(220, 0) //max width - 60
                song_highlight.start = Qt.point(220, 0)
                song_default.start = Qt.point(220, 0)
            }
        }
        LinearGradient { // fade long text for default
            id: song_default
            anchors.fill: parent
            start: Qt.point(270, 0) //max width - 10
            end: Qt.point(270, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: index != viewer.active+1 ? "#F5F5F5" : "transparent" }
            }
        }
        LinearGradient { // fade long text for highlight
            id: song_highlight
            anchors.fill: parent
            start: Qt.point(270, 0) //max width - 10
            end: Qt.point(270, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem && index != viewer.active+1 ? "#FCFCFC" : "transparent" } //FIX
            }
        }
        LinearGradient { // fade long text for active
            id: song_active
            anchors.fill: parent
            start: Qt.point(270, 0) //max width - 10
            end: Qt.point(270, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: viewer.playstate != 0 && index == viewer.active+1 ? "#E9E9E9" : "transparent" }
            }
        }
    }
    SongText { // artist
        id: artist_title
        text: artist
        anchors.leftMargin: 407
        Component.onCompleted: { // if text longer than max width, fade text
            if(artist_title.width > 220) {
                artist_active.start = Qt.point(160, 0)
                artist_highlight.start = Qt.point(160, 0)
                artist_default.start = Qt.point(160, 0)
            }
        }
        LinearGradient { // fade long text for highlight inactive
            id: artist_default
            anchors.fill: parent
            start: Qt.point(210, 0) //max width - 10
            end: Qt.point(210, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: index != viewer.active+1 ? "#F5F5F5" : "transparent" }
            }
        }
        LinearGradient { // fade long text for highlight inactive
            id: artist_highlight
            anchors.fill: parent
            start: Qt.point(210, 0) //max width - 10
            end: Qt.point(210, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem && index != viewer.active+1 ? "#FCFCFC" : "transparent" }
            }
        }
        LinearGradient { // fade long text for active
            id: artist_active
            anchors.fill: parent
            start: Qt.point(210, 0) //max width - 10
            end: Qt.point(210, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: viewer.playstate != 0 && index == viewer.active+1 ? "#E9E9E9" : "transparent" }
            }
        }
    }
    SongText { // album title
        id: album_title
        text: album
        anchors.leftMargin: 632
        Component.onCompleted: { // if text longer than max width, fade text
            if(album_title.width > 360) {
                album_active.start = Qt.point(300, 0)
                album_highlight.start = Qt.point(300, 0)
                album_default.start = Qt.point(300, 0)
            }
        }
        LinearGradient { // fade long text for default
            id: album_default
            anchors.fill: parent
            start: Qt.point(350, 0) //max width - 10
            end: Qt.point(350, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: index != viewer.active+1 ? "#F5F5F5" : "transparent" }
            }
        }
        LinearGradient { // fade long text for highlight
            id: album_highlight
            anchors.fill: parent
            start: Qt.point(350, 0) //max width - 10
            end: Qt.point(350, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem && index != viewer.active+1 ? "#FCFCFC" : "transparent" }
            }
        }
        LinearGradient { // fade long text for active
            id: album_active
            anchors.fill: parent
            start: Qt.point(350, 0) //max width - 10
            end: Qt.point(350, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: viewer.playstate != 0 && index == viewer.active+1 ? "#E9E9E9" : "transparent" }
            }
        }
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

