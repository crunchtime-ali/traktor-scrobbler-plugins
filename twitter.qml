import QtQuick 2.3
import QtQuick.Controls 1.2

Item {

    id: root
    anchors.margins: 10
    Item {
        objectName: "plugininfo"
        property string name: "Twitter"
        property string version: "0.1"
        property string minVersion: "2.0"
        property string description: "This plugin tweets the last played song"
    }

    Rectangle   {
        id: flickable
        clip: true
        anchors.fill: parent
        //frame: false
        Row {

            id: contentRow
            anchors.margins: 18
            spacing: 16
            anchors.fill: parent
            anchors.leftMargin: 40
            Column {
                spacing: 9

                Row {
                    spacing: 10
                    Button {
                        id: loginTwitter
                        state: cppInterface.twitterState
                        text: "Connect to Twitter"
                        width: 200
                        focus: true
                        tooltip:"Press this button to allow Traktor Scrobbler to send tweets"
                        //enabled: cppInterface.twitterLoginButtonEnabled
                        onClicked: cppInterface.connectToTwitterPress()
                        Image {
                            id: twitterHaken
                            x: 135
                            y: 3
                            opacity: 0.5
                            visible: cppInterface.twitterConnected
                            source:  "images/haken_gruen.png"
                        }

                        states: [
                            State {
                                name: "CONNECTED"
                                PropertyChanges { target: loginTwitter; width:"100" }

                                PropertyChanges { target: twitterHaken; x:"79" }
                                PropertyChanges { target: resetTwitter; opacity:"1" }

                            },
                            State {
                                name:  "DISCONNECTED"
                                PropertyChanges { target: loginTwitter; width:"200" }
                                PropertyChanges { target: twitterHaken; x:"135" }
                                PropertyChanges { target: resetTwitter; opacity:"0" }
                            }
                        ]

                        transitions: [
                            Transition {
                                from: "DISCONNECTED"
                                to: "CONNECTED"
                                SequentialAnimation {

                                    running: false

                                    ParallelAnimation {

                                        PropertyAnimation {
                                            target: twitterHaken
                                            property: "x"
                                            from: loginTwitter.width == "135" ? "79" : "135"
                                            to: loginTwitter.width == "135" ? "135" : "79"
                                            duration: 500
                                            running: false
                                        }

                                        PropertyAnimation {
                                            target: loginTwitter
                                            property: "width"
                                            from: loginTwitter.width == "100" ? "100" : "200"
                                            to: loginTwitter.width == "100" ? "200" : "100"
                                            duration: 500
                                            running: false
                                        }
                                    }

                                    PropertyAnimation {
                                        target: resetTwitter
                                        property: "opacity"
                                        from: "0"
                                        to: "1"
                                        duration: 500
                                        running: false
                                    }
                                }

                            },
                            Transition {
                                from: "CONNECTED"
                                to: "DISCONNECTED"

                                SequentialAnimation {
                                    running: false

                                    PropertyAnimation {
                                        target: resetTwitter
                                        property: "opacity"
                                        from: "1"
                                        to: "0"
                                        duration: 500
                                        running: false
                                    }

                                    ParallelAnimation {

                                        PropertyAnimation {
                                            target: twitterHaken
                                            property: "x"
                                            from: loginTwitter.width == "135" ? "79" : "135"
                                            to: loginTwitter.width == "135" ? "135" : "79"
                                            duration: 500
                                            running: false
                                        }

                                        PropertyAnimation {
                                            target: loginTwitter
                                            property: "width"
                                            from: "100"
                                            to: "200"
                                            duration: 500
                                            running: false
                                        }
                                    }

                                }
                            }
                        ]
                    }

                    Button {
                        id: resetTwitter
                        opacity: 0
                        text: "Reset"
                        tooltip: "Disconnects you from Twitter"
                        onClicked: cppInterface.resetTwitter()
                    }
                }


                TextEdit {
                    readOnly: true
                    text: "Custom Twitter message:"

                }

                TextField {
                    id: twitterCustomMessage
                    //enabled: cppInterface.twitterConnected
                    text: cppInterface.twitterCustomMessage
                    onTextChanged: cppInterface.setTwitterCustomMessage(twitterCustomMessage.text,false)
                    width: 210

                }

                CheckBox {
                    id: tweetSongs
                    text: "Tweet Songs"
                    //enabled: cppInterface.twitterConnected
                    checked: cppInterface.twitterSend
                    onCheckedChanged: cppInterface.setTwitterSend(tweetSongs.checked,false)
                }

                TextEdit {
                    text: "Send a regular tweet"
                    readOnly: true
                }

                Row {
                    spacing: 5

                    TextField {
                        id: regularTweetText
                        width: 125
                        text: cppInterface.regularTweetText
                        //enabled: cppInterface.twitterConnected
                        onTextChanged: cppInterface.regularTweetTextChanged(regularTweetText.text)
                    }

                    TextEdit {
                        text:  cppInterface.regularTweetLength
                        anchors.margins: 10
                        y: 5
                        //enabled: cppInterface.twitterConnected
                        readOnly: true
                    }
                    Button {
                        width: 60
                        //enabled: cppInterface.twitterConnected
                        text: "Send"
                        onClicked: cppInterface.sendRegularTweet()
                    }

                }
            }
        }
    }
}
