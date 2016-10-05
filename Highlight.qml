import QtQuick 2.0

/* list current highlight element */
Item {
    Rectangle {
        color: "#E9E9E9"
        width: 3000 //resizing slow
        height: parent.height
    }
    Image { // volume indicator
        source: "qrc:/images/volume.png"
        width: 16
        height: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 75
    }
}
