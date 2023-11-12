import QtQuick
import QtQuick.Controls.Basic
import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    id: r
    color: "black"

    property var session: undefined
    property var levelsConfig: (session == null || session.config == null) ? undefined : session.config.levels

    onLevelsConfigChanged: {
        if (levelsConfig == null)
            return
        // Refresh level Model
        let oldIdx = levelComboBox.currentIndex
        levelModel.clear()
        const levels = ["fatal", "error", "warn", "info", "debug", "trace", "none"];
        for (let level of levels) {
            levelModel.append({level: level.toUpperCase(), color: levelsConfig[level].color});
        }
        levelComboBox.currentIndex = oldIdx
    }

    LevelComboBox {
        id: levelComboBox
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }

        width: 50
        height: 22

        fontPointSize: 9

        enabled: (session == null) ? false : session.loaded

        currentIndex: (session == null) ? 6 : 6 - session.logLevel

        model: ListModel {
            id: levelModel
        }

        onCurrentTextChanged: {
            if (currentText === "FATAL") {
                session.setLogLevel(6);
            } else if (currentText === "ERROR") {
                session.setLogLevel(5);
            } else if (currentText === "WARN") {
                session.setLogLevel(4);
            } else if (currentText === "INFO") {
                session.setLogLevel(3);
            } else if (currentText === "DEBUG") {
                session.setLogLevel(2);
            } else if (currentText === "TRACE") {
                session.setLogLevel(1);
            } else if (currentText === "NONE") {
                session.setLogLevel(0);
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
                session.setFilter(textInput.text);
            }
        }

        Keys.onReturnPressed: {
            session.setFilter(textInput.text);
        }

        enabled: (session == null) ? false : session.loaded
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
            session.setFilter(searchTextInput.textInput.text);
        }

        enabled: (session == null) ? false : session.loaded
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

