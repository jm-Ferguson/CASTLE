

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import CASTLEui
import QtQuick.Studio.DesignEffects
import QtQuick3D.Effects

Rectangle {
    id: background
    width: Constants.width
    height: Constants.height
    z: -1
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#081b2b"
        }

        GradientStop {
            position: 0.49561
            color: "#102d43"
        }

        GradientStop {
            position: 1
            color: "#071827"
        }

        orientation: Gradient.Vertical
    }

    Text {
        id: header
        x: 447
        y: 26
        width: 388
        height: 124
        color: "#ffffff"
        text: qsTr("CASTLE")
        font.pixelSize: 100
        font.styleName: "Bold"
        font.family: "Nunito"

        DesignEffect {
            effects: [
                DesignDropShadow {
                    color: "#a073b9ff"
                    offsetY: 0
                    blur: 25
                    showBehind: false
                    offsetX: 0
                }
            ]
        }
    }

    Grid {
        id: grid
        x: 264
        y: 200
        width: 753
        height: 321
        topPadding: 0
        spacing: 30
        columns: 2
        rows: 2

        Button {
            id: button
            width: 360
            height: 146
            text: qsTr("Lessons")
            icon.color: "#eef6ff"
            palette.buttonText: "#ffffff"
            layer.smooth: false
            checked: false
            highlighted: false
            flat: false
            font.pointSize: 30
            font.styleName: "SemiBold"
            font.family: "Nunito"
            hoverEnabled: true

            scale: down ? 0.975 : (hovered ? 1.025 : 1.0)

            background: Rectangle {
                radius: 28
                border.width: 3

                color: button.down ? "#99464580" : button.hovered ? "#883B3D70" : "#66282B50"

                border.color: button.down ? "#E5DFFF" : button.hovered ? "#C7BDFF" : "#A195F5"
            }
        }

        Button {
            id: button1
            width: 360
            height: 146
            text: qsTr("Button")
            font.styleName: "SemiBold"
            font.bold: false
            font.pointSize: 30
            palette.buttonText: "#ffffff"
            font.family: "Nunito"
            hoverEnabled: true

            // Slightly enlarge when hovered
            scale: down ? 0.975 : (hovered ? 1.025 : 1.0)

            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            background: Rectangle {
                radius: 28
                border.width: 3

                color: button1.down ? "#9932776F" : button1.hovered ? "#8824525A" : "#66103B42"

                border.color: button1.down ? "#BCFFF0" : button1.hovered ? "#72FCE0" : "#3DBFA8"

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }
        }

        Button {
            id: button2
            width: 360
            height: 146
            text: qsTr("Button")
            font.styleName: "SemiBold"
            font.pointSize: 30
            palette.buttonText: "#ffffff"
            font.family: "Nunito"
            hoverEnabled: true

            scale: down ? 0.975 : (hovered ? 1.025 : 1.0)

            background: Rectangle {
                radius: 28
                border.width: 3

                color: button2.down ? "#99336D8C" : button2.hovered ? "#88214F70" : "#66103650"

                border.color: button2.down ? "#D4F4FF" : button2.hovered ? "#91E0FF" : "#55C5F5"
            }
        }

        Button {
            id: button3
            width: 360
            height: 146
            text: qsTr("Button")
            font.styleName: "SemiBold"
            palette.buttonText: "#ffffff"
            font.pointSize: 30
            font.family: "Nunito"

            hoverEnabled: true

            scale: down ? 0.975 : (hovered ? 1.025 : 1.0)

            background: Rectangle {
                radius: 28
                border.width: 3

                color: button3.down ? "#99756835" : button3.hovered ? "#88544D35" : "#66363831"

                border.color: button3.down ? "#FFF2CD" : button3.hovered ? "#FFE39D" : "#F6C968"
            }
        }
    }

    states: [
        State {
            name: "clicked"
        }
    ]
}
