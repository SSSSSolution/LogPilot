import QtQuick
import QtQuick.Window
import QtQuick.Controls

import src.modules.data 1.0
import src.modules.views 1.0

Window {
    id: mainWindow
    visible: true
    title: " "

    height: 780
    width: 1280
    minimumHeight: 600
    minimumWidth: 800

    Item {
        id: mainItem
        anchors.fill: parent

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

    Item {
        id: blurOverlay
        anchors {
            top: mainItem.top
            bottom: mainItem.bottom
            left: mainItem.left
            right: mainItem.right
        }


        ShaderEffect {
            anchors.fill: parent
            property vector2d textureSize: Qt.vector2d(mainItem.width, mainItem.height)
            property variant src: ShaderEffectSource {
                id: blurSource
                sourceItem: mainItem
             }
            fragmentShader: "qrc:/shaders/blur.frag.qsb"
        }
        visible: DataServiceHub.mainWindowNeedBlur
    }
}
