import QtQuick 2.15
import "../Base"
import "../Theme"

Item {
    id: root

    property string text: "ToggleTextButton"

    // 文本参数
    property bool fontBold: true
    property int fontPointSize: 22
    property string fontFamily: WishesTheme.fontFamily

    // 颜色参数
    property color colorNormal: WishesTheme.current.buttonColor
    property color colorHovered: WishesTheme.current.hoveredColor
    property color colorToggled: WishesTheme.current.toggledColor
    property real bgOpacity: 1

    property color textColorCommon: WishesTheme.current.textColor
    property color textColorHovered: textColorCommon
    property color textColorToggled: WishesTheme.current.textActiveColor

    property real scaleCommon: 1.0
    property real scaleHovered: 1.0
    property real scaleToggled: 1.0

    property int stateSwitchDuration: 100

    property bool uncheckable: false

    property bool isToggled: false

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    // 禁用
    // enabled
    property bool enabledAnimationUsable: true

    signal toggled()
    signal unchecked()
    signal uncheckedByMouse()

    state: "common"
    states: [
        State {
            name: "toggled"
            PropertyChanges {
                target: bg
                color: root.colorToggled
                scale: root.scaleToggled
            }

            PropertyChanges {
                target: btnText
                color: root.textColorToggled
            }
        },
        State {
            name: "common"
            PropertyChanges {
                target: bg
                color: root.colorNormal
                scale: root.scaleCommon
            }

            PropertyChanges {
                target: btnText
                color: root.textColorCommon
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: bg
                color: root.colorHovered
                scale: root.scaleHovered
            }

            PropertyChanges {
                target: btnText
                color: root.textColorHovered
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "toggled"
            ParallelAnimation {
                ColorAnimation {
                    target: btnText
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }

                ScaleAnimator {
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "*"
            to: "common"
            ParallelAnimation {
                ColorAnimation {
                    target: btnText
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }

                ScaleAnimator {
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "*"
            to: "hovered"
            ParallelAnimation {
                ColorAnimation {
                    target: btnText
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }

                ScaleAnimator {
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]

    WRectangle {
        id: bg
        anchors.fill: root
        color: root.colorNormal
        colorSwitchDuration: root.stateSwitchDuration
        cornersRadius: root.cornersRadius
        opacity: root.bgOpacity
    }

    Text {
        id: btnText
        anchors.fill: root
        text: root.text
        color: root.textColorCommon
        font {
            family: root.fontFamily
            pixelSize: root.fontPointSize
            bold: root.fontBold
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton

        onClicked: {
            if (!root.isToggled) {
                parent.isToggled = true
                parent.state = "toggled"
                root.toggled()
            } else if (root.uncheckable) {
                parent.isToggled = false
                parent.state = "hovered"
                root.uncheckedByMouse()
                root.unchecked()
            }
        }

        onEntered: {
            if (!parent.isToggled) {
                parent.state = "hovered"
            }
        }

        onExited: {
            if (!parent.isToggled) {
                parent.state = "common"
            }
        }
    }

    // 禁用功能
    WRectangle {
        id: unenabledOverlayRect
        visible: false
        anchors.fill: parent
        cornersRadius: parent.cornersRadius

        color: "black"
        opacity: 0.0
    }

    NumberAnimation {
        id: overlayToUnenabledAnimation
        target: unenabledOverlayRect
        property: "opacity"
        to: 0.3
        duration: root.stateSwitchDuration
        easing.type: Easing.InOutQuad

        onStarted: {
            unenabledOverlayRect.visible = true
        }
    }

    NumberAnimation {
        id: overlayToEnabledAnimation
        target: unenabledOverlayRect
        property: "opacity"
        to: 0.0
        duration: root.stateSwitchDuration
        easing.type: Easing.InOutQuad

        onFinished: {
            unenabledOverlayRect.visible = false
        }
    }

    onEnabledChanged: {
        if (enabledAnimationUsable) {
            if (enabled) {
                overlayToUnenabledAnimation.stop()
                overlayToEnabledAnimation.restart()
            } else {
                overlayToEnabledAnimation.stop()
                overlayToUnenabledAnimation.restart()
            }
        }
    }

    function toggle() {
        isToggled = true
        state = "toggled"
        toggled()
    }

    function uncheck() {
        isToggled = false
        state = "common"
        unchecked()
    }
}

