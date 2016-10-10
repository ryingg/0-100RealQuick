import QtQuick 2.0

/* Simple header */
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
        MouseArea { // logo
            height: 30
            width: 162
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Qt.openUrlExternally("https://www.linkedin.com/in/ryingg")
            }
            Text {
                font.family: brandon.name
                font.weight: Font.Medium
                font.pixelSize: 20
                text: "0-100"
                color: "#7B7B7B"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: realquick.left
            }
            Text {
                id: realquick
                font.family: brandon.name
                font.weight: Font.Black
                font.pixelSize: 20
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
