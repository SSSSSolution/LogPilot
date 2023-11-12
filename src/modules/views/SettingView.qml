import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import src.modules.components 1.0
import src.modules.data 1.0

Popup {
    id: r

    padding: 12

    width: 600
    height: 400

    visible: true

    modal: true
    closePolicy: Popup.NoAutoClose
    dim: false

    function applyConfig() {
        var colorCfgRes = colorSettingView.getColorCfg()
        if (colorCfgRes.error) {
            console.error(colorCfgRes.error)
            return false
        }

        var regexCfgRes = regexSettingView.getRegexCfg()
        if (regexCfgRes.error) {
            console.error(regexCfgRes.error)
            return false
        }

        DataServiceHub.config.setColor(colorCfgRes.config)
        DataServiceHub.config.setRegex(regexCfgRes.config)

        DataServiceHub.config.configChanged()
        if (!DataServiceHub.config.save()) {
            console.error("Failed to save config.")
        }
        return true
    }

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
            anchors.fill: parent

            SettingTabBar {
                id: tabBar
                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: 15
                }
                height: 25

                focusPolicy: Qt.NoFocus
            }

            StackLayout {
                id: tabViews
                anchors {
                    top: tabBar.bottom
                    left: parent.left
                    right: parent.right
                }
                height: 310

                currentIndex: tabBar.currentIndex

                ColorSettingView {
                    id: colorSettingView
                }

                RegexSettingView {
                    id: regexSettingView
                }
            }

            AccentButton {
                id: applyBtn
                anchors {
                    right: parent.right
                    rightMargin: 15
                    bottom: parent.bottom
                    bottomMargin: 2
                }
                width: 75
                height: 25
                textItem.text: "Apply"
                textItem.font.pixelSize: 13
                focusPolicy: Qt.NoFocus

                onClicked: {
                    applyConfig()
                }
            }

            NegativeButton {
                id: cancelBtn
                anchors {
                    right: applyBtn.left
                    rightMargin: 15
                    top: applyBtn.top
                    bottom: applyBtn.bottom
                }
                width: 75
                height: 25
                textItem.text: "Cancel"
                textItem.font.pixelSize: 13
                focusPolicy: Qt.NoFocus

                onClicked: {
                    r.close()
                }
            }

            AccentButton {
                id: okBtn
                anchors {
                    right: cancelBtn.left
                    rightMargin: 15
                    top: applyBtn.top
                    bottom: applyBtn.bottom
                }
                width: 75
                height: 25
                textItem.text: "OK"
                textItem.font.pixelSize: 13
                focusPolicy: Qt.NoFocus

                onClicked: {
                    applyConfig()
                    r.close()
                }
            }
        }
    }

    Component.onCompleted: {
        var labels = [{label: "Color"}, {label: "Regex"}];
        for (var i = 0; i < labels.length; i++) {
            tabBar.repeater.model.append(labels[i]);
        }
    }

}


