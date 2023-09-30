import QtQuick
import QtQuick.Controls.Basic

Pane {
    id: c
    property alias textInput: textInput

    padding: 0

    background: Rectangle {
        anchors.fill: parent
        color: "#524F4F"
    }

    TextInput {
        id: textInput
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        clip: true

        font.family: "Inter"
        font.pointSize: 9
        font.bold: false

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        antialiasing: true
        color: "#E0E0E0"
    }
}
