import QtQuick 2.15
import "../Base"
import "../Theme"

Item {
    id: root

    // 文本
    property string text: "TextButton"
    property real textPadding: 0
    property bool fontBold: false
    property int fontHorizontalAlignment: Text.AlignHCenter
    property int fontVerticalAlignment: Text.AlignVCenter
    property int fontSizeMode: Text.FixedSize
    property int fontMinimumSize: 9
    property int fontPointSize: 10
    property string fontFamily: WishesTheme.fontFamily
    property color fontColor: WishesTheme.current.textColor
    property color fontColorHovered: fontColor

    // 背景
    property color colorNormal: WishesTheme.current.buttonColor
    property color colorHovered: WishesTheme.current.hoveredColor
    property color colorClicked: WishesTheme.current.clickedColor
    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]
    property real bgOpacity: 1
    property real borderWidth: 0
    property color borderColor: "grey"

    // 缩放比例
    property real scaleCommon: 1.0
    property real scaleHovered: 1.0
    property real scalePressed: 1.0

    // 状态切换时间(毫秒)
    property int stateSwitchDuration: 100

    // 禁用
    // enabled

    property int cursorShape: Qt.ArrowCursor

    //自定义信号
    signal clickedLeft()
    signal clickedRight()
    signal release()
    signal entered()
    signal exited()

    property bool hovered: false

    scale: scaleCommon

    // 通过状态切换实现颜色和大小平滑过渡
    state: "common"
    states: [
        State {
            name: "common"
            PropertyChanges {
                target: bg
                color: root.colorNormal
            }
            PropertyChanges {
                target: btnText
                color: root.fontColor
            }
            PropertyChanges {
                target: root
                scale: root.scaleCommon
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: bg
                color: root.colorHovered
            }
            PropertyChanges {
                target: btnText
                color: root.fontColorHovered
            }
            PropertyChanges {
                target: root
                scale: root.scaleHovered
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: bg
                color: root.colorClicked
            }
            PropertyChanges {
                target: btnText
                color: root.fontColorHovered
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
                ColorAnimation {
                    target: btnText
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    target: root
                    property: "scale"
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "*"
            to: "pressed"
            ParallelAnimation {
                ColorAnimation {
                    target: btnText
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    target: root
                    property: "scale"
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

                NumberAnimation {
                    target: root
                    property: "scale"
                    duration: root.stateSwitchDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]

    WRectangle {
        id: bg
        anchors.fill: parent
        cornersRadius: root.cornersRadius
        color: root.colorNormal
        colorSwitchDuration: root.stateSwitchDuration
        opacity: root.bgOpacity
        borderWidth: root.borderWidth
        borderColor: root.borderColor
    }

    Text {
        id: btnText
        anchors.fill: parent
        anchors.margins: root.textPadding
        text: root.text
        font {
            bold: root.fontBold
            pointSize: root.fontPointSize
            family: root.fontFamily
        }
        horizontalAlignment: root.fontHorizontalAlignment
        verticalAlignment: root.fontVerticalAlignment
        color: root.fontColor
        fontSizeMode: root.fontSizeMode
        minimumPointSize: root.fontMinimumSize
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
            parent.release()
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
            parent.state = "common"
            parent.exited()
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
        duration: 300
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
        duration: 300
        easing.type: Easing.InOutQuad

        onStopped: {
            unenabledOverlayRect.visible = false
        }
    }

    onEnabledChanged: {
        if (enabled) {
            overlayToUnenabledAnimation.stop()
            overlayToEnabledAnimation.restart()
        } else {
            overlayToEnabledAnimation.stop()
            overlayToUnenabledAnimation.restart()
        }
    }
}
