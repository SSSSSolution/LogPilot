import QtQuick
import QtQuick.Controls.Basic

ComboBox {
    id: c

    textRole: "level"
    valueRole: "color"
    property int fontPointSize
    property bool fontBold: true

    background: Rectangle {
        color: "black"
    }

    contentItem: Text {
        anchors.fill: parent

        text: currentText
        color: {
            if (c.enabled === false) {
                return "#88" + currentValue.slice(1)
            }
            return currentValue
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: c.fontPointSize
        font.bold: c.fontBold
    }

    indicator: Item {
        width: 0
        height: 0
    }

    delegate: Button {
        background: Rectangle {
            color: "black"
        }

        contentItem: Text {
            text: model.level
            color: model.color
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: c.fontPointSize
            font.bold: c.fontBold
        }

        width: c.contentItem.width
        height: c.contentItem.height
    }
}
