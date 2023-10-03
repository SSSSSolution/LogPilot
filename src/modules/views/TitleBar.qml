import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.platform

import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    color: "black"

    function convertStrToNumber(str) {
        var num = parseInt(str);
        return isNaN(num) ? 0 : num;
    }

    OpenFileButton {
        id: openBtn
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 9
        }

        height: 24
        width: height

        onClicked: {
            fileDialog.open()
        }

        FileDialog {
            id: fileDialog
            title: "Please choose a log file."
            fileMode: FileDialog.OpenFile
            onAccepted: {
                console.log("choose log file: " + fileDialog.currentFile)
                DataServiceHub.setLogFile(fileDialog.currentFile);
            }
        }
    }

    DefaultText {
        anchors {
            left: openBtn.right
            leftMargin: 10
            right: clipTextInput.left
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        height: contentHeight
        text: DataServiceHub.curLogFile
        elide: Text.ElideMiddle
        horizontalAlignment: Text.AlignLeft
    }

    DefaultTextInput {
        id: clipTextInput
        anchors {
            verticalCenter:  parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        width: 80
        height: 18

        Keys.onReturnPressed: {
            DataServiceHub.setClipLine(convertStrToNumber(textInput.text))
        }

        enabled: DataServiceHub.logLoaded
    }

    ClipButton {
        id: clipBtn
        anchors {
            left: clipTextInput.right
            leftMargin: 5
            verticalCenter: clipTextInput.verticalCenter
        }
        width: 20
        height: 20

        onClicked: {
            DataServiceHub.setClipLine(convertStrToNumber(clipTextInput.textInput.text))
        }

        enabled: DataServiceHub.logLoaded
    }

    DefaultTextButton {
        id: aboutBtn
        anchors {
            right: parent.right
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }
        textItem.text: "About"
        textItem.font.bold: true
        textItem.font.pointSize: 9
        width: 42
        height: 16

        enabled: DataServiceHub.curLogFile !== ""

        onClicked: {
            if (aboutViewLoader.item == null) {
                aboutViewLoader.sourceComponent = aboutPopup
            } else {
                aboutViewLoader.item.open();
            }
        }
    }

    Loader {
        id: aboutViewLoader
        sourceComponent: undefined
        onLoaded: {
            item.open();
        }

        Connections {
            target: aboutViewLoader.item

            function onClosed() {
                aboutViewLoader.sourceComponent = undefined
            }
        }
    }

    Component {
        id: aboutPopup

        Popup {
            x: mainWindow.width / 2 - width / 2
            y: 100

            width: 400
            height: 300

            modal: true
            closePolicy: Popup.CloseOnPressOutside
            dim: false

            background: Rectangle {
                color: "#3D3D3D"
                radius: 20
            }

            contentItem: Item {
                anchors.fill: parent
                AboutView {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                }
            }
        }
    }
}
