pragma Singleton

import QtQuick
import src.modules.data 1.0

Item {
    id: hub
    property string name: "Singleton"

    property bool autoScroll: true
    function setAutoScroll(isAuto) {
        autoScroll = isAuto;
    }

    // Log file
    property string curLogFile: ""

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

    function setLogFile(logFile) {
        if (urlsAreEqual(logFile, curLogFile)) {
            return;
        }

        curLogFile = extractFilePath(logFile)
        logLevel = 0
        filter = ""

        stopWatch();
        restartTimer.start();
    }

    // Log Level
    property var logRegexMap: null
    property int logLevel: 0 // 0 ~ 5
    function setLogLevel(level) {
        if (isNaN(level)) {
            console.warn("Input log level ", level , " is not a number.");
        } else if (level <= -1 || level > 5){
            console.warn("Invalid log level: ", level);
            return;
        }

        if (level === logLevel)
            return;

        logLevel = level;
        stopWatch();
        restartTimer.start();
    }

    // filter
    property string filter: ""
    property var filterRegExp: new RegExp("")
    function setFilter(text) {
        if (text === filter) {
            return;
        }
        filter = text;
        DataServiceHub.stopWatch();
        restartTimer.start()
    }

    Timer {
        id: restartTimer
        interval: 0
        running: false
        triggeredOnStart:  false
        repeat: false

        onTriggered: {
            // reset filter regex
            var regexStr = filter.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            filterRegExp = new RegExp(regexStr, 'gi')

            hub.startWatch(curLogFile)
            hub.setAutoScroll(true);
        }
    }


    signal started()

    Component {
        id: startCallback
        StartCallableObject {
            onSuccessed: {
                console.log("start success");
                DataServiceHub.loadFrontBlock()
            }
            onFailed: {
            }
        }
    }

    function startWatch(path) {
        var startCbObj = startCallback.createObject()
        logWatcherService.startWork(path, startCbObj, filter, logLevel, logRegexMap);
    }

    function stopWatch() {
        logWatcherService.stopWork();
    }

    property bool frontBlockLoading: false
    property LoadFrontBlockCallableObject loadFrontBlockCbObj: null

    Component {
        id: loadFrontBlockCallback
        LoadFrontBlockCallableObject {
            onSuccessed: {
                DataServiceHub.loadFrontBlock()
            }
            onFailed: {
                console.log("load front stopped");
                loadedFrontBlockFailed()
            }
        }
    }

    signal loadedFrontBlock(int logsCount)
    signal loadedFrontBlockFailed()

    function loadFrontBlock() {
        var cbObj = loadFrontBlockCallback.createObject();
        if (cbObj !== null) {
            loadFrontBlockCbObj = cbObj;
            logWatcherService.loadFrontBlock(loadFrontBlockCbObj)
        } else {
            console.log("load front stopped due to null obj");
            loadedFrontBlockFailed();
        }
    }

    property LogWatcherService logWatcherService: LogWatcherService {
        id: logWatcherService
    }

    Component.onCompleted: {
        logRegexMap = {
            "trace" : "\\[Trace",
            "debug" : "\\[Debug",
            "info" : "\\[Info",
            "warn" : "\\[Warn",
            "error" : "\\[Error",
            "fatal" : "\\[Fatal",
        }
    }
}




























