import QtQuick 2.15
import "../Base"
import "../Button"
import "../Theme"

Item {
    id: root

    readonly property alias background: backgroundRect
    readonly property alias underline: underline
    readonly property alias textInput: textInput
    readonly property alias placeholder: placeholder
    readonly property alias clearButton: clearButton

    property color backColor: WishesTheme.current.buttonColor
    property double backOpacity: 1
    property int backRadius: 4
    property var backCornersRadius: [backRadius, backRadius, backRadius, backRadius]

    property color lineColorFocused: WishesTheme.current.primaryColor
    property color lineColorCommon: WishesTheme.current.secondaryColor

    property string showText: ""
    property string placeholderText: ""
    property int fontSize: 20
    property color fontColor: WishesTheme.current.textColor
    property string fontFamily: WishesTheme.textFamily
    property bool fontBold: true
    property color placeholderColor: "grey"
    property string placeholderFamily: fontFamily
    property bool placeholderBold: fontBold
    property bool placeholderItalic: false

    property var validator: RegularExpressionValidator {}

    property int textPlace: Text.AlignHCenter

    property bool clearButtonEnable: false
    property color clearButtonImageColor: WishesTheme.current.imageColor

    signal inputTextChanged()
    signal inputTextEdited()
    signal returnPressed()

    state: "common"
    states: [
        State {
            name: "common"
            PropertyChanges {
                target: underline
                color: root.lineColorCommon
            }
        },
        State {
            name: "focused"
            PropertyChanges {
                target: underline
                color: root.lineColorFocused
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: underline
                color: root.lineColorFocused
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "focused"

            // PropertyAnimation {
            //     target: underline
            //     property: "color"
            //     duration: 200
            // }
        },
        Transition {
            from: "*"
            to: "common"

            // PropertyAnimation {
            //     target: underline
            //     property: "color"
            //     duration: 200
            // }
        },
        Transition {
            from: "*"
            to: "hovered"

            // PropertyAnimation {
            //     target: underline
            //     property: "color"
            //     duration: 200
            // }
        }
    ]

    WRectangle {
        id: backgroundRect
        anchors.fill: parent
        color: root.backColor
        opacity: root.backOpacity
        cornersRadius: root.backCornersRadius

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.IBeamCursor

            onEntered: {
                if (root.state !== "focused") {
                    root.state = "hovered"
                }
            }

            onExited: {
                if (!textInput.activeFocus) {
                    root.state = "common"
                }
            }
        }
    }

    WRectangle {
        id: underline
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        color: root.lineColorCommon
        cornersRadius: [0, 0, root.backCornersRadius[2], root.backCornersRadius[3]]
        // 取最大
        height: root.backCornersRadius[2] > root.backCornersRadius[3] ?
                root.backCornersRadius[2] : root.backCornersRadius[3]
    }

    TextInput {
        id: textInput
        anchors {
            top: parent.top
            left: parent.left
            right: root.clearButtonEnable ? clearButton.left : parent.right
            bottom: underline.top
            leftMargin: 5
            rightMargin: 5
        }
        text: parent.showText
        clip: true
        horizontalAlignment: root.textPlace
        // Qt Creator错误提示以下verticalAlignment属性不存在，实际上是存在的
        verticalAlignment: Text.AlignVCenter
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
            bold: root.fontBold
        }
        color: root.fontColor
        validator: parent.validator

        selectByMouse: true
        selectionColor: "#1f57ff"

        onTextChanged: {
            parent.showText = text
            parent.inputTextChanged()
        }

        onTextEdited: {
            parent.showText = text
            parent.inputTextEdited()
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                // 获得焦点
                root.state = "focused"
                selectAll()
            } else {
                // 焦点丢失
                root.state = "common"
            }
        }

        Keys.enabled: true
        Keys.onReturnPressed: {
            root.returnPressed()
        }
    }

    Text {
        id: placeholder
        // TextInput 的 inputMethodComsing 属性在输入法组织文本时，如输入拼音时变为 true; 完成输入时变为 false
        visible: textInput.inputMethodComposing ? false : textInput.text === ""
        anchors {
            top: parent.top
            left: parent.left
            right: root.clearButtonEnable ? clearButton.left : parent.right
            bottom: underline.top
        }
        text: root.placeholderText
        color: root.placeholderColor
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: root.textPlace
        font {
            family: root.placeholderFamily
            pixelSize: root.fontSize
            bold: root.placeholderBold
            italic: root.placeholderItalic
        }
    }

    CanvasButton {
        id: clearButton
        visible: root.clearButtonEnable ? root.state === "focused" : false
        anchors {
            right: parent.right
            top: parent.top
            bottom: underline.top
            margins: 4
        }
        onPaint: (ctx) => {
            ctx.beginPath()

            ctx.strokeStyle = root.clearButtonImageColor
            ctx.lineWidth = 1
            ctx.moveTo(0, 0)
            ctx.lineTo(canvasWidth, canvasHeight)
            ctx.moveTo(0, canvasHeight)
            ctx.lineTo(canvasWidth, 0)
            ctx.stroke()
        }
        width: height
        canvasWidth: width * 0.5
        canvasHeight: height * 0.5
        radius: root.backRadius
        colorNormal: root.backColor
        opacity: root.backOpacity
        cursorShape: Qt.PointingHandCursor

        onClickedLeft: {
            textInput.text = ""
        }
    }

    WRectangle {
        id: unenabledOverlay
        visible: true
        anchors.fill: parent
        cornersRadius: parent.backCornersRadius
        color: "black"
        opacity: 0.3

        Behavior on opacity {
            NumberAnimation {
                duration: unenabledOverlay.colorSwitchDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    onEnabledChanged: {
        if (enabled) {
            unenabledOverlay.opacity = 0
        } else {
            unenabledOverlay.opacity = 0.3
        }
    }

    function setText(text) {
        textInput.text = text
    }
}

