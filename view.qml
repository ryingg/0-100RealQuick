import QtQuick 2.0

/* Main player view with ListView of songs from songListModel and music Controller bar
 * Key handlers enable controls with space, enter/return, and arrow keys
 *
 * Property Variables:
 * int playstate    the state of the view: 0 stopped, 1 playing, 2 paused
 * int active       the currently active song
 * tap_to_play      true to single click to play
 *                  false to double click to play and single click to select
 *
 * Signals:
 * playView(int index)  sends signal to Player object to play song at index
 * pauseView()          sends signal to Player object to pause song
 * restart()            sends signal to Player to restart song
 *
 * Functions:
 * setActive(index) set active index and list index
 * setPlayState()   set view playstate to playing
 * setPauseState()  set view playstate to pause
 * setStopState()   set view playstate to stop
 * setError()       set error view and disables autoplay
 */

Rectangle {
    id: viewer
    property int playstate: 0
    property int active: -1
    property bool tap_to_play: false // true optimized for touchscreens
    signal playView(int index)
    signal pauseView()
    signal restartView(int index)
    width: 1000
    height: 800

    /* load fonts */
    FontLoader { id: brandon; source: "qrc:/fonts/brandonregular.ttf"}
    FontLoader { source: "qrc:/fonts/brandonmedium.ttf" }
    FontLoader { source: "qrc:/fonts/brandonbold.ttf" }
    FontLoader { source: "qrc:/fonts/brandonblack.ttf" }

    /* listview container */
    Rectangle {
        id: list_container
        width: parent.width
        height: parent.height
        color: "#F5F5F5"
        Text { // empty list error
            font.family: brandon.name
            font.weight: Font.Bold
            font.pointSize: 20
            color: "#888888"
            text: "No Songs Available"
            visible: list.count == 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
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

    /* controller bar */
    Controller { id: controller; objectName: "controller" }

    /* key listeners */
    Keys.onReturnPressed: { // play selected song
        if(active == -1) {// play first song if nothing highlighted
            setPlayState(0)
        }
        else if(list.currentIndex == active) { // restart current song
            setRestartState(active)
        }
        else {
            setPlayState(list.currentIndex) // play new song
        }
    }
    Keys.onEnterPressed: { // play selected song
        if(active == -1) // play first song if nothing highlighted
            setPlayState(0)
        else if(list.currentIndex == active) // restart current song
            setRestartState(active)
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
            setRestartState(active)
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

    /* properly resize list when window height changes */
    onHeightChanged: {
        if(playstate==0)
            list_container.height = Qt.binding(function() { return viewer.height })
        else
            list_container.height = Qt.binding(function() { return viewer.height-controller.height })
    }

    /* set active index and list index to move highlight
     * params:  index, the active index to set
     */
    function setActive(index) {
        active = index
        list.currentIndex = active
    }

    /* set view playstate to playing and signals Player
     * params:  index, the song to play
     */
    function setPlayState(index){
        playView(index)
        playstate = 1
        controller.setPlayState()
    }

    /* set view playstate to pause and signals Player
     * params:  none
     */
    function setPauseState(){
        pauseView()
        playstate = 2
        controller.setPauseState()
    }

    /* set view playstate to stop and signals Player
     * params:  none
     */
    function setStopState(){
        active = (active+1)%list.count // queue next song with loop
        playstate = 0
        list.currentIndex = active // move highlight
        controller.setStopState() // hide controller
    }

    /* set view playstate to playing and signals Player to restart song
     * params:  none
     */
    function setRestartState(index){
        restartView(index)
        playstate = 1
        controller.setPlayState()
    }

    /* set error view and disables autoplay
     * params:  none
     */
    function setError(){
        playstate = 0
        controller.setErrorState()
        controller.setAutoplay(false)
    }
}
