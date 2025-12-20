import QtQuick 2.15
import QtGraphicalEffects 1.0
import "../Base"
import "../Theme"

Item {
    id: root

    // 图片
    property string imageSource: ""
    property real imageWidth: width * 0.6
    property real imageHeight: height * 0.6

    property int topPadding: width * 0.1
    property int bottomPadding: height * 0.1

    property color colorNormal: WishesTheme.current.buttonColor
    property color colorHovered: WishesTheme.current.hoveredColor
    property color colorToggled: WishesTheme.current.toggledColor

    property real bgOpacity: 1

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    //自定义点击信号
    signal clickedLeft()
    signal clickedRight()
    signal released()
    signal entered()
    signal exited()
    signal toggled()

    property bool hovered: false
    property bool isToggled: false

    readonly property alias colorOverlay: colorOverlay

    property int stateSwitchDuration: 100

    // 设置初始颜色
    state: "common"

    WRectangle {
        id: bg
        anchors.fill: parent
        cornersRadius: root.cornersRadius
        color: root.colorNormal
        colorSwitchDuration: root.stateSwitchDuration
        opacity: root.bgOpacity
    }

    Image {
        id: btnImage
        anchors.centerIn: parent
        width: root.imageWidth
        height: root.imageHeight
        source: root.imageSource
        fillMode: Image.PreserveAspectFit
        clip: true
        mipmap: true
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: btnImage
        source: btnImage
        enabled: false
        color: root.isToggled ? WishesTheme.current.imageActiveColor : WishesTheme.current.imageColor

        Behavior on color {
            ColorAnimation {
                duration: root.stateSwitchDuration
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        // 只接受左键和右键输入
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            // 左键
            if (mouse.button === Qt.LeftButton) {
                root.state = "toggled"
                root.isToggled = true
                root.toggled()
                root.clickedLeft()
            } else if (mouse.button === Qt.RightButton) {
                root.clickedRight()
            }
        }

        // 释放
        onReleased: (mouse) => {
            parent.released()
            if (!root.hovered) {
                // 在外部释放
                if (!root.isToggled) {
                    root.state = "common"
                }
            }
        }

        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                if (!root.isToggled) {
                    root.state = "pressed"
                }
            }
        }

        // 鼠标进入
        onEntered: {
            parent.hovered = true
            if (!root.isToggled) root.state = "hovered"
            root.entered()
        }

        // 鼠标离开
        onExited: {
            parent.hovered = false
            if (!root.isToggled) root.state = "common"
            root.exited()
        }
    }

    states: [
        State {
            name: "common"
            PropertyChanges {
                target: bg
                color: root.colorNormal
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: bg
                color: root.colorHovered
            }
        },
        State {
            name: "toggled"
            PropertyChanges {
                target: bg
                color: root.colorToggled
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: bg
                color: root.colorToggled
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "common"
        },
        Transition {
            from: "*"
            to: "hovered"
        },
        Transition {
            from: "*"
            to: "toggled"
        },
        Transition {
            from: "*"
            to: "pressed"
        }
    ]

    function toggle() {
        root.state = "toggled"
        root.isToggled = true
        root.toggled()
    }

    function uncheck() {
        root.isToggled = false
        if (hovered) {
            root.state = "hovered"
        } else {
            root.state = "common"
        }
    }
}
