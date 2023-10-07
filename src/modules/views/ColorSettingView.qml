import QtQuick
import QtQuick.Controls.Basic

import src.modules.components 1.0

Rectangle {
    id: r

    color: "#5A5A5A"
    border {
        color: "#9B9B9B"
        width: 1
    }
    radius: 10

    ColorGradientPanel {
        id: colorGradientPanel
        anchors {
            top: parent.top
            topMargin: 15
            right: parent.right
            rightMargin: 15
        }
        width: 250
        height: 250

        huePosition: hueSlider.huePosition
    }

    HueSlider {
        id: hueSlider
        anchors {
            top: colorGradientPanel.bottom
            topMargin: 20
            left: colorGradientPanel.left
            right: colorGradientPanel.right
        }
        width: 250
        height: 6
    }

    Column {
        anchors {
            top: parent.top
            topMargin: 12
            left: parent.left
            leftMargin: 16
        }

        width: 120
        spacing: 8


        TextInputWithLabel {
            id: noneInput
            height: 20
            width: 120

            labelItem.width: 50
            labelItem.text: "None"
        }

        Row {
            height: 20
            width: 120

            Text {
                width: 50
                text: "Trace"
                height: contentHeight

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 12
                font.bold: true
                color: "white"
            }

            Rectangle {
                width: 70
                height: 18
                color: "#D9D9D9"
                TextInput {
                    anchors.fill: parent
                }
            }
        }

        Row {
            height: 20
            width: 120

            Text {
                width: 50
                text: "Debug"
                height: contentHeight

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 12
                font.bold: true
                color: "white"
            }

            Rectangle {
                width: 70
                height: 18
                color: "#D9D9D9"
                TextInput {
                    anchors.fill: parent
                }
            }
        }

        Row {
            height: 20
            width: 120

            Text {
                width: 50
                text: "Info"
                height: contentHeight

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 12
                font.bold: true
                color: "white"
            }

            Rectangle {
                width: 70
                height: 18
                color: "#D9D9D9"
                TextInput {
                    anchors.fill: parent
                }
            }
        }

        Row {
            height: 20
            width: 120

            Text {
                width: 50
                text: "Warn"
                height: contentHeight

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 12
                font.bold: true
                color: "white"
            }

            Rectangle {
                width: 70
                height: 18
                color: "#D9D9D9"
                TextInput {
                    anchors.fill: parent
                }
            }
        }

        Row {
            height: 20
            width: 120

            Text {
                width: 50
                text: "Error"
                height: contentHeight

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 12
                font.bold: true
                color: "white"
            }

            Rectangle {
                width: 70
                height: 18
                color: "#D9D9D9"
                TextInput {
                    anchors.fill: parent
                }
            }
        }

        Row {
            height: 20
            width: 120

            Text {
                width: 50
                text: "Fatal"
                height: contentHeight

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 12
                font.bold: true
                color: "white"
            }

            Rectangle {
                width: 70
                height: 18
                color: "#D9D9D9"
                TextInput {
                    anchors.fill: parent
                }
            }
        }

    }

}
