import QtQuick
import QtQuick.Controls.Basic
import src.modules.components 1.0

Pane {
    visible: true
    background: Rectangle {
        color: "transparent"
    }

    width: 400
    height: 300

    padding: 0

    contentItem: Item {
        Image {
            id: appNameImage
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            source: "qrc:/images/log-pilot.svg"
            fillMode: Image.Pad
        }

        DefaultTextButton {
            id: qtLicenseBtn
            anchors {
                top: appNameImage.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            color: "#C0C0C0"
            textItem.font.family: "Inter"
            textItem.font.pixelSize: 10
            textItem.text: "Powered by Qt 6.5.2"
            width: textItem.contentWidth
            height: textItem.contentHeight
        }

        Text {
            id: copyRightText
            anchors {
                top: qtLicenseBtn.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "Copyright ©2023 Huang Wei | 黄微"
            color: "#E0E0E0"
        }

        Text {
            id: emailText
            anchors {
                top: copyRightText.bottom
                topMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "1845739048@qq.com"
            color: "#E0E0E0"
        }

        Text {
            id: versionText
            anchors {
                top: emailText.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "VERSION: " + Qt.application.version
            color: "#C0C0C0"
        }

        Text {
            id: buildTimeText
            anchors {
                top: versionText.bottom
                topMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "BUILD TIME: " + BuildDate + " " + BuildTime
            color: "#C0C0C0"
        }

        Text {
            id: licenseText1
            anchors {
                top: buildTimeText.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "This software is licensed under the MIT License."
            color: "#C0C0C0"
        }

        Text {
            id: licenseText2
            anchors {
                top: licenseText1.bottom
                topMargin: 2
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "For details,  see the LICENSE file in the project repository."
            color: "#C0C0C0"
        }

        Text {
            id: repoText
            anchors {
                top: licenseText2.bottom
                topMargin: 2
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Sansation"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "Repo: https://github.com/SSSSSolution/LogPilot"
            color: "#C0C0C0"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Qt.openUrlExternally("https://github.com/SSSSSolution/LogPilot")
                }
            }
        }

        Text {
            id: welcomeText
            anchors {
                top: repoText.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            font.family: "Josefin Slab"
            font.pixelSize: 16
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: contentWidth
            height: contentHeight

            text: "Thank you for using Log Pilot."
            color: "#E48832"
        }

    }
}
