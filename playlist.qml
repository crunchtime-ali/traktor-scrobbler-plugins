import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: root
    anchors.margins: 10

    // properties of the plugin
    property string playlistFolder: cppInterface.getApplicationSupportFolder() + "Native Instruments/Traktor Scrobbler/playlists/"
    property string playlistFilename

    //PLUGININFO
    Item {
        objectName: "plugininfo"
        property string name: "Playlist"
        property string version: "0.1"
        property string minVersion: "2.0"
        property string description: "This plugin shows a playlist and saves "
    }

    // event handlers for C++ events
    Connections {
        target: cppInterface

        onConnectedChanged: {
            if (cppInterface.connected){
                playlistModel.clear();
                updatePlaylistFilename();
                console.log("playlist cleared");
            }
        }

        onCurrentTrackChanged: {
            // Append new track to playlist
            if (cppInterface.currentTrack!='none'){
                playlistModel.append({track:cppInterface.currentTrack})
            }

            // Save in playlist-folder
            cppInterface.writeToFile(root.playlistFolder + playlistFilename, playlistModel.getPlaylist());
        }
    }

    // The current playlist
    ListView {
        id: playlist
        width: 200

        clip:true
        anchors.margins: 10
        anchors.left: parent.left
        anchors.right: root.right
        anchors.top: parent.top
        anchors.bottom: btn_OpenPlaylistfolder.top

        model: playlistModel
        delegate: playlistDelegate
        //highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        //focus: true

        ListModel {
             id: playlistModel

             function getPlaylist(){
                 var playlistString = '';
                 for (var i = 0; i < playlistModel.count; i++) {
                    var trackNum = i+1;
                    playlistString += (trackNum<=9 ? '0' + trackNum  : trackNum ) + ' ' +
                                      playlistModel.get(i).track + "\r\n";
                 }

                 return playlistString
             }
        }
    }

    // Delegate representing playlist items
    Component {
        id: playlistDelegate
        Item {
            width: 120;
            height: 20
            Column {
                Text {
                    width: parent.width
                    text: '<b>' + (index+1) + '</b>  ' + track
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    // A button which opens the playlist folder
    Button {
        id: btn_OpenPlaylistfolder
        text: "Open playlist folder"

        anchors.bottom : root.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            cppInterface.openDirectory(playlistFolder);
        }
    }

    // initializing the plugin
    Component.onCompleted: {
        cppInterface.createDir(root.playlistFolder);
        updatePlaylistFilename();
    }

    // Update the playlist's filename to the current date-time
    function updatePlaylistFilename() {
        playlistFilename = "playlist_" + getCurrentDate() + ".txt";
    }

    // Helper function to determine a date-time string
    function getCurrentDate() {
    var currentDate = new Date();
        var d = currentDate.getDate();
        var m = currentDate.getMonth() + 1;
        var y = currentDate.getFullYear();
        var h = currentDate.getHours();
        var mi = currentDate.getMinutes();

        return '' + y + '-' +
                (m<=9 ? '0' + m  : m ) + '-' +
                (d<=9 ? '0' + d  : d ) + '_' +
                (h<=9 ? '0' + h  : h ) + 'h' +
                (m<=9 ? '0' + mi : mi) + 'm';
    }
}
