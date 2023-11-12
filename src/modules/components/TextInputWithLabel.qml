import QtQuick
import QtQuick.Controls.Basic

Pane {
    id: c

    property bool inputValid: true

    property alias labelItem: labelItem
    property alias textInputItem: textInputItem

    padding: 0

    background: Item {}

    contentItem: Item  {
        anchors.centerIn: parent.Center
        width: parent.width
        height: 20

        Text {
            id: labelItem
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Pane {
            padding: 0
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: labelItem.right
                right: parent.right
            }

            background: Rectangle {
                id: textInputBg
                color: "#2C2C2C"
                radius: 3
                border {
                    width: 1
                    color: {
                        if (!c.inputValid) {
                            return "#D34646"
                        }
                        if (c.focus) {
                            return "#FFC83A"
                        }
                        return "#756E6E"
                    }
                }
            }
            focusPolicy: Qt.TabFocus

            contentItem: TextInput {
                id: textInputItem
                anchors.centerIn: parent.Center
                width: parent.width
                height: parent.height

                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }
        }
    }


}
