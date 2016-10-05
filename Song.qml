import QtQuick 2.0
import QtGraphicalEffects 1.0

/* Song delegate item in listview, with click handlers
 * data populated from songListModel by Player from Itunes List
 */
Rectangle {
    id: song
    height: 50
    width: parent.width
    color: "transparent"

    Rectangle { // bottom border
        height: 1
        width: parent.width
        color: "#E9E9E9"
        anchors.bottom: parent.bottom
    }
    Image { // album art
        height: 50
        width: 50
        source: imageUrl
        anchors.left: parent.left
    }
    SongText { // index
        text: index
        color: song.ListView.isCurrentItem ? "transparent" : "#888888"
        anchors.leftMargin: 75
    }
    SongText { // song title
        id: song_title
        Component.onCompleted: { // if text longer than max width, fade text
            if(song_title.width > 280) // max width
                song_gradient.start = Qt.point(220, 0) //max width - 60
        }
        LinearGradient { // fade away long text
            id: song_gradient
            anchors.fill: parent
            start: Qt.point(270, 0) //max width - 10
            end: Qt.point(270, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem ? "#E9E9E9" : "#F5F5F5" } // change text gradient for highlight
            }
        }
        text: title
        anchors.leftMargin: 114
    }
    SongText { // artist
        id: artist_title
        Component.onCompleted: { // if text longer than max width, fade text
            if(artist_title.width > 220)
                artist_gradient.start = Qt.point(160, 0)
        }
        LinearGradient { // fade away long text
            id: artist_gradient
            anchors.fill: parent
            start: Qt.point(210, 0)
            end: Qt.point(210, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem ? "#E9E9E9" : "#F5F5F5" } // change text gradient for highlight
            }
        }
        text: artist
        anchors.leftMargin: 407
    }
    SongText { // album title
        id: album_title
        Component.onCompleted: { // if text longer than max width, fade text
            if(album_title.width > 360)
                album_gradient.start = Qt.point(300, 0)
        }
        LinearGradient { // fade away long text
            id: album_gradient
            anchors.fill: parent
            start: Qt.point(350, 0)
            end: Qt.point(350, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: song.ListView.isCurrentItem ? "#E9E9E9" : "#F5F5F5" } // change text gradient for highlight
            }
        }
        text: album
        anchors.leftMargin: 632
    }
    MouseArea { // clicking song sets viewer's play state, and pauses current or plays new song
        anchors.fill: parent
        onClicked: {
            if(viewer.getPlayState() == 1 && index == list.currentIndex+1) { // pause current song
                viewer.setPauseState(index-1)
            }
            else { // play selected song
                viewer.setPlayState(index-1)
            }
        }
    }
}

