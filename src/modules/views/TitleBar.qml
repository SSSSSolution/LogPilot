import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.platform

import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    id: r
    color: "black"

    property var session: undefined

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
                session.setLogFile(fileDialog.currentFile)
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
        text: (session == null) ? "" : session.logPath
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
            session.setClipLine(convertStrToNumber(textInput.text))
        }

        enabled: (session == null) ? false : session.loaded
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
            session.setClipLine(convertStrToNumber(clipTextInput.textInput.text))
        }

        enabled: (session == null) ? false : session.loaded
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

        onClicked: {
            if (aboutViewLoader.item == null) {
                aboutViewLoader.sourceComponent = aboutPopupComponent
            } else {
                return
            }
        }
    }

    Loader {
        id: aboutViewLoader
        sourceComponent: undefined
        onLoaded: {
            item.open();
            DataServiceHub.mainWindowNeedBlur = true
        }

        Connections {
            target: aboutViewLoader.item

            function onClosed() {
                aboutViewLoader.sourceComponent = undefined
                DataServiceHub.mainWindowNeedBlur = false
            }
        }
    }

    Component {
        id: aboutPopupComponent

        Popup {
            id: aboutPopup
            parent: mainWindow.contentItem
            x: parent.width / 2 - width / 2
            y: 100

            width: 400
            height: 335

            modal: true
            closePolicy: Popup.NoAutoClose
            dim: false

            background: Rectangle {
                color: "#3D3D3D"
                radius: 20
                border {
                    width: 1
                    color: "#88E0E0E0"
                }
            }

            contentItem: Item {
                anchors.fill: parent
                AboutView {
                    id: aboutView
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                }

                DefaultTextButton {
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 10
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: 70
                    height: 20
                    textItem.text: "OK"
                    textItem.font.pixelSize: 14
                    color: "#E48832"
                    backgroundItem.color: "#525252"
                    backgroundItem.radius: 3
                    backgroundItem.border.color: "#757575"
                    backgroundItem.border.width: 1

                    onClicked: {
                        aboutPopup.close()
                    }
                }
            }
        }
    }
}
