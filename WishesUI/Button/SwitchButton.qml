import QtQuick 2.15
import "../Theme"

Item {
    id: root

    readonly property alias text: textTip
    readonly property alias buttonBackground: buttonRect
    readonly property alias thumb: buttonCircle

    property bool textUsabled: true
    property string textOn: "On"
    property string textOff: "Off"
    property string fontFamily: WishesTheme.textFamily
    property color fontColorOn: WishesTheme.current.textColor
    property color fontColorOff: WishesTheme.current.textColor

    property color buttonColorHoveredOff: WishesTheme.current.hoveredColor
    property color buttonColorHoveredOn: WishesTheme.current.secondaryColor
    property color buttonColorOff: "grey"
    property color buttonColorOn: "white"

    property color areaColorOff: WishesTheme.current.backgroundColor
    property color areaColorOn: WishesTheme.current.primaryColor

    property int animationDuration: 200

    property bool isOn: false

    // 设置文本和按钮滑条的相对位置
    enum PlaceHints {
        TextOnLeft = 0b01,
        TextOnRight = 0b10
    }
    property int textPlace: SwitchButton.PlaceHints.TextOnLeft

    signal clicked()

    state: "off"
    states: [
        State {
            name: "on"
            PropertyChanges {
                target: textTip
                color: root.fontColorOn
            }
            PropertyChanges {
                target: buttonRect
                color: root.areaColorOn
            }
            PropertyChanges {
                target: buttonCircle
                color: root.buttonColorOn
                x: buttonRect.width - buttonCircle.width - buttonCircle.y
            }
        },
        State {
            name: "off"
            PropertyChanges {
                target: textTip
                color: root.fontColorOff
            }
            PropertyChanges {
                target: buttonRect
                color: root.areaColorOff
            }
            PropertyChanges {
                target: buttonCircle
                color: buttonColorOff
                x: buttonCircle.y
            }
        },
        State {
            name: "hover"
            PropertyChanges {
                target: buttonCircle
                color: root.isOn? root.buttonColorHoveredOn : root.buttonColorHoveredOff
                x: root.isOn? buttonRect.width - buttonCircle.width - buttonCircle.y : buttonCircle.y
            }
            PropertyChanges {
                target: buttonRect
                color: root.isOn? root.areaColorOn : root.areaColorOff
            }
            PropertyChanges {
                target: textTip
                color: root.isOn? root.fontColorOn : root.fontColorOff
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "on"
            ColorAnimation {
                duration: root.animationDuration
            }
            XAnimator {
                duration: root.animationDuration
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "*"
            to: "off"
            ColorAnimation {
                duration: root.animationDuration
            }
            XAnimator {
                duration: root.animationDuration
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "*"
            to: "hover"
            ColorAnimation {
                duration: root.animationDuration
            }
        }
    ]

    Text {
        id: textTip
        visible: root.textUsabled
        anchors {
            verticalCenter: parent.verticalCenter
            right: {
                if (root.textPlace === SwitchButton.PlaceHints.TextOnLeft) {
                    return buttonArea.left
                }
            }
            left: {
                if (root.textPlace === SwitchButton.PlaceHints.TextOnRight) {
                    return buttonArea.right
                }
            }
            rightMargin: 10
            leftMargin: 10
        }
        text: root.isOn ? root.textOn : root.textOff
        font {
            family: root.fontFamily
            pointSize: 15
            bold: false
        }
    }

    Item {
        id: buttonArea
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: {
                if (root.textPlace === SwitchButton.PlaceHints.TextOnLeft) {
                    return parent.right
                }
            }
            left: {
                if (root.textPlace === SwitchButton.PlaceHints.TextOnRight) {
                    return parent.left
                }
            }
        }

        width: root.textUsabled ? parent.width / 3 * 2 : parent.width

        Rectangle {
            id: buttonRect
            anchors.fill: parent
            radius: height / 2
            border.color: WishesTheme.current.borderColor
            border.width: 2

            Rectangle {
                id: buttonCircle
                y: (parent.height - height) / 2
                x: y
                width: parent.height / 3 * 2
                height: width
                radius: width / 2
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton

        onClicked: {
            parent.clicked()
            root.isOn = !root.isOn
        }

        onEntered: {
            parent.state = "hover"
        }

        onExited: {
            if (root.isOn) {
                parent.state = "on"
            } else {
                parent.state = "off"
            }
        }
    }

    onIsOnChanged: {
        if (isOn) {
            state = "on"
        } else {
            state = "off"
        }
    }
}

