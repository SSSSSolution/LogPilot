import QtQuick
import QtQuick.Window
import QtQuick.Controls

import src.modules.data 1.0
import src.modules.views 1.0

ApplicationWindow {
    id: mainWindow
    visible: true

    height: 600
    width: 800
    minimumHeight: 600
    minimumWidth: 800

    function replaceFilterText(msg) {
        if (typeof msg !== 'string'|| msg.trim() === "") {
            return ""
        }
        if (DataServiceHub.filter.trim() === "") {
            return msg;
        }

        var resStr = msg.replace(DataServiceHub.filterRegExp, function(matched){
            return "<span style='background-color: rgba(210, 180, 70, 0.3);'>" +  matched + "</span>";
        })

        return resStr
    }

//    Pane {
//        anchors.fill: parent

//        background: Rectangle {
//            radius: 10
//            color: "transparent"
//        }

//        contentItem:  Image {
//            source: "qrc:/images/bg.png"
//            anchors.fill: parent
//            fillMode: Image.PreserveAspectCrop
//        }
//    }

    TitleBar {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 35
    }

    Item {
        anchors {
            top:titleBar.bottom
            bottom: bottomBar.top
            left: parent.left
            right: parent.right
        }

        Rectangle {
            id: leftRect
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: 10
            color: "black"
        }

        Rectangle {
            id: rightRect
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: 10
            color: "black"
        }


        LogsView {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: leftRect.right
                right: rightRect.left
            }
        }
    }


    property int oldContentY: 0
    Connections {
        target: DataServiceHub
    }

    BottomBar {
        id: bottomBar
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 40
    }

//    Rectangle {
//        id: bottomBar
//        color: "#44FFFFFF"
//        anchors {
//            bottom: parent.bottom
//            left: parent.left
//            right: parent.right
//        }

//        height: 50

//        TextInput {
//            id: levelInput
//            anchors {
//                top: parent.top
//                bottom: parent.bottom
//                left: parent.left
//                margins: 20
//            }
//            width: 80
//            color: "white"

//            onTextChanged: {
//                if (text.trim() === "") {
//                    DataServiceHub.setLogLevel(-1);
//                    return;
//                }

//                var level = parseInt(text);
//                if (isNaN(level)) {
//                    console.log("The string is not a valid number");
//                } else {
//                    DataServiceHub.setLogLevel(level);
//                }
//            }
//        }

//        Rectangle {
//            id: searchBound
//            color: "white"
//            anchors.centerIn: parent
//            width: 200
//            height: 20

//            TextInput {
//                id: searchInput
//                anchors.fill: parent
//                cursorVisible: false
//                font.pixelSize: 18
//                horizontalAlignment:TextInput.AlignLeft
//                verticalAlignment: TextInput.AlignHCenter

//                color: "black"

//                property string lastFilter: ""

//                onTextChanged: {
//                    if (text === "") {
//                        DataServiceHub.setFilter(text);
//                    }
//                }

//                MouseArea {
//                    id: mouseArea
//                    anchors.fill: parent
//                    cursorShape: Qt.PointingHandCursor
//                    propagateComposedEvents: true
//                    enabled: false
//                }

//                Keys.onReturnPressed: {
//                    DataServiceHub.setFilter(text);
//                }

//                Connections {
//                    target: mouseArea

//                    function onClicked(mouse) {
//                        mouse.accepted = false;
//                    }
//                }
//            }
//        }

//        Rectangle {
//            id: searchBtn
//            color: "lightblue"
//            anchors {
//                left: searchBound.right
//                bottom: searchBound.bottom
//                top: searchBound.top
//            }
//            width: 50

//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    DataServiceHub.setFilter(searchInput.text);
//                }
//            }
//        }
//    }
}
