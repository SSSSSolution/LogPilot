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

    LogSessionView {
        id: mainItem
        anchors.fill: parent
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
