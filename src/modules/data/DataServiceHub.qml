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
    property var defaultConfig: undefined
    readonly property alias configs: p.configs

    function createConfig(name) {
        // check
        return true
    }

    function addConfig(path) {

    }

    function removeConfig(name) {

    }

    function getConfig(name) {

    }

    // log configs
    property LogConfigModel logConfigModel: LogConfigModel {
        id: logConfigModel
    }

    QtObject {
        id: p
        property var sessions: []
        property var configs: []
    }

    FileIO {
        id: fileIO
    }

    Component.onCompleted: {
        // load config
        try {
            defaultConfig = JSON.parse(fileIO.read(":/configs/LogPilotConfig.json"))
            defaultConfig.name = "build-in"
        } catch (error) {
            console.error("Load default config failed: ", error.message)
        }

        if (defaultConfig == null) {
            console.error("Failed to load default config")
            Qt.exit(-1)
        }

        p.configs.push(defaultConfig)
        var cfg1 = {};
        cfg1.name = "test confg 1"
        var cfg2 = {};
        cfg2.name = "test confg 2"
        var cfg3 = {};
        cfg3.name = "test confg 3"
        p.configs.push(cfg1)
        p.configs.push(cfg2)
        p.configs.push(cfg3)
        p.configs.push(cfg1)
        p.configs.push(cfg2)
        p.configs.push(cfg3)
        p.configs.push(cfg1)
        p.configs.push(cfg2)
        p.configs.push(cfg3)
        p.configs.push(cfg1)
        p.configs.push(cfg2)
        p.configs.push(cfg3)
    }
}

