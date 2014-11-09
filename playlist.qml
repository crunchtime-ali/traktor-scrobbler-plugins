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

    // The current playlist
    ListView {
        id: playlist
        width: 200

        anchors.margins: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: btn_OpenPlaylistfolder.top
        model: playlistModel
        delegate: contactDelegate
        //highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        //focus: true

        ListModel {
             id: playlistModel

             // Example data
             ListElement {
                 artist: "Bill Smith"
                 track: "555 3264"
             }
             ListElement {
                 artist: "John Brown"
                 track: "Bootyshaker"
             }
             ListElement {
                 artist: "Sam Wise"
                 track: "555 0473"
             }
        }

        Component.onCompleted: {
            //playlistModel.append({text: "lala"})
        }
    }

    // Delegate representing playlist items
    Component {
        id: contactDelegate
        Item {
            width: 180; height: 20
            Column {
                Text { text: '<b>' + index + '</b>  ' + artist + " — " + track }
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


}
