import QtQuick 2.0

/* Main player view with listview of songs from songListModel and music controller bar
 * Key listeners enable play/pause with space, and song navigation with left/right
 *
 * Property Variables:
 * int playing the state of the view: 0 stopped, 1 playing, 2 paused
 * int active the current song of the view (maintained when true index is -1 while song paused)
 *
 * Signals:
 * playPauseView(int index) sends signal to Player object to pause or play song at index
 *
 * Functions:
 * getActive() returns active song
 * getPlayState() returns playing state: 0 stopped, 1 playing, 2 paused
 * setPlayState() sets view and vars to playing state
 * setPauseState() sets view and vars to paused state
 * setStopState() sets view and vars to stopped state
 */

Rectangle { // grey background root element
    id: viewer
    signal playPauseView(int index)
    property int playing: 0 // state 0 stopped 1 playing 2 paused
    property int active: -1 // current song index
    width: 1000
    height: 800
    focus: true

    // load fonts
    FontLoader { id: brandon; source: "qrc:/fonts/brandonregular.ttf"}
    FontLoader { source: "qrc:/fonts/brandonmedium.ttf" }
    FontLoader { source: "qrc:/fonts/brandonbold.ttf" }
    FontLoader { source: "qrc:/fonts/brandonblack.ttf" }

    // listview container
    Rectangle {
        id: listcontainer
        width: parent.width
        height: parent.height
        color: "#F5F5F5"
        ListView { // listview with song list model
            id: list
            anchors.fill: parent
            model: songListModel
            highlightMoveDuration: 0
            highlight: Highlight {}
            header: Header {}
            delegate: Song {}
            Component.onCompleted: { // set initial index to none
                currentIndex = -1
            }
        }
    }
    Controller { id: controller; objectName: "controller" }

    // key listeners
    Keys.onSpacePressed: { // play pause
        if(active == -1) // play first song
            setPlayState(0)
        else if(playing==1) { // pause
            setPauseState(active)
        }
        else { // play
            setPlayState(active)
        }
    }
    Keys.onRightPressed: { // next song
        if(playing != 0) { // don't do anything in stopped position
            var next = (active+1)%list.count
            setPlayState(next)
        }
    }
    Keys.onLeftPressed: { // prev song
        if(playing != 0 && active != 0) { // don't do anything in stopped position or first song
            var prev = (active-1)%list.count
            setPlayState(prev)
        }
    }

    // properly resize list when window height changes
    onHeightChanged: {
        if(playing==0)
            listcontainer.height = Qt.binding(function() { return viewer.height })
        else
            listcontainer.height = Qt.binding(function() { return viewer.height-controller.height })
    }

    // functions
    function getActive() { // active song getter
        return active
    }
    function getPlayState() { // playing getter
        return playing
    }
    function setPlayState(index){ // set play state
        playPauseView(index) // send signal
        active = index; // set active index
        playing = 1 // play state 1
        list.currentIndex = index // set current index
        controller.setPlayState() // change controller view
    }
    function setPauseState(index){ // set pause state
        playPauseView(index) // send signal
        list.currentIndex = -1 // disable highlight
        playing = 2 // pause state 2
        controller.setPauseState() // change controller view
    }
    function setStopState(index){ // set stop state
        active = (active+1)%list.count; // queue next song with loop
        playing = 0 // stop state 0
        list.currentIndex = index // disable highlight
        controller.setStopState() // hide controller
    }
}
