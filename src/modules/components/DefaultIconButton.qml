import QtQuick
import QtQuick.Controls.Basic

Button {
    id: c

    property alias iconSrc: icon.source
    property string iconColor: "#9B9B9B"

    padding: 0

    background: Rectangle {
        color: "transparent"
    }

    contentItem: IconImage {
        id: icon
        anchors.fill: parent
        antialiasing: true
        fillMode: IconImage.Stretch

        color: {
            if (c.enabled === false) {
                return Qt.darker(c.iconColor, 1.5)
            }
            if (c.pressed) {
                return Qt.darker(c.iconColor, 1.3)
            } else if (c.hovered) {
                return Qt.lighter(c.iconColor, 1.3)
            } else {
                return c.iconColor
            }
        }
    }
}
