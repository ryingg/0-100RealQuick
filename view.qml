import QtQuick 2.0

Rectangle { // grey background root element
    id: viewer
    signal playPauseView(string text)
    property bool playing: false // paused or playing
    property int active: -1 // active song
    width: 1000
    height: 800
    color: "#F5F5F5"
    focus: true
    FontLoader { id: brandon; source: "qrc:/fonts/brandonregular.ttf"}
    FontLoader { source: "qrc:/fonts/brandonmedium.ttf" }
    FontLoader { source: "qrc:/fonts/brandonbold.ttf" }
    FontLoader { source: "qrc:/fonts/brandonblack.ttf" }
    ListView {
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

    Keys.onSpacePressed: { // play pause
        if(active == -1) { // play first song
            active = 0
            playPauseView(active)
        }
        else
            playPauseView(active) // send signal to update play pause
        if(playing) { // pause
            console.log("pause")
            list.currentIndex = -1
            viewer.playing = false
        }
        else { // play
            console.log("play")
            list.currentIndex = active
            viewer.playing = true
        }
    }
    Keys.onRightPressed: { // next song
        if(active != -1) { // don't do anything initially
            var next = (active+1)%list.count
            playPauseView(next) // play next song
            viewer.setSong(next) // set song view
            viewer.playing = true
        }
    }
    Keys.onLeftPressed: { // prev song
        if(active != -1) { // don't do anything initially
            var prev = (active-1)%list.count
            playPauseView(prev) // play next song
            viewer.setSong(prev) // set song view
            viewer.playing = true
        }
    }
    function setSong(idx) { // set next song view
        list.currentIndex = idx
        if(idx == -1) { // song played to end, autoplay off
            playing = false
            active = (active+1)%list.count; // queue next song with loop
        }
        else {
            active = idx; // set curr song
        }
    }
}
