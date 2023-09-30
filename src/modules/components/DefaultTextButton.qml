import QtQuick
import QtQuick.Controls.Basic

Button {
    id: c

    property alias textItem: textItem
    property string color: "#9B9B9B"

    background: Rectangle {
        color: "transparent"
    }

    contentItem: Text {
        id: textItem
        anchors.fill: parent
        antialiasing: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: {
            if (c.pressed) {
                return Qt.darker(c.color, 1.3)
            } else if (c.hovered) {
                return Qt.lighter(c.color, 1.3)
            } else {
                return c.color
            }
        }

    }
}
