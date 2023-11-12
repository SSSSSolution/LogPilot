import QtQuick
import QtQuick.Controls.Basic

import src.modules.components 1.0
import src.modules.data 1.0

Rectangle {
    id: r

    color: "#5A5A5A"
    border {
        color: "#9B9B9B"
        width: 1
    }
    radius: 10

    property string noneColor: "FFFFFF"
    property string traceColor: "FFFFFF"
    property string debugColor: "FFFFFF"
    property string infoColor: "FFFFFF"
    property string warnColor: "FFFFFF"
    property string errorColor: "FFFFFF"
    property string fatalColor: "FFFFFF"

    function getColorCfg() {
        if (!noneInput.inputValid) {
            return { error: "Invalid None level color.", config: null}
        }

        if (!traceInput.inputValid) {
            return { error: "Invalid Trace level color.", config: null}
        }

        if (!debugInput.inputValid) {
            return { error: "Invalid Debug level color.", config: null}
        }

        if (!infoInput.inputValid) {
            return { error: "Invalid Info level color.", config: null}
        }

        if (!warnInput.inputValid) {
            return { error: "Invalid Warn level color.", config: null}
        }

        if (!errorInput.inputValid) {
            return { error: "Invalid Error level color.", config: null}
        }

        if (!fatalInput.inputValid) {
            return { error: "Invalid Fatal level color.", config: null}
        }

        var cfg = {
            "none": "#" + noneColor,
            "trace": "#" + traceColor,
            "debug": "#" + debugColor,
            "info": "#" + infoColor,
            "warn": "#" + warnColor,
            "error": "#" + errorColor,
            "fatal": "#" + fatalColor,
        }
        return { error: null, config: cfg}
    }

    ColorGradientPanel {
        id: colorGradientPanel
        anchors {
            top: parent.top
            topMargin: 15
            right: parent.right
            rightMargin: 15
        }
        width: 250
        height: 250

        huePosition: hueSlider.huePosition

        onSelectedColorChanged: {
            var color = colorToRgbString(selectedColor)
            if (noneInput.focus === true) {
                noneColor = color
            } else if (traceInput.focus === true) {
                traceColor = color
            } else if (debugInput.focus === true) {
                debugColor = color
            } else if (infoInput.focus === true) {
                infoColor = color
            } else if (warnInput.focus === true) {
                warnColor = color
            } else if (errorInput.focus === true) {
                errorColor = color
            } else if (fatalInput.focus === true) {
                fatalColor = color
            }
        }
    }

    HueSlider {
        id: hueSlider
        anchors {
            top: colorGradientPanel.bottom
            topMargin: 20
            left: colorGradientPanel.left
            right: colorGradientPanel.right
        }
        width: 250
        height: 6
    }

    function colorToRgbString(color) {
        var r = Math.round(color.r * 255).toString(16).toUpperCase();
        var g = Math.round(color.g * 255).toString(16).toUpperCase();
        var b = Math.round(color.b * 255).toString(16).toUpperCase();

        if (r.length == 1) r = "0" + r;
        if (g.length == 1) g = "0" + g;
        if (b.length == 1) b = "0" + b;

        return r + g + b;
    }

    function isHexRGB(str) {
        var regex = /^([A-Fa-f0-9]{6})$/;
        return regex.test(str);
    }

    function rgbToHsv(r, g, b) {
        let max = Math.max(r, g, b), min = Math.min(r, g, b)
        let h, s, v = max

        let d = max - min
        s = max === 0 ? 0: d / max

        if (max === min) {
            h = 0
        } else {
            switch (max) {
                case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                case g: h = (b - r) / d + 2; break;
                case b: h = (r - g) / d + 4; break;
            }
            h /= 6;
        }

        return [h, s, v]
    }

    function setColorPickerPosition(colorStr) {
        if (isHexRGB(colorStr)) {
            let selectedColorStr = colorToRgbString(colorGradientPanel.selectedColor)
            if (selectedColorStr === colorStr)
                return;

            let color = Qt.color("#" + colorStr)

            let hsv = rgbToHsv(color.r, color.g, color.b)
            let hue = hsv[0]
            let saturation = hsv[1]
            let value = hsv[2]

            hueSlider.setHuePosition(hue)
            colorGradientPanel.setSelectionIndicator(saturation * colorGradientPanel.width,
                                                     (1-value) * colorGradientPanel.height)

        }
    }

    TextInputWithLabel {
        id: noneInput
        anchors {
            top: parent.top
            topMargin: 15
            left: parent.left
            leftMargin: 10
        }

        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "None"
        labelItem.color: "#" + noneColor
        textInputItem.text: noneColor
        textInputItem.color: "#" + noneColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    TextInputWithLabel {
        id: traceInput
        anchors {
            top: noneInput.top
            left: noneInput.right
            leftMargin: 20
        }

        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "Trace"
        labelItem.color: "#" + traceColor
        textInputItem.text: traceColor
        textInputItem.color: "#" + traceColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    TextInputWithLabel {
        id: debugInput
        anchors {
            top: noneInput.bottom
            topMargin: 8
            left: parent.left
            leftMargin: 10
        }
        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "Debug"
        labelItem.color: "#" + debugColor
        textInputItem.text: debugColor
        textInputItem.color: "#" + debugColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    TextInputWithLabel {
        id: infoInput
        anchors {
            top: debugInput.top
            left: debugInput.right
            leftMargin: 20
        }
        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "Info"
        labelItem.color: "#" + infoColor
        textInputItem.text: infoColor
        textInputItem.color: "#" + infoColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    TextInputWithLabel {
        id: warnInput
        anchors {
            top: debugInput.bottom
            topMargin: 8
            left: parent.left
            leftMargin: 10
        }
        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "Warn"
        labelItem.color: "#" + warnColor
        textInputItem.text: warnColor
        textInputItem.color: "#" + warnColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    TextInputWithLabel {
        id: errorInput
        anchors {
            top: warnInput.top
            left: warnInput.right
            leftMargin: 20
        }
        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "Error"
        labelItem.color: "#" + errorColor
        textInputItem.text: errorColor
        textInputItem.color: "#" + errorColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    TextInputWithLabel {
        id: fatalInput
        anchors {
            top: warnInput.bottom
            topMargin: 8
            left: parent.left
            leftMargin: 10
        }
        height: 20
        width: 130

        labelItem.width: 50
        labelItem.text: "Fatal"
        labelItem.color: "#" + fatalColor
        textInputItem.text: fatalColor
        textInputItem.color: "#" + fatalColor
        labelItem.font.pixelSize: 13
        textInputItem.font.pixelSize: 13

        inputValid: {
            return isHexRGB(textInputItem.text)
        }

        textInputItem.onTextChanged: {
            setColorPickerPosition(textInputItem.text)
        }

        onFocusChanged: {
            if (focus === true) {
                setColorPickerPosition(textInputItem.text)
            }
        }
    }

    Rectangle {
        anchors {
            left: fatalInput.left
            right: errorInput.right
            top: fatalInput.bottom
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 15
        }
        color: "#2C2C2C"
        border.width: 2
        border.color: "#756E6E"
        radius: 5

        LogsView {
            id: logsView
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 5
            anchors.bottomMargin: 5

            focusPolicy: Qt.NoFocus


            ListModel {
                id: logModel
                ListElement {
                    msg: "This is a none level log message."
                    level: 0
                    line: 0
                }
                ListElement {
                    msg: "This is a trace level log message."
                    level: 1
                    line: 1
                }
                ListElement {
                    msg: "This is a debug level log message."
                    level: 2
                    line: 2
                }
                ListElement {
                    msg: "This is a info level log message."
                    level: 3
                    line: 3
                }
                ListElement {
                    msg: "This is a warn level log message."
                    level: 4
                    line: 4
                }
                ListElement {
                    msg: "This is a error level log message."
                    level: 5
                    line: 5
                }
                ListElement {
                    msg: "This is a fatal level log message."
                    level: 6
                    line: 6
                }
            }

            Component.onCompleted: {
                DataServiceHub.createSession("example")
                session = DataServiceHub.getSession("example")
                session.enableAutoScroll = false
                session.logModel = logModel
                session.config = Qt.binding(function() {
                    let cfg = {
                        levels: {
                            none: {
                                color: "#FFFFFF"
                            },
                            trace: {
                                color: "#FFFFFF"
                            },
                            debug: {
                                color: "#FFFFFF"
                            },
                            info: {
                                color: "#FFFFFF"
                            },
                            warn: {
                                color: "#FFFFFF"
                            },
                            error: {
                                color: "#FFFFFF"
                            },
                            fatal: {
                                color: "#FFFFFF"
                            },
                        }
                    }
                    cfg.levels.none.color = "#" + r.noneColor
                    cfg.levels.trace.color = "#" + r.traceColor
                    cfg.levels.debug.color = "#" + r.debugColor
                    cfg.levels.info.color = "#" + r.infoColor
                    cfg.levels.warn.color = "#" + r.warnColor
                    cfg.levels.error.color = "#" + r.errorColor
                    cfg.levels.fatal.color = "#" + r.fatalColor
                    return cfg
                })
            }

            Component.onDestruction: {
                DataServiceHub.removeSession("example")
            }
        }
    }

    Component.onCompleted: {
        var levelsCfg = DataServiceHub.config.value.levels
        noneColor = levelsCfg.none.color.slice(1).toUpperCase()
        traceColor = levelsCfg.trace.color.slice(1).toUpperCase()
        debugColor = levelsCfg.debug.color.slice(1).toUpperCase()
        infoColor = levelsCfg.info.color.slice(1).toUpperCase()
        warnColor = levelsCfg.warn.color.slice(1).toUpperCase()
        errorColor = levelsCfg.error.color.slice(1).toUpperCase()
        fatalColor = levelsCfg.fatal.color.slice(1).toUpperCase()

        noneInput.focus = true
    }

}
