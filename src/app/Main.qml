import QtQuick
import QtQuick.Window
import QtQuick.Controls

import src.modules.data 1.0

Window {
    id: mainWindow

    height: 800
    visible: true
    width: 600

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

    Image {
        source: "qrc:/images/bg.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    ListView {
        id: logView
        anchors {
            top:parent.top
            bottom: bottomBar.top
            left: parent.left
            right: parent.right
        }

        cacheBuffer: 1000
        reuseItems: true
        clip: true
        model: DataServiceHub.logWatcherService.logData

        boundsBehavior: Flickable.StopAtBounds
        flickDeceleration: 7820

        property real lastContentY: 0
        property string scrollDirection: "None"



        onMovingChanged: {
            if (moving) {
                DataServiceHub.setAutoScroll(false);
            } else  {
                console.log("move -> false ", scrollBar.size + scrollBar.position + " " + scrollBar.active);
                if ((scrollBar.size + scrollBar.position >= 0.9999999) && (scrollBar.active === false)) {
                    DataServiceHub.setAutoScroll(true);
                }
            }
        }

        property int count: 0
        Timer {
            id: autoScrollTimer
            running: true
            interval: 40
            triggeredOnStart: true
            repeat: true
            onTriggered: {
                if (DataServiceHub.autoScroll) {
                    logView.positionViewAtEnd();
                }
            }

        }

        ScrollBar.vertical:  ScrollBar{
            id: scrollBar
            policy: ScrollBar.AlwaysOn

            onActiveChanged: {
            }

            onPressedChanged: {
                if (pressed) {
                    DataServiceHub.setAutoScroll(false);
                } else {
                    if ((size + position >= 0.9999999) && (scrollBar.active === false)) {
                        DataServiceHub.setAutoScroll(true);
                    }
                }
            }

            onPositionChanged: {
                if ((size + position === 1) && (scrollBar.active === false)) {
                    DataServiceHub.setAutoScroll(true);
                }
            }
        }

        delegate: Rectangle {
            id: delegateRoot
            color: "transparent"
            clip: true

            width: logView.width - scrollBar.width
            height: text.contentHeight

            TextEdit {
                id: text
                anchors.leftMargin: 7
                anchors.bottomMargin: 2
                anchors.fill: parent
                textFormat: TextEdit.RichText
                text: "<p style='line-height: 120%;'>" + model.line + " " +
                      "<font color='" + fontColor + "'>" + replaceFilterText(model.msg) + "</font>" + "</p>"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAnywhere
                readOnly: true

                font.family: sharedFont.family
                font.pixelSize:16

                property string fontColor: {
                    if (model.level === 0) {
                        return "#FFFFFF"; // Trace
                    } else if (model.level === 1) {
                        return "#faaa0a";
                    } else if (model.level === 2) {
                        return "#48BB31";  // Info
                    } else if (model.level === 3) {
                        return "#0070BB"; // Warn
                    } else if (model.level === 4) {
                        return "#FF6B68"; // Error
                    } else if (model.level === 5) {
                        return "#FF0006"; // Fatal
                    } else {
                        return "#FFFFFF" // Normal
                    }
                }

                color: "grey"
            }

            TextMetrics {
                        id: textMetrics
                        font: text.font
                        text: "m"
                    }
        }

        QtObject {
            id: sharedFont
            property string family: "DejaVu Sans Mono"
            property int pixelSize: 16
        }
    }

        FpsItem {
            id: fpsItem

            anchors.left: parent.left
            anchors.top: parent.top

            width: 150
            height: 30

            Rectangle {
                color: "transparent"
                anchors.fill: parent
                Text {
                    anchors.fill: parent
                    text: "FPS: " + fpsItem.fps;
                    color: "red"
                    font.pixelSize: 20
                    font.bold: true
                }
            }
        }

    property int oldContentY: 0
    Connections {
        target: DataServiceHub
    }

    Rectangle {
        id: bottomBar
        color: "#44FFFFFF"
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 50

        TextInput {
            id: levelInput
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                margins: 20
            }
            width: 80
            color: "white"

            onTextChanged: {
                if (text.trim() === "") {
                    DataServiceHub.setLogLevel(-1);
                    return;
                }

                var level = parseInt(text);
                if (isNaN(level)) {
                    console.log("The string is not a valid number");
                } else {
                    DataServiceHub.setLogLevel(level);
                }
            }
        }

        Rectangle {
            id: searchBound
            color: "white"
            anchors.centerIn: parent
            width: 200
            height: 20

            TextInput {
                id: searchInput
                anchors.fill: parent
                cursorVisible: false
                font.pixelSize: 18
                horizontalAlignment:TextInput.AlignLeft
                verticalAlignment: TextInput.AlignHCenter

                color: "black"

                property string lastFilter: ""

                onTextChanged: {
                    if (text === "") {
                        DataServiceHub.setFilter(text);
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    propagateComposedEvents: true
                    enabled: false
                }

                Keys.onReturnPressed: {
                    DataServiceHub.setFilter(text);
                }

                Connections {
                    target: mouseArea

                    function onClicked(mouse) {
                        mouse.accepted = false;
                    }
                }
            }
        }

        Rectangle {
            id: searchBtn
            color: "lightblue"
            anchors {
                left: searchBound.right
                bottom: searchBound.bottom
                top: searchBound.top
            }
            width: 50

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    DataServiceHub.setFilter(searchInput.text);
                }
            }
        }
    }
}
