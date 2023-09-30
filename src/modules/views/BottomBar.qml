import QtQuick
import QtQuick.Controls.Basic
import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    color: "black"


    LevelComboBox {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }

        width: 50
        height: 22

        fontPointSize: 9

        currentIndex: 5 - DataServiceHub.logLevel

        model: ListModel {
            ListElement { level: "FATAL"; color: "#FF0006"}
            ListElement { level: "ERROR"; color: "#FF6B68"}
            ListElement { level: "WARN"; color: "#0070BB"}
            ListElement { level: "INFO"; color: "#48BB31"}
            ListElement { level: "DEBUG"; color: "#faaa0a"}
            ListElement { level: "TRACE"; color: "#FFFFFF"}
        }

        onCurrentTextChanged: {
            if (currentIndex === 5 - DataServiceHub.logLevel)
                return;

            if (currentText === "FATAL") {
                DataServiceHub.setLogLevel(5);
            } else if (currentText === "ERROR") {
                DataServiceHub.setLogLevel(4);
            } else if (currentText === "WARN") {
                DataServiceHub.setLogLevel(3);
            } else if (currentText === "INFO") {
                DataServiceHub.setLogLevel(2);
            } else if (currentText === "DEBUG") {
                DataServiceHub.setLogLevel(1);
            } else if (currentText === "TRACE") {
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
    }

}
