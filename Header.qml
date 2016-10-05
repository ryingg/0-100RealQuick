import QtQuick 2.0

Item {
    height: 35
    width: parent.width
    Rectangle {
        color:"#E9E9E9"
        anchors.fill: parent
        SongText { // song title
            font.weight: Font.Bold
            text: "SONG"
            color: "#B3B3B3"
            anchors.leftMargin: 114
        }
        SongText { // artist
            font.weight: Font.Bold
            text: "ARTIST"
            color: "#B3B3B3"
            anchors.leftMargin: 407
        }
        SongText { // album title
            font.weight: Font.Bold
            text: "ALBUM"
            color: "#B3B3B3"
            anchors.leftMargin: 632
        }
        Item { // logo
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            Text {
                font.family: brandon.name
                font.weight: Font.Medium
                font.pointSize: 20
                text: "0-100"
                color: "#7B7B7B"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: realquick.left
            }
            Text {
                id: realquick
                font.family: brandon.name
                font.weight: Font.Black
                font.pointSize: 20
                text: "REALQUICK"
                color: "#7B7B7B"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }
    }
    Rectangle { // bottom border
        height: 1
        width: parent.width
        color: "#E3E3E3"
        anchors.bottom: parent.bottom
    }
}