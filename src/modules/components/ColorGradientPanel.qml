import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: r

    implicitHeight: 200
    implicitWidth: 200

    property real huePosition: 0
    property color selectedColor: {
        var x = selectionIndicator.x + selectionIndicator.width / 2
        var y = selectionIndicator.y + selectionIndicator.height / 2
        let saturation = x / width;
        let value = 1 - (y / height);
        return Qt.hsva(r.huePosition, saturation, value, 1)
    }

    border {
        color: "#9B9B9B"
        width: 1
    }
    anchors.margins: 1

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: Qt.hsva(huePosition, 0, 1, 1) }
        GradientStop { position: 1.0; color: Qt.hsva(huePosition, 1, 1, 1) }

    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.hsva(huePosition, 1, 1, 0) }
            GradientStop { position: 1.0; color: Qt.hsva(huePosition, 1, 0, 1) }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: (mouse) => {
            selectionIndicator.x = mouse.x - selectionIndicator.width / 2;
            selectionIndicator.y = mouse.y - selectionIndicator.height / 2;
        }
    }

    Rectangle {
        id: selectionIndicator
        width: 12
        height: 12
        radius: 6
        x: (r.width - width / 2) / 2
        y: (r.height - height / 2) / 2
        color: r.selectedColor
        border.color: "white"
        border.width: 2

        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: selectionIndicator
            drag.threshold: 1
            drag.smoothed: false

            onPositionChanged: {
                // limit x
                if (selectionIndicator.x < - selectionIndicator.width / 2) {
                    selectionIndicator.x = - selectionIndicator.width / 2
                } else if (selectionIndicator.x + selectionIndicator.width / 2 > r.width) {
                    selectionIndicator.x = r.width -  selectionIndicator.width / 2
                }
                // limit y
                if (selectionIndicator.y < - selectionIndicator.height / 2) {
                    selectionIndicator.y = - selectionIndicator.height / 2
                } else if (selectionIndicator.y + selectionIndicator.height / 2 > r.height) {
                    selectionIndicator.y = r.height -  selectionIndicator.height / 2
                }
            }
        }
    }
}
