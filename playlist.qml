import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: root
    anchors.margins: 10


    //PLUGININFO
    Item {
        objectName: "plugininfo"
        property string name: "Playlist"
        property string version: "0.1"
        property string minVersion: "2.0"
        property string description: "This plugin shows a playlist and saves "
    }

    Connections {
        target: cppInterface
        onCurrentTrackChanged: {

            //Append to playlist
            playlistModel.append({track:cppInterface.currentTrack})

            //TODO:Save in playlist-folder


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
        anchors.bottom : root.bottom
        text: "Open playlist folder"

        onClicked: {

        }
    }

    Component.onCompleted: {
       console.log(cppInterface.getApplicationSupportFolder() + "Native Instruments/Traktor Scrobbler/playlists")
       cppInterface.createDir(cppInterface.getApplicationSupportFolder() + "Native Instruments/Traktor Scrobbler/playlists")
    }
}
