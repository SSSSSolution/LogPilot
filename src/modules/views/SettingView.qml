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

            Pane {
                id: configListPane
                anchors {
                    top: tabViews.top
                    left: tabViews.right
                    right: parent.right
                    leftMargin: 5
                }
                height: 317

                background: Rectangle {
                    color: "#5A5A5A"
                    border {
                        width: 1
                        color: "#9B9B9B"
                    }
                }

                contentItem: Item {
                    anchors.fill: parent
                    anchors.margins: 5
                    ListView {
                        id: configList
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            bottom: newCfgBtn.top
                            bottomMargin: 10
                        }

                        model: DataServiceHub.logConfigModel

                        spacing: 2
                        clip: true

                        delegate: Pane {
                            id: configItemPane
                            background: Rectangle {
                                anchors.fill: parent
                                color: configList.currentIndex === index ? "#6E6F6E" : "transparent"
                            }
                            width: configList.width
                            height: 20
                            padding: 0

                            contentItem: Text {
                                anchors.centerIn: parent.Center
                                width: parent.width
                                height: parent.height
                                text: model.name
                                font.bold: true
                                font.pixelSize: 15
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                color: {
                                    var color = "#D4D4D4"
                                    if (model.name === DataServiceHub.defaultConfig.name) {
                                        color = "#E48832"
                                    }

                                    if (configItemPane.hovered) {
                                        color = Qt.lighter(color, 1.5)
                                    }

                                    return color
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        configList.currentIndex = index
                                    }
                                }
                            }
                        }
                    }

                    DefaultTextButton {
                        id: newCfgBtn
                        anchors {
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                            bottomMargin: 5
                        }
                        width: 110
                        height: 24

                        backgroundItem.color: "#1F1F1F"
                        backgroundItem.border.color: "#9B9B9B"
                        backgroundItem.border.width: 1
                        backgroundItem.radius: 3
                        color: "#D4D4D4"
                        textItem.text: "New Config"
                        textItem.font.pixelSize: 16

                        onClicked: {
                            if (newCfgPopupLoader.item == null) {
                                newCfgPopupLoader.sourceComponent = newCfgPopupComponent
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: placeHodler2
                anchors {
                    top: tabViews.bottom
                    topMargin: 5
                    bottom: configListPane.bottom
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
                    horizontalCenter: configListPane.horizontalCenter
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
        var labels = [{label: "Color"}, {label: "Regex"}, {label: "Font"}];
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





























