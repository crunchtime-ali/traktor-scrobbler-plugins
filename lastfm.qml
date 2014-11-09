import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
   color: "green";
    Item {
        objectName: "plugininfo"
        property string name: "Last.FM"
        property string version: "0.1"
        property string minVersion: "2.0"
        property string description: "This plugin actually scrobbles to the Last.FM-service"
    }
    TextEdit {
        anchors.horizontalCenter: parent.horizontalCenter
        text: cppInterface.getApplicationSupportFolder()
    }


    /*Row {
    anchors.fill: parent
    anchors.margins:16
    spacing:16

    Column {
        spacing:12
        TextEdit {
            text: "I'm working on it! \r\n\Last.fm will be present in the next version released soon."
        }
    }
}*/
}
