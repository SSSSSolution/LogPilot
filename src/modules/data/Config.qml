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

        if (!fileIO.write(AppConfigDir+"/config.json", JSON.stringify(p.config, null, 4))) {
            console.error("Failed to save config: Failed to write config file.")
            return false
        }
        return true
    }

    function setColor(colorCfg) {
        p.config.levels.none.color = colorCfg.none
        p.config.levels.trace.color = colorCfg.trace
        p.config.levels.debug.color = colorCfg.debug
        p.config.levels.info.color = colorCfg.info
        p.config.levels.warn.color = colorCfg.warn
        p.config.levels.error.color = colorCfg.error
        p.config.levels.fatal.color = colorCfg.fatal
    }

    function setRegex(regexColor) {
        p.config.levels.trace.regex = regexColor.trace.regex
        p.config.levels.debug.regex = regexColor.debug.regex
        p.config.levels.info.regex  = regexColor.info.regex
        p.config.levels.warn.regex  = regexColor.warn.regex
        p.config.levels.error.regex = regexColor.error.regex
        p.config.levels.fatal.regex = regexColor.fatal.regex

        p.config.levels.trace.matchTest = regexColor.trace.matchTest
        p.config.levels.debug.matchTest = regexColor.debug.matchTest
        p.config.levels.info.matchTest  = regexColor.info.matchTest
        p.config.levels.warn.matchTest  = regexColor.warn.matchTest
        p.config.levels.error.matchTest = regexColor.error.matchTest
        p.config.levels.fatal.matchTest = regexColor.fatal.matchTest
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
