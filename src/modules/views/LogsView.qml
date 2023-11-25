import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.platform

import src.modules.data 1.0
import src.modules.components 1.0

Pane {
    property alias bgRect: bgRect

    background: Rectangle {
        id: bgRect
        border.width: 0
        color: "transparent"
        Image {
            anchors.fill: parent
            anchors.margins: parent.border.width
            source: "qrc:/images/bg.png"
            fillMode: Image.Stretch
        }
    }

    padding: 0

    property var session: undefined

    onSessionChanged: {
        if (session == null)
            return
        noneColor = session.config.levels.none.color
        traceColor = session.config.levels.trace.color
        debugColor = session.config.levels.debug.color
        infoColor = session.config.levels.info.color
        warnColor = session.config.levels.warn.color
        errorColor = session.config.levels.error.color
        fatalColor = session.config.levels.fatal.color

        session.onConfigChanged.connect(function(){
            noneColor = session.config.levels.none.color
            traceColor = session.config.levels.trace.color
            debugColor = session.config.levels.debug.color
            infoColor = session.config.levels.info.color
            warnColor = session.config.levels.warn.color
            errorColor = session.config.levels.error.color
            fatalColor = session.config.levels.fatal.color
        })
    }

    property string noneColor: "#FFFFFF"
    property string traceColor: "#FFFFFF"
    property string debugColor: "#FFFFFF"
    property string infoColor: "#FFFFFF"
    property string warnColor: "#FFFFFF"
    property string errorColor: "#FFFFFF"
    property string fatalColor: "#FFFFFF"

    property var levelsConfig: {
        if (session == null ||  session.config == null)
            return undefined
        return session.config.levels
    }


    function replaceFilterText(msg) {
        if (typeof msg !== 'string'|| msg.trim() === "") {
            return ""
        }
        if (session.filter.trim() === "") {
            return msg;
        }

        var resStr = msg.replace(session.filterRegExp, function(matched){
            return "<span style='background-color: rgba(210, 180, 70, 0.3);'>" +  matched + "</span>";
        })

        return resStr
    }

    AboutView {
        visible: (session == null) || ((session.loaded === false) && (session.name !== "example"))
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 100
        }
    }

    ListView {
        id: logView

        anchors {
            bottom: parent.bottom
            top: parent.top
            right: parent.right
            left: parent.left
        }

        keyNavigationEnabled: false

//        FpsItem {
//            id: fpsItem

//            anchors.right: parent.right
//            anchors.rightMargin: 10
//            anchors.top: parent.top

//            width: textItem.contentWidth
//            height: 30

//            Text {
//                id: textItem
//                anchors.fill: parent
//                text: "FPS: " + fpsItem.fps;
//                color: "#88E0E0E0"
//                font.pixelSize: 20
//                font.bold: true
//            }
//        }

        cacheBuffer: 1000
        reuseItems: true
        clip: true
        model: {
            if (session == null) {
                return null
            }
            return session.logModel
        }

        boundsBehavior: Flickable.StopAtBounds
        flickDeceleration: 7820

        property real lastContentY: 0
        property string scrollDirection: "None"

        onMovingChanged: {
            if (moving) {
                session.setAutoScroll(false)
            } else {
                if ((scrollBar.size + scrollBar.position >= 0.9999999) && (scrollBar.active === false)) {
                    session.setAutoScroll(true)
                }
            }
        }

        property int count: 0
        Timer {
            id: autoScrollTimer
            running: session.enableAutoScroll
            interval: 40
            triggeredOnStart: true
            repeat: true
            onTriggered: {
                if (session.autoScroll) {
                    logView.positionViewAtEnd();
                }
            }
        }

        ScrollBar.vertical:  DefaultScrollBar{
            id: scrollBar
            snapMode: ScrollBar.NoSnap
            animationRunning: session.enableAutoScroll && session.autoScroll

            visible: logView.contentHeight > logView.height

            onPressedChanged: {
                if (pressed) {
                    session.setAutoScroll(false)
                } else {
                    if ((size + position >= 0.9999999) && (scrollBar.active === false)) {
                        session.setAutoScroll(true)
                    }
                }
            }

            onPositionChanged: {
                if ((size + position >= 0.9999999) && (scrollBar.active === false)) {
                    session.setAutoScroll(true)
                }
            }
        }

        delegate: Rectangle {
            id: delegateRoot
            color: "transparent"
            clip: true

            width: logView.width
            height: text.contentHeight

            Text {
                id: lineLabel
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: 2
                }

                text: "<p style='line-height: 115%;'>" + model.line  + " " + "</p>"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                font.family: sharedFont.family
                font.pixelSize:15
                color: "grey"
                textFormat: Text.RichText
            }

            TextEdit {
                id: text
                anchors {
                    left: lineLabel.right
                    leftMargin: 2
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: 2
                }
                textFormat: TextEdit.RichText
                text: "<p style='line-height: 115%;'>" +
                      "<font color='" + fontColor + "'>" + replaceFilterText(model.msg) + "</font>" + "</p>"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAnywhere
                readOnly: true

                font.family: sharedFont.family
                font.pixelSize:15

                property string fontColor: {
                    if (model.level === 0) {
                        return noneColor
                    } else if (model.level === 1) {
                        return traceColor
                    } else if (model.level === 2) {
                        return debugColor
                    } else if (model.level === 3) {
                        return infoColor
                    } else if (model.level === 4) {
                        return warnColor
                    } else if (model.level === 5) {
                        return errorColor
                    } else if (model.level === 6) {
                        return fatalColor
                    } else {
                        return "#000000" // unknow
                    }
                }

                color: "grey"
            }

            TextMetrics {
                id: textMetrics
                font: text.font
                text: "m"
            }
        }

        SequentialAnimation on contentY {
            id: scrollDownAnimation
            loops: 1
            running: false

            PropertyAnimation {
                to: logView.contentHeight + logView.originY - logView.height
                duration: 250
            }

            onFinished: {
                session.setAutoScroll(true)
            }
        }

        DefaultIconButton {
            id: scrollDownBtn
            iconSrc: "qrc:/icons/scroll-down.svg"
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: 50
                rightMargin: 50
            }
            width: 50
            height: 50

            visible: session.enableAutoScroll
            enabled: !session.autoScroll

            onPressed: {
                if (scrollDownAnimation.running) {
                    return
                }
                scrollDownAnimation.start()
            }
        }

        QtObject {
            id: sharedFont
            property string family: "DejaVu Sans Mono"
            property int pixelSize: 16
        }
    }
}
