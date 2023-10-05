import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import src.modules.components 1.0

Popup {
    id: r

    padding: 15

    width: 600
    height: 400

    visible: true

    modal: true
    closePolicy: Popup.NoAutoClose
    dim: false

    background: Rectangle {
        color: "#3D3D3D"
        border {
            width: 2
            color: "#9B9B9B"
        }
        radius: 20
    }

    contentItem: Item {
        anchors.centerIn: parent.Center
        width: parent.width
        height: parent.height

        SettingTabBar {
            id: tabBar
            anchors {
                top: parent.top
                left: parent.left
            }
            height: 25
        }

        StackLayout {
            id: tabViews
            anchors {
                top: tabBar.bottom
                left: parent.left
            }
            height: 215
            width: 408

            currentIndex: tabBar.currentIndex

            ColorSettingView {

            }

            RegexSettingView {

            }

            FontSettingView {

            }
        }

        Rectangle {
            id: placeHodler1
            anchors {
                top: tabViews.top
                left: tabViews.right
                right: parent.right
                leftMargin: 5
            }
            height: 317

            color: "#5A5A5A"
            border {
                width: 1
                color: "#9B9B9B"
            }
        }

        Rectangle {
            id: placeHodler2
            anchors {
                top: tabViews.bottom
                topMargin: 5
                bottom: placeHodler1.bottom
                left: tabViews.left
                right: tabViews.right
            }

            Image {
                anchors.margins: 1
                anchors.fill: parent
                source: "qrc:/images/bg.png"
                fillMode: Image.Stretch
            }

            border {
                width: 1
                color: "#9B9B9B"
            }
        }

        DefaultTextButton {
            id: deleteBtn
            anchors {
                top: placeHodler2.bottom
                topMargin: 8
                left: placeHodler2.left
                leftMargin: 10
            }
            width: 75
            height: 24

            backgroundItem.color: "#1F1F1F"
            backgroundItem.border.color: "#9B9B9B"
            backgroundItem.border.width: 1
            backgroundItem.radius: 3
            color: "#D4D4D4"
            textItem.text: "Delete"
            textItem.font.pixelSize: 16
        }

        DefaultTextButton {
            id: saveBtn
            anchors {
                verticalCenter: deleteBtn.verticalCenter
                right: placeHodler2.right
                rightMargin: 10
            }
            width: 75
            height: 24

            backgroundItem.color: "#1F1F1F"
            backgroundItem.border.color: "#9B9B9B"
            backgroundItem.border.width: 1
            backgroundItem.radius: 3
            color: "#D4D4D4"
            textItem.text: "Save"
            textItem.font.pixelSize: 16
        }

        DefaultTextButton {
            id: saveAsBtn
            anchors {
                verticalCenter: deleteBtn.verticalCenter
                right: saveBtn.left
                rightMargin: 20
            }
            width: 100
            height: 24

            backgroundItem.color: "#1F1F1F"
            backgroundItem.border.color: "#9B9B9B"
            backgroundItem.border.width: 1
            backgroundItem.radius: 3
            color: "#D4D4D4"
            textItem.text: "Save as"
            textItem.font.pixelSize: 16
        }

        DefaultTextButton {
            id: closeBtn
            anchors {
                verticalCenter: deleteBtn.verticalCenter
                horizontalCenter: placeHodler1.horizontalCenter
            }
            width: 75
            height: 24

            backgroundItem.color: "#1F1F1F"
            backgroundItem.border.color: "#9B9B9B"
            backgroundItem.border.width: 1
            backgroundItem.radius: 3
            color: "#D4D4D4"
            textItem.text: "Close"
            textItem.font.pixelSize: 16

            onClicked: {
                close()
            }
        }
    }

    Component.onCompleted: {
        var labels = [{label: "Color"}, {label: "Regex"}, {label: "Font"}];
        for (var i = 0; i < labels.length; i++) {
            tabBar.repeater.model.append(labels[i]);
        }
    }
}
