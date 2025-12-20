import QtQuick 2.15
import "../Base"
import "../Theme"

Item {
    id: root

    // 文本
    property string text: "ToggleImageTextButton"
    property string fontFamily: WishesTheme.textFamily
    property bool fontBold: false
    property int fontSize: 10
    property color fontColor: "black"
    property color fontColorHovered: fontColor
    property color fontColorClicked: fontColor
    property color fontColorToggled: fontColor

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
        anchors {
            top: parent.top
            topMargin: root.topPadding
            horizontalCenter: parent.horizontalCenter
        }
        width: root.imageWidth
        height: root.imageHeight
        source: root.imageSource
        fillMode: Image.PreserveAspectFit
        clip: true
        mipmap: true
    }

    Text {
        id: btnText
        anchors {
            bottom: parent.bottom
            bottomMargin: root.bottomPadding
            horizontalCenter: parent.horizontalCenter
        }
        text: root.text
        font {
            family: root.fontFamily
            bold: root.fontBold
            pointSize: root.fontSize
        }
        color: root.fontColor
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
            PropertyChanges {
                target: btnText
                color: root.fontColor
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
            PropertyChanges {
                target: btnText
                color: root.fontColorToggled
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: bg
                color: root.colorToggled
            }
            PropertyChanges {
                target: btnText
                color: root.fontColorToggled
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "common"
            ColorAnimation { target: btnText; duration: root.stateSwitchDuration }
        },
        Transition {
            from: "*"
            to: "hovered"
            ColorAnimation { target: btnText; duration: root.stateSwitchDuration }
        },
        Transition {
            from: "*"
            to: "toggled"
            ColorAnimation { target: btnText; duration: root.stateSwitchDuration }
        },
        Transition {
            from: "*"
            to: "pressed"
            ColorAnimation { target: btnText; duration: root.stateSwitchDuration }
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
