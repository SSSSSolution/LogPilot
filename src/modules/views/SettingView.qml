import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import src.modules.components 1.0
import src.modules.data 1.0

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

        Item {
            id: blurSrcItem
            anchors.fill: parent

            SettingTabBar {
                id: tabBar
                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: 15
                }
                height: 25
            }

            StackLayout {
                id: tabViews
                anchors {
                    top: tabBar.bottom
                    left: parent.left
                }
                height: 310
                width: 570

                currentIndex: tabBar.currentIndex

                ColorSettingView {

                }

                RegexSettingView {

                }
            }
        }

        Item {
            id: blurOverlay
            anchors.fill: parent

            ShaderEffect {
                anchors.fill: parent
                property vector2d textureSize: Qt.vector2d(blurSrcItem.width, blurSrcItem.height)
                property variant src: ShaderEffectSource {
                    id: blurSource
                    sourceItem: blurSrcItem
                 }
                fragmentShader: "qrc:/shaders/blur.frag.qsb"
            }
            visible: false
        }
    }

    Component.onCompleted: {
        var labels = [{label: "Color"}, {label: "Regex"}];
        for (var i = 0; i < labels.length; i++) {
            tabBar.repeater.model.append(labels[i]);
        }
    }

    Loader {
        id: newCfgPopupLoader
        sourceComponent: undefined
        onLoaded: {
            item.open()
            blurOverlay.visible = true
        }

        Connections {
            target: newCfgPopupLoader.item
            function onClosed() {
                newCfgPopupLoader.sourceComponent = undefined
                blurOverlay.visible =false
            }
        }
    }

    Component {
        id: newCfgPopupComponent

        Popup {
            id: newCfgPopup
            parent: r.contentItem
            x: r.contentItem.width / 2  - width / 2
            y: r.contentItem.height / 2 - height / 2

            width: 350
            height: 100

            modal: true
            closePolicy: Popup.NoAutoClose
            dim: false

            background: Rectangle {
                color: "#3D3D3D"
                radius: 10
                border {
                    width: 1
                    color: "#9B9B9B"
                }
            }

            contentItem: Item {
                anchors.fill: parent

                Text {
                    id: newCfgLabel
                    anchors {
                        top: parent.top
                        topMargin: 25
                        left: parent.left
                        leftMargin: 25
                    }

                    text: "New Config Name:"
                    width: contentWidth
                    height: contentHeight

                    font.pixelSize: 16
                    color: "#FFFFFF"
                }

                Rectangle {
                    anchors {
                        top: newCfgLabel.top
                        bottom: newCfgLabel.bott
                        right: parent.right
                        rightMargin: 25
                        left: newCfgLabel.right
                        leftMargin: 5
                    }

                    height: newCfgLabel.height
                    color: "#D9D9D9"

                    TextInput {
                        anchors.fill: parent
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.pixelSize: 15
                    }
                }

                DefaultTextButton {
                    id: newCfgCancelBtn
                    anchors {
                        top: newCfgLabel.bottom
                        topMargin: 20
                        left: parent.left
                        leftMargin: 40
                    }
                    width: 75
                    height: 24

                    backgroundItem.color: "#1F1F1F"
                    backgroundItem.border.color: "#9B9B9B"
                    backgroundItem.border.width: 1
                    backgroundItem.radius: 3
                    color: "#D4D4D4"
                    textItem.text: "Cancel"
                    textItem.font.pixelSize: 16

                    onClicked: {
                        newCfgPopup.close()
                    }
                }

                DefaultTextButton {
                    id: newCfgOkBtn
                    anchors {
                        top: newCfgLabel.bottom
                        topMargin: 20
                        right: parent.right
                        rightMargin: 40
                    }
                    width: 75
                    height: 24

                    backgroundItem.color: "#1F1F1F"
                    backgroundItem.border.color: "#9B9B9B"
                    backgroundItem.border.width: 1
                    backgroundItem.radius: 3
                    color: "#D4D4D4"
                    textItem.text: "OK"
                    textItem.font.pixelSize: 16

                    onClicked: {
                        newCfgPopup.close()
                    }
                }
            }
        }
    }
}





























