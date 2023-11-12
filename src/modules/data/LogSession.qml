import QtQuick
import src.modules.data 1.0

Item {
    id: r

    visible: false

    property string name: ""

    // status
    property bool loaded: false

    // log view params
    property string logPath: ""

    property int logLevel: 0 // 0 - 6

    property var logRegexMap: undefined

    property string filter: ""

    property var filterRegExp: new RegExp("")

    property int clipLine: 0

    // log model
    property var logModel: logWatcherService.logData

    // config
    property var config: DataServiceHub.config.value

    // view
    property bool enableAutoScroll: true
    property bool autoScroll: true


    // start/stop
    signal startSucceeded()
    signal startFailed()

    function startWatch() {
        p.startCbHolder = startCbComponent.createObject()
        logWatcherService.startWork(logPath, p.startCbHolder, filter, logLevel, logRegexMap, clipLine)
    }

    function stopWatch() {
        logWatcherService.stopWork()
        loaded = false
    }

    // set auto scroll
    function setAutoScroll(b) {
        autoScroll = b
    }

    // set log file
    function extractFilePath(url) {
        var urlString = url.toString();
        var filePrefix = "file:///";
        if (urlString.indexOf(filePrefix) === 0) {
            return urlString.substring(filePrefix.length)
        }
        return urlString
    }

    function urlsAreEqual(url1, url2) {
        var absPath1 = extractFilePath(url1)
        var absPath2 = extractFilePath(url2)
        return absPath1 === absPath2
    }

    function setLogFile(file) {
        if (urlsAreEqual(file, logPath)) {
            return;
        }

        console.info("set log file: " + file)
        logPath = extractFilePath(file)
        logLevel = 0
        filter = ""
        clipLine = 0
        autoScroll = true

        stopWatch();
        restartTimer.start()
    }


    // set log logLevel
    function setLogLevel(level) {
        if (isNaN(level)) {
            console.error("setLogLevel: level '" + "' is not a number.")
            return
        } else if (level < 0 || level > 6) {
            console.error("setLogLevel: invalid level: " + level)
            return
        }

        if (level === logLevel) {
            return
        }

        logLevel = level
        stopWatch()
        restartTimer.start()
    }

    // set filter
    function setFilter(text) {
        if (text === filter) {
            return
        }

        filter = text
        var regexStr = filter.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        filterRegExp = new RegExp(regexStr, 'gi')

        stopWatch()
        restartTimer.start()
    }

    // set clip line
    function setClipLine(line) {
        if (line < 0) {
            return
        }

        if (line === clipLine) {
            return
        }

        clipLine = line
        stopWatch()
        restartTimer.start()
    }

    // load front block
    function loadFrontBlock() {
        p.loadFrontCbHolder = loadFrontCbComponent.createObject()
        logWatcherService.loadFrontBlock(p.loadFrontCbHolder)
    }

    Component.onCompleted: {
        applyConfig()
    }

    Component.onDestruction: {
        console.info("Session with name '" + name + "' has been destroyed.")
    }

    QtObject {
        id: p

        property var startCbHolder: undefined
        property var loadFrontCbHolder: undefined
        property LogWatcherService logWatcherService: LogWatcherService {
            id: logWatcherService
        }

        property Timer restartTimer: Timer {
            id: restartTimer
            interval: 0
            running: false
            triggeredOnStart: false
            repeat: false

            onTriggered: {
                r.startWatch()
            }
        }
    }

    Component {
        id: startCbComponent
        StartCallableObject {
            onSuccessed: {
                startSucceeded()
                loaded = true
                loadFrontBlock()
            }
            onFailed: {
                startFailed()
            }
        }
    }

    Component {
        id: loadFrontCbComponent
        LoadFrontBlockCallableObject {
            onSuccessed: {
                loadFrontBlock()
            }
            onFailed: {

            }
        }
    }

    function applyConfig() {
        config =  DataServiceHub.config.value
        if (config == null)
            return

        logRegexMap = {
            "trace" : config.levels.trace.regex,
            "debug" : config.levels.debug.regex,
            "info" : config.levels.info.regex,
            "warn" : config.levels.warn.regex,
            "error" : config.levels.error.regex,
            "fatal" : config.levels.fatal.regex,
        }
    }

    Connections {
        target: DataServiceHub.config

        function onConfigChanged() {
            applyConfig()
        }
    }
}
