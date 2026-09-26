import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: app
    visible: true
    visibility: Window.FullScreen
    width: 1920
    height: 1080
    title: "CASTLE"

    readonly property color brightBlue: "#087BEE"
    readonly property color darkText: "#142033"

    StackView {
        id: pages
        anchors.fill: parent
        initialItem: startupPage
    }

    component BlueButton: Button {
        font.pixelSize: 32
        font.bold: true
        Layout.fillWidth: true
        Layout.preferredHeight: 110

        background: Rectangle {
            color: brightBlue
            radius: 18
        }

        contentItem: Text {
            text: parent.text
            color: "white"
            font: parent.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    component BackButton: Button {
        text: "← Back"
        font.pixelSize: 24
        width: 135
        height: 60

        background: Rectangle {
            color: "#E8F2FF"
            radius: 12
        }

        contentItem: Text {
            text: parent.text
            color: darkText
            font: parent.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Component {
        id: startupPage

        Rectangle {
            color: "white"

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 760)
                spacing: 28

                Label {
                    text: "Projector and camera calibration"
                    color: darkText
                    font.pixelSize: 46
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Label {
                    text: "Calibrate the system before starting a lesson."
                    color: "#425466"
                    font.pixelSize: 25
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                BlueButton {
                    text: "Start calibration"
                    onClicked: pages.replace(activeCalibrationPage)
                }
                //remove when we have real calibration setup
                BlueButton {
                    text: "Skip for testing"
                    onClicked: pages.replace(homePage)
                }
            }
        }
    }

    Component {
        id: activeCalibrationPage

        Rectangle {
            color: "white"

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 760)
                spacing: 28

                Label {
                    text: "Calibration"
                    color: darkText
                    font.pixelSize: 48
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Label {
                    text: "Set up the projector and camera."
                    color: "#425466"
                    font.pixelSize: 25
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                BlueButton {
                    text: "Start calibration"

                    onClicked: {
                        // TODO: Call the real calibration function here:
                        // calibrationController.beginCalibration() for opencv

                        calibrationStatus.text =
                                "Calibration hardware is not connected yet."
                    }
                }

                Label {
                    id: calibrationStatus
                    text: ""
                    color: "#425466"
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component {
        id: homePage

        Rectangle {
            color: "white"

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 700)
                spacing: 24

                Label {
                    text: "CASTLE"
                    color: darkText
                    font.pixelSize: 56
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    Layout.bottomMargin: 20
                }

                BlueButton {
                    text: "Lessons"
                    Layout.preferredHeight: 150
                    onClicked: pages.push(lessonsPage)
                }

                BlueButton {
                    text: "Help"
                    Layout.preferredHeight: 150
                    onClicked: pages.push(helpPage)
                }

                BlueButton {
                    text: "Recalibrate"
                    Layout.preferredHeight: 150
                    onClicked: pages.push(recalibrationPage)
                }
            }
        }
    }

    Component {
        id: recalibrationPage

        Rectangle {
            color: "white"

            BackButton {
                x: 35
                y: 35
                onClicked: pages.pop()
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 700)
                spacing: 28

                Label {
                    text: "Recalibration"
                    color: darkText
                    font.pixelSize: 48
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                BlueButton {
                    text: "Test"

                    onClicked: {
                        recalibrationStatus.text =
                                "Camera and projector test is not connected yet."
                    }
                }

                BlueButton {
                    text: "Recalibrate"
                    onClicked: pages.replace(activeCalibrationPage)
                }

                Label {
                    id: recalibrationStatus
                    text: ""
                    color: "#425466"
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component {
        id: lessonsPage

        Rectangle {
            color: "white"

            BackButton {
                x: 35
                y: 35
                onClicked: pages.pop()
            }

            Label {
                anchors.centerIn: parent
                text: "Lessons"
                color: darkText
                font.pixelSize: 52
            }
        }
    }

    Component {
        id: helpPage

        Rectangle {
            color: "white"

            BackButton {
                x: 35
                y: 35
                onClicked: pages.pop()
            }

            Column {
                anchors.centerIn: parent
                spacing: 25

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Help"
                    color: darkText
                    font.pixelSize: 52
                }

                Label {
                    text: "refer to the github readme help section"
                    color: "#425466"
                    font.pixelSize: 28
                }
            }
        }
    }
}