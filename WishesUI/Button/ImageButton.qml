import QtQuick 2.15
import QtGraphicalEffects 1.0
import "../Base"
import "../Theme"

Item {
    id: root

    property alias unenbledOverlay: unenabledOverlayRect

    // 图片
    property string imageSource: ""
    property real imageWidth: width * 0.7
    property real imageHeight: height * 0.7
    property string imageSourceHovered: imageSource

    property color colorNormal: WishesTheme.current.buttonColor
    property color colorHovered: WishesTheme.current.hoveredColor
    property color colorClicked: WishesTheme.current.clickedColor

    property color imageColor: WishesTheme.current.imageColor
    property color imageActiveColor: WishesTheme.current.imageActiveColor

    property real bgOpacity: 1

    // 缩放比例
    property real scaleCommon: 1.0
    property real scaleHovered: 1.0
    property real scalePressed: 1.0

    // 状态切换时间(毫秒)
    property int stateSwitchDuration: 100

    // 禁用
    // enabled

    property int cursorShape: Qt.ArrowCursor
    property bool mouseAreaPropagateComposedEvents: false

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    // 自定义信号
    signal clickedLeft()
    signal clickedRight()
    signal released()
    signal entered()
    signal exited()

    property bool hovered: false

    readonly property alias colorOverlay: colorOverlay

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
                target: root
                scale: root.scaleHovered
            }
        },
        State {
            name: "clicked"
            PropertyChanges {
                target: bg
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
            to: "clicked"
            ParallelAnimation {
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
                ScaleAnimator {
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
    }

    Image {
        id: btnImageHovered
        visible: source != root.imageSource
        anchors.centerIn: parent
        width: root.imageWidth
        height: root.imageHeight
        fillMode: Image.PreserveAspectFit
        source: root.imageSourceHovered
        clip: true
        opacity: 1
        // 图片更平滑
        mipmap: true
    }

    Image {
        id: btnImage
        anchors.centerIn: parent
        width: root.imageWidth
        height: root.imageHeight
        fillMode: Image.PreserveAspectFit
        source: root.imageSource
        clip: true
        opacity: 1
        // 图片更平滑
        mipmap: true
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: btnImage
        source: btnImage
        enabled: true
        color: root.state == "clicked" ? root.imageActiveColor : root.imageColor

        Behavior on color {
            ColorAnimation {
                duration: root.stateSwitchDuration
            }
        }
    }

    ParallelAnimation {
        id: toCommonImageAnimation
        NumberAnimation {
            target: btnImage
            property: "opacity"
            to: 1
            duration: root.stateSwitchDuration
        }

        NumberAnimation {
            target: btnImageHovered
            property: "opacity"
            to: 0
            duration: root.stateSwitchDuration
        }
    }

    ParallelAnimation {
        id: toHoveredImageAnimation
        NumberAnimation {
            target: btnImage
            property: "opacity"
            to: 0
            duration: root.stateSwitchDuration
        }

        NumberAnimation {
            target: btnImageHovered
            property: "opacity"
            to: 1
            duration: root.stateSwitchDuration
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        // 只接受左键和右键输入
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        propagateComposedEvents: parent.mouseAreaPropagateComposedEvents
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
            parent.state = "clicked"
        }

        // 释放
        onReleased: {
            parent.released()
            if (root.hovered) {
                parent.state = "hovered"
            } else {
                root.state = "common"
            }
        }

        // 鼠标进入
        onEntered: {
            root.entered()
            root.hovered = true
            root.state = "hovered"
        }

        // 鼠标离开
        onExited: {
            root.exited()
            root.hovered = false
            parent.state = "common"
        }
    }

    // 禁用功能
    WRectangle {
        id: unenabledOverlayRect
        visible: true
        anchors.fill: parent
        cornersRadius: root.cornersRadius

        color: "black"
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                duration: unenabledOverlayRect.colorSwitchDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    // NumberAnimation {
    //     id: overlayToUnenabledAnimation
    //     target: unenabledOverlayRect
    //     property: "opacity"
    //     to: 0.3
    //     duration: root.stateSwitchDuration
    //     easing.type: Easing.InOutQuad

    //     onStarted: {
    //         unenabledOverlayRect.visible = true
    //     }
    // }

    // NumberAnimation {
    //     id: overlayToEnabledAnimation
    //     target: unenabledOverlayRect
    //     property: "opacity"
    //     to: 0.0
    //     duration: root.stateSwitchDuration
    //     easing.type: Easing.InOutQuad

    //     onFinished: {
    //         unenabledOverlayRect.visible = false
    //     }
    // }

    onEnabledChanged: {
        if (enabled) {
            unenabledOverlayRect.opacity = 0
        } else {
            unenabledOverlayRect.opacity = 0.3
        }
    }

    onStateChanged: {
        bg.state = state
        if (root.imageSourceHovered !== root.imageSource) {
            // if (state === "common") toCommonImageAnimation.restart()
            // else if (state === "hovered") toHoveredImageAnimation.restart()
        }
    }
}
