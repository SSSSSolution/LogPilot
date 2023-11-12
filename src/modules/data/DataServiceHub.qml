pragma Singleton

import QtQuick
import src.modules.data 1.0

Item {
    id: hub
    property string name: "Singleton"

    // View
    property bool mainWindowNeedBlur: false

    // session
    function createSession(sessionName) {
        for (var i = 0; i < p.sessions.length; i++) {
            if (p.sessions[i].name === sessionName) {
                console.error("createSession: session with the name '" +
                              sessionName + "' already exist.")
                return
            }
        }

        var sessionComponent = Qt.createComponent("LogSession.qml");
        if (sessionComponent.status === Component.Ready) {
            var session = sessionComponent.createObject(hub);
            if (session) {
                session.name = sessionName;
                p.sessions.push(session);
            } else {
                console.error("Failed to create session object.");
            }
        } else if (sessionComponent.status === Component.Error) {
            console.error("Error loading session component:", sessionComponent.errorString());
        }
    }

    function removeSession(sessionName) {
        for (var i = 0; i < p.sessions.length; i++) {
            if (p.sessions[i].name === sessionName) {
                p.sessions[i].destroy()
                p.sessions.splice(i, 1)
                return
            }
        }
        console.warn("RemoveSession: session with the name '" +
                     sessionName + "' not found.")
    }

    function getSession(sessionName) {
        for (var i = 0; i < p.sessions.length; i++) {
            if (p.sessions[i].name === sessionName) {
                return p.sessions[i]
            }
        }
        return null
    }

    // config
    property Config config: Config {
        id: config
    }

    function testRegexMatch(str, regexStr) {
        return logWatcherService.testRegexMatch(str, regexStr)
    }

    QtObject {
        id: p
        property var sessions: []
    }

    LogWatcherService {
        id: logWatcherService
    }

    FileIO {
        id: fileIO
    }

    Component.onCompleted: {
    }
}

