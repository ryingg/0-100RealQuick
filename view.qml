import QtQuick 2.0

Rectangle { // grey background root element
    id: viewer
    signal playPauseView(string text)
    property int playing: 0 // 0 stopped 1 playing 2 paused
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
        if(playing==1) { // pause
            console.log("pause")
            list.currentIndex = -1
            playing = 2
        }
        else { // play
            console.log("play")
            list.currentIndex = active
            playing = 1
        }
    }
    Keys.onRightPressed: { // next song
        if(playing != 0) { // don't do anything in stopped position
            var next = (active+1)%list.count
            playPauseView(next) // play next song
            setSong(next) // set song view
            playing = 1
        }
    }
    Keys.onLeftPressed: { // prev song
        if(playing != 0) { // don't do anything in stopped position
            var prev = (active-1)%list.count
            playPauseView(prev) // play next song
            setSong(prev) // set song view
            playing = 1
        }
    }
    function setSong(idx) { // set next song view
        list.currentIndex = idx
        if(idx == -1) { // song played to end, autoplay off
            playing = 0
            active = (active+1)%list.count; // queue next song with loop
        }
        else {
            active = idx; // set curr song
        }
    }
}
