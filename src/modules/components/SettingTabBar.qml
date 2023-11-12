import QtQuick
import QtQuick.Controls.Basic

TabBar {
    id: c

    property alias repeater: repeater
    property string backgroundColor: "#3D3D3D"

    contentWidth: btnModel.count * 75 + btnModel.count * 2 - 1
    contentHeight: height
    background: Rectangle {
        color: "#9B9B9B"
    }
    padding: 1

    Repeater {
        id: repeater

        model: ListModel {
            id: btnModel
        }

        delegate: TabButton {
            id: btn
            focusPolicy: Qt.NoFocus

            contentItem: Text {
                text: model.label
                color: "#D4D4D4"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Inter"
                font.pixelSize: 16
            }

            background: Rectangle {
                color: {
                    if (btn.pressed)
                        return Qt.darker(c.backgroundColor, 1.5)
                    if (btn.hovered)
                        return Qt.lighter(c.backgroundColor, 1.5)
                    if (c.currentIndex === index) {
                        return Qt.darker(c.backgroundColor, 1.3)
                    } else {
                        return c.backgroundColor
                    }
                }
            }
        }
    }
}
