import QtQuick
import QtQuick.Controls.Basic
import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    id: r
    color: "black"

    property var levelsConfig: DataServiceHub.curConfig.levels

    onLevelsConfigChanged: {
        // Reset level Model
        const levels = ["fatal", "error", "warn", "info", "debug", "trace", "none"];
        for (let level of levels) {
            levelModel.append({level: level.toUpperCase(), color: levelsConfig[level].color});
        }
    }

    LevelComboBox {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }

        width: 50
        height: 22

        fontPointSize: 9

        enabled: DataServiceHub.logLoaded

        currentIndex: 6 - DataServiceHub.logLevel

        model: ListModel {
            id: levelModel
        }

        onCurrentTextChanged: {
            if (currentText === "FATAL") {
                DataServiceHub.setLogLevel(6);
            } else if (currentText === "ERROR") {
                DataServiceHub.setLogLevel(5);
            } else if (currentText === "WARN") {
                DataServiceHub.setLogLevel(4);
            } else if (currentText === "INFO") {
                DataServiceHub.setLogLevel(3);
            } else if (currentText === "DEBUG") {
                DataServiceHub.setLogLevel(2);
            } else if (currentText === "TRACE") {
                DataServiceHub.setLogLevel(1);
            } else if (currentText === "NONE") {
                DataServiceHub.setLogLevel(0);
            } else {
                console.error("Unknow level: ", currentText)
            }
        }
    }

    DefaultTextInput {
        id: searchTextInput
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        width: 165
        height: 22
        textInput.font.pointSize: 11

        textInput.onTextChanged: {
            if (textInput.text === "") {
                DataServiceHub.setFilter(textInput.text);
            }
        }

        Keys.onReturnPressed: {
            DataServiceHub.setFilter(textInput.text);
        }

        enabled: DataServiceHub.logLoaded
    }

    SearchButton {
        id: searchBtn
        anchors {
            verticalCenter: parent.verticalCenter
            left: searchTextInput.right
            leftMargin: 5
        }
        width: 25
        height: 25

        onClicked: {
            DataServiceHub.setFilter(searchTextInput.textInput.text);
        }

        enabled: DataServiceHub.logLoaded
    }

    DefaultIconButton {
        id: settingBtn
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 20
        }

        height: 25
        width: 25
        iconSrc: "qrc:/icons/setting.svg"

        onClicked: {
            if (settinvViewLoader.item == null) {
                settinvViewLoader.sourceComponent = settingPopupComponent
            } else {
                return
            }
        }
    }

    Loader {
        id: settinvViewLoader
        sourceComponent: undefined

        onLoaded: {
            item.open()
            DataServiceHub.mainWindowNeedBlur = true
        }

        Connections {
            target: settinvViewLoader.item

            function onClosed() {
                console.log("load item closed")
                settinvViewLoader.sourceComponent = undefined
                DataServiceHub.mainWindowNeedBlur = false
            }
        }
    }

    Component {
        id: settingPopupComponent

        SettingView {
            id: settingPopup
            parent: mainWindow.contentItem
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
        }
    }
}

