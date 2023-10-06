import QtQuick
import QtQuick.Controls.Basic

import src.modules.data 1.0
import src.modules.views 1.0

Item {
    id: r

    property string sessionName: "test1"
    property var session: undefined

    TitleBar {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 35
        session: r.session
    }

    Rectangle {
        anchors {
            top:titleBar.bottom
            bottom: bottomBar.top
            left: parent.left
            right: parent.right
        }

        Rectangle {
            id: leftRect
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: 10
            color: "black"
        }

        Rectangle {
            id: rightRect
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: 10
            color: "black"
        }


        LogsView {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: leftRect.right
                right: rightRect.left
            }
            session: r.session
        }
    }

    BottomBar {
        id: bottomBar
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: 40
        session: r.session
    }

    Component.onCompleted: {
        DataServiceHub.createSession(sessionName)
        session = DataServiceHub.getSession(sessionName)
    }

    Component.onDestruction: {
        DataServiceHub.removeSession(sessionName)
    }
}
