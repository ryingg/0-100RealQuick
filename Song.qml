import QtQuick 2.0

Rectangle {
    height: 50
    width: 1000
    color: qcolor
    Text {
        text: name + " " + test
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
    }
}
