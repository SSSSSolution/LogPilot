import QtQuick
import QtQuick.Controls.Basic

import src.modules.data 1.0
import src.modules.components 1.0

Rectangle {
    id: r

    function getRegexCfg() {
        var cfg = {
            trace: {
                regex: listModel.get(0).regex,
                matchTest: listModel.get(0).matchTest
            },
            debug: {
                regex: listModel.get(1).regex,
                matchTest: listModel.get(1).matchTest
            },
            info: {
                regex: listModel.get(2).regex,
                matchTest: listModel.get(2).matchTest
            },
            warn: {
                regex: listModel.get(3).regex,
                matchTest: listModel.get(3).matchTest
            },
            error: {
                regex: listModel.get(4).regex,
                matchTest: listModel.get(4).matchTest
            },
            fatal: {
                regex: listModel.get(5).regex,
                matchTest: listModel.get(5).matchTest
            }
        }

        return { error: null, config: cfg}
    }

    color: "#5A5A5A"
    border {
        color: "#9B9B9B"
        width: 1
    }
    radius: 10

    DefaultText {
        id: regexLabel
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 115
        }

        width: contentWidth
        height: contentHeight
        color: "#E0E0E0"
        text: "Regex"
        font.pixelSize: 13
    }

    DefaultText {
        id: matchTestLabel
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 350
        }

        width: contentWidth
        height: contentHeight
        color: "#E0E0E0"
        text: "Match Test"
        font.pixelSize: 13
    }

    Column {
        anchors {
            top: regexLabel.bottom
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
        }

        spacing: 10
        Repeater {
            model: listModel
            delegate: inputComponent
        }
    }

    ListModel {
        id: listModel
        ListElement {
            label: "Trace:"
            labelColor: "#FFFFFF"
            regex: ""
            matchTest: ""
        }
        ListElement {
            label: "Debug:"
            labelColor: "#FFFFFF"
            regex: ""
            matchTest: ""
        }
        ListElement {
            label: "Info:"
            labelColor: "#FFFFFF"
            regex: ""
            matchTest: ""
        }
        ListElement {
            label: "warn:"
            labelColor: "#FFFFFF"
            regex: ""
            matchTest: ""
        }
        ListElement {
            label: "Error:"
            labelColor: "#FFFFFF"
            regex: ""
            matchTest: ""
        }
        ListElement {
            label: "Fatal:"
            labelColor: "#FFFFFF"
            regex: ""
            matchTest: ""
        }
    }

    function setModel() {
        listModel.setProperty(0, "labelColor", DataServiceHub.config.value.levels.trace.color)
        listModel.setProperty(1, "labelColor", DataServiceHub.config.value.levels.debug.color)
        listModel.setProperty(2, "labelColor", DataServiceHub.config.value.levels.info.color)
        listModel.setProperty(3, "labelColor", DataServiceHub.config.value.levels.warn.color)
        listModel.setProperty(4, "labelColor", DataServiceHub.config.value.levels.error.color)
        listModel.setProperty(5, "labelColor", DataServiceHub.config.value.levels.fatal.color)

        listModel.setProperty(0, "regex", DataServiceHub.config.value.levels.trace.regex)
        listModel.setProperty(1, "regex", DataServiceHub.config.value.levels.debug.regex)
        listModel.setProperty(2, "regex", DataServiceHub.config.value.levels.info.regex)
        listModel.setProperty(3, "regex", DataServiceHub.config.value.levels.warn.regex)
        listModel.setProperty(4, "regex", DataServiceHub.config.value.levels.error.regex)
        listModel.setProperty(5, "regex", DataServiceHub.config.value.levels.fatal.regex)

        listModel.setProperty(0, "matchTest", DataServiceHub.config.value.levels.trace.matchTest)
        listModel.setProperty(1, "matchTest", DataServiceHub.config.value.levels.debug.matchTest)
        listModel.setProperty(2, "matchTest", DataServiceHub.config.value.levels.info.matchTest)
        listModel.setProperty(3, "matchTest", DataServiceHub.config.value.levels.warn.matchTest)
        listModel.setProperty(4, "matchTest", DataServiceHub.config.value.levels.error.matchTest)
        listModel.setProperty(5, "matchTest", DataServiceHub.config.value.levels.fatal.matchTest)
    }

    Component.onCompleted: {
        setModel()
    }

    Component {
        id: inputComponent

        Item {
            height: 25
            anchors {
                left: parent.left
                right: parent.right
            }

            TextInputWithLabel {
                id: regexInput
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                width: 200

                labelItem.width: 50
                labelItem.text: model.label
                labelItem.color: model.labelColor
                textInputItem.color: "#FFFFFF"
                labelItem.font.pixelSize: 13
                textInputItem.font.pixelSize: 13
                textInputItem.text: model.regex

                textInputItem.onTextChanged: {
                    listModel.setProperty(index, "regex", textInputItem.text)
                }
            }

            TextInputWithLabel {
                id: regexTestInput
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: regexInput.right
                    leftMargin: 10
                    right: indicator.left
                    rightMargin: 5
                }

                labelItem.width: 0
                textInputItem.color: "#FFFFFF"
                textInputItem.font.pixelSize: 13
                textInputItem.text: model.matchTest

                textInputItem.onTextChanged: {
                    listModel.setProperty(index, "matchTest", textInputItem.text)
                }
            }

            IconImage {
                id: indicator
                anchors {
                    top: parent.top
                    topMargin: 2
                    bottom: parent.bottom
                    bottomMargin: 2
                    right: parent.right
                }

                width: height
                source: {
                    if (regexTestInput.textInputItem.text === "") {
                        return ""
                    }

                    var isMatch = DataServiceHub.testRegexMatch(regexTestInput.textInputItem.text,
                                                                regexInput.textInputItem.text)
                    if (isMatch) {
                        return "qrc:/icons/check-mark.svg"
                    } else {
                        return "qrc:/icons/cross-mark.svg"
                    }
                }
            }
        }
    }
}
