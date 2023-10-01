import QtQuick
import QtQuick.Controls.Basic

ScrollBar {
    id: c

    property bool animationRunning: false

    contentItem: Rectangle {
        color: "transparent"
        implicitHeight: 8
        implicitWidth: 8

        Rectangle {
            implicitHeight: {
                if (orientation === Qt.Horizontal)
                    return (c.active || c.pressed) ? 8 : 2
                else
                    return parent.height
            }

            implicitWidth:  {
                if (orientation === Qt.Vertical)
                    return (c.active || c.pressed) ? 8 : 2
                else
                    return parent.width
            }

            anchors {
                verticalCenter: {
                    if (orientation === Qt.Horizontal)
                        return parent.verticalCenter
                }

                horizontalCenter: {
                    if (orientation === Qt.Vertical)
                        return parent.horizontalCenter
                }
            }

            color: c.pressed ? "#524F4F" : Qt.lighter("#524F4F", 1.3)

            opacity: (c.active) ? 0.7 : 0.5

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            Behavior on implicitWidth {
                NumberAnimation { duration: 200 }
            }

            Behavior on implicitHeight {
                NumberAnimation { duration: 200 }
            }

            SequentialAnimation on implicitWidth {
                loops: Animation.Infinite
                running: {
                    if (orientation === Qt.Vertical) {
                        return !c.active && !c.pressed && c.animationRunning
                    }
                    return false;
                }

                PropertyAnimation {
                    to: 8
                    from: 1
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
