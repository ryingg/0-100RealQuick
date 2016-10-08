#Build & Run
Currently optimized for desktop use for showcasing purposes. To optimize for mobile use, set the property variable tap_to_play to true in view.qml. This disables double click and enables single tap.

##Mac OSX (El Capitan 10.11.3 with QT Creator 5.7.0)
####Run
Run the app from the included 0-100RealQuick.dmg file
####Build
Install QT Creator for Mac and open the 0-100RealQuick.pro file in QT Creator and build and run, making sure the default kit is detected in QT Creator>Preferences>Build & Run>Kits
####Deploy
Run macdeployqt following these instructions http://dragly.org/2012/01/13/deploy-qt-applications-for-mac-os-x/
http://stackoverflow.com/questions/17475788/qt-5-1-and-mac-bug-making-macdeployqt-not-working-properly/17591828#17591828

#Usage
Currently optimized for desktop use for showcasing purposes. See use cases for general usage.

####Double Click: plays the double clicked song, pauses it if it is already active and playing on the bottom bar
####Single Click: highlights the clicked song, and activates other on screen UI controls.
####Enter/Return: plays the highlighted song, or the first song if none is highlighted, or replays the highlighted song if it is also the active song in the bottom bar
####Space: plays/pauses the active song in the bottom bar, or the highlighted song if none is active, or the first song is none is highlighted.
####Left: plays previous song, replay the first song if the first song is active in the bottom bar, or the first song if no songs were played before.
####Right: plays next song, or the first song if none is active in the bottom bar, or the first song if the last song is active
####Up: highlights the previous song, no wrap
####Down: highlights the next song, no wrap
####Scroll: scrolls through the list, no wrap

