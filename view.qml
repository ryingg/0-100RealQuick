import QtQuick 2.0

/* Main player view with listview of songs from songListModel and music controller bar
 * Key listeners enable play/pause with space, and song navigation with left/right
 *
 * Property Variables:
 * int playstate the state of the view: 0 stopped, 1 playing, 2 paused
 * int active the current song of the view (maintained when true index is -1 while song paused)
 *
 * Signals:
 * playPauseView(int index) sends signal to Player object to pause or play song at index
 *
 * Functions:
 * setPlayState() sets view and vars to playing state
 * setPauseState() sets view and vars to paused state
 * setStopState() sets view and vars to stopped state
 */

Rectangle { // grey background root element
    id: viewer
    signal playView(int index)
    signal pauseView()
    signal restartView()
    property int playstate: 0 // state 0 stopped 1 playing 2 paused
    property int active: -1 // current song index
    width: 1000
    height: 800

    // load fonts
    FontLoader { id: brandon; source: "qrc:/fonts/brandonregular.ttf"}
    FontLoader { source: "qrc:/fonts/brandonmedium.ttf" }
    FontLoader { source: "qrc:/fonts/brandonbold.ttf" }
    FontLoader { source: "qrc:/fonts/brandonblack.ttf" }

    // listview container
    Rectangle {
        id: list_container
        width: parent.width
        height: parent.height
        color: "#F5F5F5"
        ListView { // listview with song list model
            id: list
            anchors.fill: parent
            model: songListModel
            highlightMoveDuration: 0
            highlight: Highlight {}
            header: Header { }
            delegate: Song {}
            focus: true
            Component.onCompleted: { // set initial index to none
                currentIndex = -1
            }
        }
    }

    // controller bar
    Controller { id: controller; objectName: "controller" }

    // key listeners
    Keys.onReturnPressed: { // play selected song
        if(active == -1) // play first song if nothing highlighted
            setPlayState(0)
        else if(list.currentIndex == active) // restart current song
            setRestartState()
        else
            setPlayState(list.currentIndex) // play new song
    }
    Keys.onEnterPressed: { // play selected song
        if(active == -1) // play first song if nothing highlighted
            setPlayState(0)
        else if(list.currentIndex == active) // restart current song
            setRestartState()
        else
            setPlayState(list.currentIndex) // play new song
    }
    Keys.onSpacePressed: { // play pause
        if(active == -1) // play first song
            if(list.currentIndex == -1) // if nothing highlighted
                setPlayState(0)
            else
                setPlayState(list.currentIndex)
        else if(playstate==1) // pause
            setPauseState()
        else // play
            setPlayState(active)
    }
    Keys.onLeftPressed: { // prev song
        if(active == -1) // play first song if none highlighted
            setPlayState(0)
        else if(active == 0) // restart first song
            setRestartState()
        else { // play prev song
            var prev = active-1
            list.currentIndex = prev // highlight becomes playing song
            setPlayState(prev)
        }
    }
    Keys.onRightPressed: { // next song
        if(active == -1) // play first song if none highlighted
            setPlayState(0)
        else { // play next song
            var next = (active+1)%list.count
            list.currentIndex = next // highlight becomes playing song
            setPlayState(next)
        }
    }

    // properly resize list when window height changes
    onHeightChanged: {
        if(playstate==0)
            list_container.height = Qt.binding(function() { return viewer.height })
        else
            list_container.height = Qt.binding(function() { return viewer.height-controller.height })
    }

    // functions
    function setActive(index) { // set active song index
        active = index
        list.currentIndex = active // move highlight
    }
    function setPlayState(index){ // set play state
        playView(index) // send signal
        playstate = 1 // play state 1
        controller.setPlayState() // change controller view
    }
    function setPauseState(){ // set pause state
        pauseView() // send signal
        playstate = 2 // pause state 2
        controller.setPauseState() // change controller view
    }
    function setStopState(){ // set stop state
        active = (active+1)%list.count // queue next song with loop
        playstate = 0 // stop state 0
        list.currentIndex = active // move highlight
        controller.setStopState() // hide controller
    }
    function setRestartState(){ // restart song, set play state
        restartView() // send signal
        playstate = 1 // play state 1
        controller.setPlayState() // change controller view
    }
}
