import QtQuick 2.0

// song highlight element
Item {
    Rectangle {
        color: "#E9E9E9"
        anchors.fill: parent
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
