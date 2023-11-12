import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: r

    implicitHeight: 10
    implicitWidth: 200
    radius: 6

    property real huePosition: (draggableDot.x + draggableDot.width / 2) / width
    property color selectedColor: Qt.hsva(huePosition, 1.0, 1.0, 1.0)

    function setHuePosition(huePos) {
        draggableDot.x = (huePos * width) - draggableDot.width/2
    }

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: "#FF0000" }
        GradientStop { position: 0.1667; color: "#FFFF00" }
        GradientStop { position: 0.3333; color: "#00FF00" }
        GradientStop { position: 0.5; color: "#00FFFF" }
        GradientStop { position: 0.6667; color: "#0000FF" }
        GradientStop { position: 0.8333; color: "#FF00FF" }
        GradientStop { position: 1.0; color: "#FF0000" }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: (mouse) => {
            draggableDot.x = mouse.x - draggableDot.width/2
        }
        cursorShape: Qt.PointingHandCursor
    }

    Rectangle {
        id: draggableDot
        width: 12
        height: 12
        radius: 6

        color: r.selectedColor
        border.color: "white"
        border.width: 2
        antialiasing: true
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: draggableDot
            drag.threshold: 1
            drag.smoothed: false

            onPositionChanged: {
                if (draggableDot.x < - draggableDot.width / 2) {
                    draggableDot.x = - draggableDot.width / 2
                } else if (draggableDot.x + draggableDot.width / 2 > r.width) {
                    draggableDot.x = r.width -  draggableDot.width / 2
                }
            }

            cursorShape: Qt.PointingHandCursor
            drag.axis: Drag.XAxis
        }
    }

}
