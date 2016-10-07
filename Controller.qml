import QtQuick 2.0

/* Music controller bar featuring buttons and views
 * Buttons set viewer's play state
 * Song info links to iTunes page
 *
 * Property Variables:
 * string itunes_url    the itunes link of the current song
 * int progress         the progress of the song played
 *
 * Signals:
 * setPositionView(real percent)    sends signal to Player object to set position
 * setAutoPlayView(bool autoplay)   sends signal to Player object to set autoplay
 *
 * Functions:
 * setPlayState()                   set view to playing state
 * setPauseState()                  set view to pause state
 * setStopState()                   set view to stop state and hide controller
 * setSongInfo(song, artist, url)   set view to new song info
 * setPosition(percent)             bind view to new progress bar position
 * setAutoplay()                    set autoplay bool
 */

Rectangle {
    id: control
    property string itunes_url: ""
    property int progress: 0
    property bool autoplay: false
    signal setPositionView(real percent)
    signal setAutoplayView(bool autoplay)
    width: parent.width
    height: 75
    color: "#E9E9E9"
    anchors.top: parent.bottom
    anchors.topMargin: -75
    state: "STOP"
    MouseArea { // prevent click through list
        anchors.fill:parent
    }

    /* progress bar */
    MouseArea {
        id: progress_area
        property int posX: 0 // keep track of mouseX in case mouse leaves window
        width: parent.width
        height: 12
        anchors.top: parent.top
        hoverEnabled: true
        onEntered: enlarge.start() // enlarge mousearea and bar
        onExited: shrink.start() // shrink mousearea and bar
        onPressed: { // hide real progress bar and show false dragger
            progress_bar.visible = false // hide real progress when dragging
            progress_dragger.visible = true
            progress_dragger.width = mouseX
        }
        onPositionChanged: { // hold and drag position
            if (pressed) {
                progress_area.height = viewer.height // set draggable area to entire window
                progress_area.anchors.topMargin = control.height - viewer.height // adjust margins
                progress_background.anchors.topMargin = viewer.height - control.height
                progress_dragger.width = mouseX // update dragger progress
            }
        }
        onReleased: { // release drag, still works if mouse drags out of window
            var percent = mouseX/progress_background.width // update view
            setPositionView(percent) // signal player to update position
            progress = mouseX // progress updates after player signals, change here first to prevent old progress flash
            progress_area.height = 12
            progress_area.anchors.topMargin = 0
            progress_background.anchors.topMargin = 0
            progress_bar.visible = true
            progress_dragger.visible = false
        }
        /* progress bar background */
        Rectangle {
            id: progress_background
            color: "#C1C1C1"
            height: 4
            width: parent.width
            anchors.top: parent.top
            NumberAnimation {
                id: enlarge
                target: progress_background
                properties: "height"
                to: 12
                duration: 200
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                id: shrink
                target: progress_background
                properties: "height"
                to: 4
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        /* progress bar foreground */
        Rectangle {
            id: progress_bar
            color: "#7B7B7B"
            height: progress_background.height
            width: progress
            anchors.top: progress_background.top
        }
        /* false bar foreground when dragging */
        Rectangle {
            id: progress_dragger
            color: "#7B7B7B"
            visible: false
            height: progress_background.height
            width: progress
            anchors.top: progress_background.top
        }
    }

    /* prev button */
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

    /* pause button */
    MouseArea {
        id: pause_button
        width: 36
        height: 36
        visible: viewer.playstate == 1
        anchors.top: prev_button.top
        anchors.left: prev_button.right
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

    /* play button */
    MouseArea {
        id: play_button
        width: 36
        height: 36
        visible: viewer.playstate != 1
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

    /* next button */
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

    /* autoplay button */
    MouseArea {
        id: autoplay_button
        width: 36
        height: 36
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 20
        anchors.rightMargin: 14
        onClicked: {
            if(!autoplay) { // enable autoplay
                autoplay = true
                setAutoplayView(true) // send signal to player
            }
            else { // disable autoplay
                autoplay = false
                setAutoplayView(false) // send signal to player
            }
        }
        Image {
            id: autoplay_disable
            source: "qrc:/images/autoplaydisable.png"
            width: 17
            height: 23
            visible: !autoplay
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 9
        }
        Image {
            id: autoplay_enable
            source: "qrc:/images/autoplayenable.png"
            width: 17
            height: 23
            visible: autoplay
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 9
        }
    }

    /* song info */
    MouseArea {
        id: song_info_controller
        width: 100
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
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
        Text { // error message
            id: error_controller
            font.family: brandon.name
            font.weight: Font.Medium
            font.pointSize: 14
            text: "Error Loading Song"
            visible: false
            color: "#888888"
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    /* states of view */
    states: [
        State {
            name: "PLAY"
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
                target: progress_background
                color: "#7B7B7B"
            }
        },
        State {
            name: "ERROR"
            PropertyChanges {
                target: error_controller
                visible: true
            }
            PropertyChanges {
                target: song_title_controller
                visible: false
            }
            PropertyChanges {
                target: artist_controller
                visible: false
            }
            PropertyChanges {
                target: song_info_controller
                enabled: false
                cursorShape: Qt.ArrowCursor
            }
            PropertyChanges {
                target: progress_area
                enabled: false
            }
        }
    ]

    /* controller animations */
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
                target: list_container;
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
                target: list_container;
                property: "height";
                to: viewer.height;
                duration: 500
            }
        },
        Transition {
            from: "PLAY"
            to: "ERROR"
            PropertyAnimation { // ease in controller
                easing.type: Easing.InOutCubic;
                target: control;
                property: "anchors.topMargin";
                to: -75;
                duration: 500
            }
            PropertyAnimation { // resize list container
                easing.type: Easing.InOutCubic;
                target: list_container;
                property: "height";
                to: viewer.height-controller.height;
                duration: 500
            }
        },
        Transition {
            from: "STOP"
            to: "ERROR"
            PropertyAnimation { // ease in controller
                easing.type: Easing.InOutCubic;
                target: control;
                property: "anchors.topMargin";
                to: -75;
                duration: 500
            }
            PropertyAnimation { // resize list container
                easing.type: Easing.InOutCubic;
                target: list_container;
                property: "height";
                to: viewer.height-controller.height;
                duration: 500
            }
        }
    ]

    /* set view to playing state
     * params:  none
     */
    function setPlayState(){
        state = "PLAY"
    }

    /* set view to pause state
     * params:  none
     */
    function setPauseState(){
        state = "PAUSE"
    }

    /* set view to stop state and hide controller
     * params:  none
     */
    function setStopState(){
        state = "STOP"
    }

    function setErrorState(){
        state = "ERROR"
    }

    /* set view to new song info and width of mousearea
     * params:
     *      song, the new song name
     *      artist, the new artist
     *      url, the new song itunes link
     */
    function setSongInfo(song, artist, url) {
        song_title_controller.text = song
        artist_controller.text = artist
        song_info_controller.width = Math.max(song_title_controller.width, artist_controller.width) + 20
        itunes_url = url
    }

    /* bind view to new progress bar position percent*totalwidth
     * params:
     *      percent, the percent of song progress completed
     */
    function setPosition(percent) {
        progress = Qt.binding(function() { return parseInt(progress_background.width*percent) })
    }

    /* set autoplay bool
     * params:
     *      autop, the autoplay bool
     */
    function setAutoplay(autop) {
        autoplay = autop
    }
}
