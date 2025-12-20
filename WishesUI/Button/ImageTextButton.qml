import QtQuick 2.15
import QtGraphicalEffects 1.0
import "../Base"
import "../Theme"

Item {
    id: root

    // 文本
    property string text: "ImageTextButton"
    property string fontFamily: WishesTheme.textFamily
    property bool fontBold: false
    property int fontSize: 10
    property color fontColor: "black"
    property color fontColorHovered: fontColor
    property color fontColorClicked: fontColor

    // 图片
    property string imageSource: ""
    property real imageWidth: width * 0.6
    property real imageHeight: height * 0.6

    property int topPadding: width * 0.1
    property int bottomPadding: height * 0.1

    property color colorNormal: WishesTheme.current.buttonColor
    property color colorHovered: WishesTheme.current.hoveredColor
    property color colorClicked: WishesTheme.current.clickedColor

    property real bgOpacity: 1

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    property int stateSwitchDuration: 100

    //自定义点击信号
    signal clickedLeft()
    signal clickedRight()
    signal released()
    signal entered()
    signal exited()

    property bool hovered: false

    readonly property alias colorOverlay: colorOverlay

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
        smooth: true
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: btnImage
        source: btnImage
        enabled: false

        Behavior on color {
            ColorAnimation {
                duration: root.stateSwitchDuration
            }
        }
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
                root.clickedLeft()
            } else if (mouse.button === Qt.RightButton) {
                root.clickedRight()
            }
        }

        // 释放
        onReleased: {
            parent.released()
            if (root.hovered) {
                // 在内部
                root.state = "hovered"
            } else {
                // 在外部
                root.state = "common"
            }
        }

        onPressed: {
            root.state = "clicked"
        }

        // 鼠标进入
        onEntered: {
            root.entered()
            parent.hovered = true
            root.state = "hovered"
        }

        // 鼠标离开
        onExited: {
            root.exited()
            parent.hovered = false
            root.state = "common"
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
            name: "clicked"
            PropertyChanges {
                target: bg
                color: root.colorClicked
            }
            PropertyChanges {
                target: btnText
                color: root.fontColorClicked
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "common"
            ColorAnimation { target:btnText; duration: root.stateSwitchDuration }
        },
        Transition {
            from: "*"
            to: "hovered"
            ColorAnimation { target:btnText; duration: root.stateSwitchDuration }
        },
        Transition {
            from: "*"
            to: "clicked"
            ColorAnimation { target:btnText; duration: root.stateSwitchDuration }
        }
    ]
}
