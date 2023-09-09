pragma Singleton

import QtQuick
import src.modules.data 1.0

Item {
    id: hub
    property string name: "Singleton"


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

    function startWatch(path, filter) {
        var startCbObj = startCallback.createObject()
        logWatcherService.startWork(path, startCbObj, filter);
    }

    function stopWatch() {
        logWatcherService.stopWork();
    }

    function setFilter(regexp) {
        logWatcherService.setFilter(regexp);
    }

    function unsetFilter(regexp) {
        logWatcherService.unsetFilter()
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
        var regexArray = ["^Trace", "^Debug", "^Info",
                          "^Warn", "^Error", "^Fatal"];
        logWatcherService.setLogLevelRegex(regexArray);
    }
}
