import QtQuick
import QtQuick.Controls.Basic

Button {
    id: c

    property alias bgRect: bgRect
    property alias textItem: textItem

    property string bgColor: "#525252"
    property string borderColor: "#757575"
    property string textColor: "#E0E0E0"

    background: Rectangle {
        id: bgRect

        color: {
            if (!c.enabled) {
                return "#88" + c.bgColor.slice(1)
            }

            if (c.pressed) {
                return Qt.darker(c.bgColor, 1.3)
            }

            if (c.hovered) {
                return Qt.lighter(c.bgColor, 1.3)
            }

            return c.bgColor
        }

        border {
            width: 1
            color: c.borderColor
        }

        radius: 3
    }

    contentItem: Text {
        id: textItem
        color: {
            if (!c.enabled) {
                return "#88" + c.textColor.slice(1)
            }
            return c.textColor
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
