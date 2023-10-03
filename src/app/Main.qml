import QtQuick
import QtQuick.Window
import QtQuick.Controls

import src.modules.data 1.0
import src.modules.views 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    title: ""

    height: 780
    width: 1280
    minimumHeight: 600
    minimumWidth: 800

    TitleBar {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 35
    }

    Rectangle {
        anchors {
            top:titleBar.bottom
            bottom: bottomBar.top
            left: parent.left
            right: parent.right
        }

        Rectangle {
            id: leftRect
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: 10
            color: "black"
        }

        Rectangle {
            id: rightRect
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: 10
            color: "black"
        }


        LogsView {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: leftRect.right
                right: rightRect.left
            }
        }
    }

    BottomBar {
        id: bottomBar
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 40
    }
}
