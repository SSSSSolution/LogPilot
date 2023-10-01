import QtQuick
import QtQuick.Controls.Basic

import src.modules.data 1.0
import src.modules.components 1.0

Pane {
    background: Image {
        source: "qrc:/images/bg.png"
        fillMode: Image.Stretch
    }

    padding: 0

ListView {
    id: logView

    anchors {
        bottom: parent.bottom
        top: parent.top
        right: parent.right
        left: parent.left
    }

    FpsItem {
        id: fpsItem

        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top

        width: textItem.contentWidth
        height: 30

        Text {
            id: textItem
            anchors.fill: parent
            text: "FPS: " + fpsItem.fps;
            color: "#88E0E0E0"
            font.pixelSize: 20
            font.bold: true
        }
    }

    cacheBuffer: 1000
    reuseItems: true
    clip: true
    model: DataServiceHub.logWatcherService.logData

    boundsBehavior: Flickable.StopAtBounds
    flickDeceleration: 7820

    property real lastContentY: 0
    property string scrollDirection: "None"

    onMovingChanged: {
        if (moving) {
            DataServiceHub.setAutoScroll(false);
        } else  {
            console.log("move -> false ", scrollBar.size + scrollBar.position + " " + scrollBar.active);
            if ((scrollBar.size + scrollBar.position >= 0.9999999) && (scrollBar.active === false)) {
                DataServiceHub.setAutoScroll(true);
            }
        }
    }

    property int count: 0
    Timer {
        id: autoScrollTimer
        running: true
        interval: 40
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            if (DataServiceHub.autoScroll) {
                logView.positionViewAtEnd();
            }
        }
    }

    ScrollBar.vertical:  DefaultScrollBar{
        id: scrollBar
        snapMode: ScrollBar.NoSnap
        animationRunning: DataServiceHub.autoScroll

        visible: logView.contentHeight > logView.height

        onPressedChanged: {
            if (pressed) {
                DataServiceHub.setAutoScroll(false);
            } else {
                if ((size + position >= 0.9999999) && (scrollBar.active === false)) {
                    DataServiceHub.setAutoScroll(true);
                }
            }
        }

        onPositionChanged: {
            if ((size + position >= 0.9999999) && (scrollBar.active === false)) {
                DataServiceHub.setAutoScroll(true);
            }
        }
    }

    delegate: Rectangle {
        id: delegateRoot
        color: "transparent"
        clip: true

        width: logView.width
        height: text.contentHeight

        TextEdit {
            id: text
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.fill: parent
            textFormat: TextEdit.RichText
            text: "<p style='line-height: 120%;'>" + model.line + " " +
                  "<font color='" + fontColor + "'>" + replaceFilterText(model.msg) + "</font>" + "</p>"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAnywhere
            readOnly: true

            font.family: sharedFont.family
            font.pixelSize:16

            property string fontColor: {
                if (model.level === 0) {
                    return "#FFFFFF"; // Trace
                } else if (model.level === 1) {
                    return "#faaa0a";
                } else if (model.level === 2) {
                    return "#48BB31";  // Info
                } else if (model.level === 3) {
                    return "#0070BB"; // Warn
                } else if (model.level === 4) {
                    return "#FF6B68"; // Error
                } else if (model.level === 5) {
                    return "#FF0006"; // Fatal
                } else {
                    return "#FFFFFF" // Normal
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
            DataServiceHub.setAutoScroll(true);
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

        enabled: !DataServiceHub.autoScroll

        onClicked: {
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
