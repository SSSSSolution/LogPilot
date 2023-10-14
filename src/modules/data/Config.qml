import QtQuick
import src.modules.data 1.0

Item {
    id: r

    signal configLoaded();
    signal configChanged();

    readonly property var value: p.config

    function save() {
        if (AppConfigDir === "") {
            console.log("Failed to save config: AppConfigDir is empty.")
            return false;
        }

        if (!fileIO.write(AppConfigDir+"config.json", JSON.stringify(p.config, null, 4))) {
            console.error("Failed to save config: Failed to write config file.")
            return false
        }
        return true
    }


    QtObject {
        id: p
        property var config: undefined

        function loadConfig() {
            if (loadUserConfig()) {
                return
            }

            if (loadBuildInConfig()) {
                return
            }

            console.error("Failed to load config.")
            Qt.exit(-1)
        }

        function loadBuildInConfig() {
            var content = fileIO.read(":/configs/LogPilotConfig.json")
            if (content == "") {
                return false;
            }
            try {
                config = JSON.parse(content)
            } catch (error) {
                return false;
            }

            return true
        }

        function loadUserConfig() {
            var content = fileIO.read(AppConfigDir + "/config.json")
            if (content === "") {
                return false;
            }
            try {
                config = JSON.parse(content)
            } catch (error) {
                return false;
            }

            return true;
        }
    }

    FileIO {
        id: fileIO
    }

    Component.onCompleted: {
        p.loadConfig()
        configLoaded()
    }
}
