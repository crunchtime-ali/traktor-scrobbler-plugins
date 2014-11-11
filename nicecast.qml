import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: root
    anchors.margins: 10

    // properties of the plugin
    property bool isNicecastInstalled: false
    property string nicecastDirectory: cppInterface.getUserDirectory() + "Library/Application Support/Nicecast/"

    // PLUGININFO
    Item {
        objectName: "plugininfo"
        property string name: "Nicecast"
        property string version: "1.0"
        property string minVersion: "2.0"
        property string description: "Delivers the currently playing track to Nicecast"
    }

    // event handlers for C++ events
    Connections {
        target: cppInterface

        onConnectedChanged: {
            if (cppInterface.connected) {
                nicecastStatusText.text = "No current track has been sent to Nicecast yet.";
            }
            else {
                cppInterface.deleteFile(nicecastDirectory+"NowPlaying.txt");
                nicecastStatusText.text = "Not connected to Traktor.";
            }
            nicecastStatusText.color = 'black';
        }

        onCurrentTrackChanged: {
            // Append new track to playlist
            if (isNicecastInstalled && cppInterface.currentTrack!='none'){
                // Write to NowPlaying.txt
                /*Nicecast format for manual files:
                 Title: Last Battle
                 Artist: Satou Naoki
                 Album: X TV OST 1 <- not sent
                 Time: 04:59 <- not applicable */
                var nowPlayingText = 'Title: '  + cppInterface.currentTrack + '\n' +
                                     'Artist: ' + cppInterface.currentTrack + '\n';

                cppInterface.writeToFile(nicecastDirectory+"NowPlaying.txt", nowPlayingText);

                // display status update
                nicecastStatusText.color = 'green';
                nicecastStatusText.text = cppInterface.currentTrack + ' has been sent to Nicecast at ' + getCurrentTime();
            }
        }
    }

    TextEdit {
        width: 250
        height: 100
        wrapMode: TextEdit.WordWrap
        id: nicecastStatusText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: "No current track has been sent to Nicecast yet."
    }

    // initializing the plugin
    Component.onCompleted: {
        if (!Qt.platform.os === "osx") {
            nicecastStatusText.color = 'red';
            nicecastStatusText.text = "The Nicecast-plugin only works on OS X";
        }
        else if (!cppInterface.fileExists(nicecastDirectory)){
            nicecastStatusText.color = 'red';
            nicecastStatusText.text = "Nicecast is not installed";
        }
        else {
            isNicecastInstalled = true;
        }
    }

    // Helper function to determine a date-time string
    function getCurrentTime() {
    var currentTime = new Date();
        var h = currentTime.getHours();
        var m = currentTime.getMinutes();
        var s = currentTime.getSeconds();

        return '' +
                (h<=9 ? '0' + h  : h ) + ':' +
                (m<=9 ? '0' + m  : m ) + ':' +
                (s<=9 ? '0' + s  : s );
    }
}


