import QtQuick 2.0

/* Music controller bar featuring buttons and views
 * Buttons set viewer's play state
 * Song info links to iTunes page
 *
 * Property Variables:
 * string itunes_url the itunes link of the current song
 * int progress the progress of the song played
 *
 * Functions:
 * setPlayState() sets controller view to playing state
 * setPauseState() sets controller view to paused state
 * setStopState() hides controller
 * setSongInfo() sets new song info view
 * setPosition() sets new progress bar position view
 */
Rectangle {
    id: control
    property string itunes_url: ""
    property int progress: 0
    width: parent.width
    height: 75
    color:"#E9E9E9"
    anchors.top: parent.bottom
    anchors.topMargin: -75
    state: "STOP"
    MouseArea { // prevent click through list
        anchors.fill:parent
    }

    // progress bar
    MouseArea {
        width: parent.width
        height: 20
        anchors.top: parent.top
        anchors.topMargin: -8
        hoverEnabled: true
        onPositionChanged: {
        }
        onClicked: {
            console.log("position "+mouseX)
        }
        Rectangle {
            id: progressbackground
            color:"#C1C1C1"
            height: 4
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 8
        }
        Rectangle {
            id: progressbar
            color:"#7B7B7B"
            height: 4
            width: progress
            anchors.top: progressbackground.top
        }
    }

    // prev button
    MouseArea {
        id: prev_button
        width: 36
        height: 36
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 12
        onClicked: {
            if(viewer.playstate != 0 && viewer.active != 0) { // don't do anything in stopped position or first song
                var prev = (viewer.active-1)%list.count
                list.currentIndex = prev // highlight becomes playing song
                viewer.setPlayState(prev)
            }
        }
        Image {
            source: "qrc:/images/prev.png"
            width: 16
            height: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
        }
    }

    // pause button
    MouseArea {
        id: pause_button
        width: 36
        height: 36
        anchors.top: prev_button.top
        anchors.left: prev_button.right
        visible: false
        onClicked: {
            viewer.setPauseState(viewer.active)
            setPauseState()
        }
        Image {
            source: "qrc:/images/pause.png"
            width: 16
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
        }
    }

    // play button
    MouseArea {
        id: play_button
        width: 36
        height: 36
        anchors.top: prev_button.top
        anchors.left: prev_button.right
        onClicked: {
            viewer.setPlayState(viewer.active)
            setPlayState()
        }
        Image {
            source: "qrc:/images/play.png"
            width: 16
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
        }
    }

    // next button
    MouseArea {
        id: next_button
        width: 36
        height: 36
        anchors.top: prev_button.top
        anchors.left: prev_button.right
        anchors.leftMargin: 36
        onClicked: {
            if(viewer.playstate != 0) { // don't do anything in stopped position
                var next = (viewer.active+1)%list.count
                list.currentIndex = next // highlight becomes playing song
                viewer.setPlayState(next)
            }
        }
        Image {
            source: "qrc:/images/next.png"
            width: 16
            height: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
        }
    }

    // song info
    MouseArea {
        id: song_info_controller
        width: 100
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Qt.openUrlExternally(itunes_url)
        }
        Text { // song title
            id: song_title_controller
            font.family: brandon.name
            font.weight: Font.Medium
            font.pointSize: 14
            text: ""
            color: "#888888"
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text { // artist
            id: artist_controller
            font.family: brandon.name
            font.pointSize: 14
            text: ""
            color: "#888888"
            anchors.top: song_title_controller.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // states of view
    states: [
        State {
            name: "PLAY"
            PropertyChanges {
                target: play_button
                visible: false
            }
            PropertyChanges {
                target: pause_button
                visible: true
            }
        },
        State {
            name: "PAUSE"
        },
        State {
            name: "STOP"
            PropertyChanges {
                target: control
                anchors.topMargin: 0
            }
            PropertyChanges { // keep bar darkened when stopping
                target: progressbackground
                color: "#7B7B7B"
            }
        }
    ]

    // controller animations
    transitions: [
        Transition {
            from: "STOP"
            to: "PLAY"
            PropertyAnimation { // ease in controller
                easing.type: Easing.InOutCubic;
                target: control;
                property: "anchors.topMargin";
                to: -75;
                duration: 500
            }
            PropertyAnimation { // resize list container
                easing.type: Easing.InOutCubic;
                target: listcontainer;
                property: "height";
                to: viewer.height-controller.height;
                duration: 500
            }
        },
        Transition {
            from: "PLAY"
            to: "STOP"
            PropertyAnimation {
                easing.type: Easing.InOutCubic;
                target: control;
                property: "anchors.topMargin";
                to: 0;
                duration: 500
            }
            PropertyAnimation { // resize list container
                easing.type: Easing.InOutCubic;
                target: listcontainer;
                property: "height";
                to: viewer.height;
                duration: 500
            }
        }
    ]

    // functions
    function setPlayState(){
        state = "PLAY"
    }
    function setPauseState(){
        state = "PAUSE"
    }
    function setStopState(){
        state = "STOP"
    }
    function setSongInfo(song, artist, url) { // set song, artist, and width of mousearea
        song_title_controller.text = song
        artist_controller.text = artist
        song_info_controller.width = Math.max(song_title_controller.width, artist_controller.width) + 20
        itunes_url = url
    }
    function setPosition(percent) { // bind progress bar position width*percent
        progress = Qt.binding(function() { return parseInt(progressbackground.width*percent) })
    }
}
