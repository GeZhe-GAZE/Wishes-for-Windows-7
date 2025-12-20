import QtQuick 2.15
import "../Theme"
import "../Base"

Item {
    id: root

    readonly property alias background: background

    property real canvasWidth: width * 0.7
    property real canvasHeight: height * 0.7

    // 背景颜色
    property color colorNormal: WishesTheme.current.buttonColor
    property color colorHovered: WishesTheme.current.hoveredColor
    property color colorClicked: WishesTheme.current.clickedColor

    // 缩放比例
    property real scaleNormal: 1.0
    property real scaleHovered: 1.0
    property real scalePressed: 1.0

    // 状态切换时间(毫秒)
    property int stateSwitchDuration: 100

    // 禁用
    // enabled

    property int cursorShape: Qt.ArrowCursor

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    property bool hovered: false

    // 自定义信号
    signal clickedLeft()
    signal clickedRight()
    signal released()
    signal entered()
    signal exited()

    // 用于 Canvas 绘制的特殊信号
    signal paint(var ctx)

    scale: scaleNormal
    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: background
                color: root.colorNormal
            }
            PropertyChanges {
                target: root
                scale: root.scaleNormal
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: background
                color: root.colorHovered
            }
            PropertyChanges {
                target: root
                scale: root.scaleHovered
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: background
                color: root.colorClicked
            }
            PropertyChanges {
                target: root
                scale: root.scalePressed
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "hovered"
            ParallelAnimation {
                ScaleAnimator {
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "*"
            to: "pressed"
            ParallelAnimation {
                ScaleAnimator {
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "*"
            to: "normal"
            ParallelAnimation {
                ScaleAnimator {
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]

    function requestPaint() {
        canvas.requestPaint()
    }

    WRectangle {
        id: background
        anchors.fill: parent
        cornersRadius: root.cornersRadius
        color: root.colorNormal
        colorSwitchDuration: root.stateSwitchDuration
    }

    Canvas {
        id: canvas
        anchors.centerIn: parent
        width: root.canvasWidth
        height: root.canvasHeight
        antialiasing: true
        onPaint: {
            root.paint(getContext('2d'))
        }
        onVisibleChanged: requestPaint()
        Component.onCompleted: requestPaint()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        // 只接受左键和右键输入
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: parent.cursorShape

        onClicked: (mouse) => {
            // 左键
            if (mouse.button === Qt.LeftButton) {
                parent.clickedLeft()
            } else if (mouse.button === Qt.RightButton) {
                parent.clickedRight()
            }
        }

        // 按下
        onPressed: {
            parent.state = "pressed"
        }

        // 释放
        onReleased: {
            if (root.hovered) {
                parent.state = "hovered"
            }
            parent.released()
        }

        // 鼠标进入
        onEntered: {
            parent.hovered = true
            parent.state = "hovered"
            parent.entered()
        }

        // 鼠标离开
        onExited: {
            parent.hovered = false
            parent.state = "normal"
            parent.exited()
        }

        // 状态变化触发重绘
        onContainsMouseChanged: canvas.requestPaint()
        onPressedChanged: canvas.requestPaint()
    }

    // 禁用功能
    WRectangle {
        id: unenabledOverlayRect
        visible: opacity > 0.0
        anchors.fill: parent
        cornersRadius: parent.cornersRadius

        color: "black"
        opacity: 0.0

        Behavior on opacity {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }

    onEnabledChanged: {
        if (enabled) {
            unenabledOverlayRect.opacity = 0
        } else {
            unenabledOverlayRect.opacity = 0.3
        }
    }
}
