import QtQuick 2.0

//![0]
Rectangle { // grey background
    width: 1000
    height: 800
    color: "#ddd"
    ListView {
        objectName: "view"
        anchors.fill: parent
        model: songListModel

        header: Rectangle {
            objectName: "header"
            height: 50
            width: 800
            color: "#ddd"
            Text {
                text: "Itunes Top 100"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
        }

        delegate: Song {

        }
    }
}
//![0]
