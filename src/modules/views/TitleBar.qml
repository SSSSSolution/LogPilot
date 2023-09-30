import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.platform

import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    color: "black"


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
            verticalCenter: parent.verticalCenter
        }
        width: contentWidth
        height: contentHeight
        text: DataServiceHub.curLogFile
    }

    DefaultTextInput {
        id: clipTextInput
        anchors {
            verticalCenter:  parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        width: 80
        height: 18
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
    }

    DefaultIconButton {
        id: autoScrollIndicator
        iconSrc: "qrc:/icons/down-arrow.svg"
        anchors {
            right: aboutBtn.left
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        width: 20
        height: 20
        opacity: {
            if (DataServiceHub.autoScroll && DataServiceHub.curLogFile !== "") {
                return 1.0
            }
            return 0.5
        }
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
    }
}
