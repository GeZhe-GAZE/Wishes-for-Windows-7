import QtQuick 2.15
import "../Base"
import "../Button"
import "../Theme"

Item {
    id: root

    property color backColor: "white"
    property double backOpacity: 1
    property int backRadius: 5
    property var backCornersRadius: [backRadius, backRadius, backRadius, backRadius]

    property color lineColorFocused: "DodgerBlue"
    property color lineColorCommon: "#738291"

    property int fontSize: 20
    property color fontClr: "black"
    property string fontFamily: WishesTheme.textFamily
    property bool fontBold: true

    property int buttonMargins: 3
    property int buttonRadius: upButton.height * 0.2

    // 最大和最小值
    property real numberMax
    property real numberMin
    // 浮点数精度
    property int doublePrecision: 2
    property real stepValue: 1

    enum NumberTypes {
        Int = 0b1,
        IntOnlyPositive = 0b10,
        Double = 0b100,
        DoubleOnlyPositive = 0b1000
    }
    property int numberType: NumberSpinBox.NumberTypes.Int
    property int numberPlace: Text.AlignLeft

    property alias numberText: numberTextInput.text
    property real value: 0

    property string upImageSource: ""
    property string downImageSource: ""

    signal tooBig()
    signal tooSmall()
    signal valueReturned()
    signal valueEdited()

    WRectangle {
        id: backgroundRect
        cornersRadius: root.backCornersRadius
        anchors.fill: parent
        color: root.backColor
        opacity: root.backOpacity

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                underline.state = "focused"
            }

            onExited: {
                if (!numberTextInput.activeFocus) {
                    underline.state = "common"
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
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "common"
                PropertyAnimation {
                    target: underline
                    property: "color"
                    duration: 200
                }
            },
            Transition {
                from: "*"
                to: "focused"
                PropertyAnimation {
                    target: underline
                    property: "color"
                    duration: 200
                }
            }
        ]
    }

    MouseArea {
        anchors.fill: numberTextInput
        cursorShape: Qt.IBeamCursor
    }

    RegularExpressionValidator {
        id: numberReg
        regularExpression: root.numberType === NumberSpinBox.NumberTypes.Int ? /^[-]?(\d|([1-9]\d+))$/ :
                           root.numberType === NumberSpinBox.NumberTypes.IntOnlyPositive ? /^(\d|([1-9]\d+))$/ :
                           root.numberType === NumberSpinBox.NumberTypes.Double ? /^[-]?(\d|([1-9]\d+))(\.\d+)$/ :
                           /^(\d|([1-9]\d+))(\.\d+)$/   // DoubleOnlyPositive
    }

    TextInput {
        id: numberTextInput
        anchors {
            top: parent.top
            bottom: underline.top
            left: parent.left
            right: upButton.left
            leftMargin: 10
            rightMargin: 10
        }
        clip: true
        validator: numberReg
        selectByMouse: true
        selectionColor: "#1f57ff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: root.numberPlace

        font {
            family: root.fontFamily
            pointSize: root.fontSize
            bold: root.fontBold
        }

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                root.valueReturned()
            }
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                // 获得焦点
                underline.state = "focused"
                selectAll()
            } else {
                // 焦点丢失
                underline.state = "common"
                root.valueReturned()
            }
        }
    }

    ImageButton {
        id: upButton
        anchors {
            top: parent.top
            bottom: underline.top
            right: downButton.left
            margins: root.buttonMargins
        }
        imageSource: root.upImageSource
        width: height + 10
        imageWidth: width - 15 < 20 ? 20 : width - 15
        imageHeight: height - 15 < 20 ? 20 : height - 15
        colorNormal: root.backColor
        opacity: root.backOpacity
        radius: root.buttonRadius

        onClickedLeft: {
            root.updateValue()
            numberTextInput.text = (root.value + root.stepValue).toString()
            root.valueReturned()
        }
    }

    ImageButton {
        id: downButton
        anchors {
            top: parent.top
            bottom: underline.top
            right: parent.right
            margins: root.buttonMargins
        }
        imageSource: root.downImageSource
        width: height + 10
        imageWidth: width - 15 < 20 ? 20 : width - 15
        imageHeight: height - 15 < 20 ? 20 : height - 15
        colorNormal: root.backColor
        opacity: root.backOpacity
        radius: root.buttonRadius

        onClickedLeft: {
            root.updateValue()
            numberTextInput.text = (root.value - root.stepValue).toString()
            root.valueReturned()
        }
    }

    onValueReturned: {
        format()
        value = Number(numberTextInput.text)
    }

    function format() {
        if (numberTextInput.text === "-") {
            numberTextInput.text = "0"
        }

        var num = Number(numberTextInput.text)

        // 范围处理
        if (numberMax) {
            if (num > numberMax) {
                numberTextInput.text = numberMax.toString()
            }
        }
        if (numberMin) {
            if (num < numberMin) {
                numberTextInput.text = numberMin.toString()
            }
        }

        // 格式处理
        if (numberTextInput.text === "") {
            numberTextInput.text = "0"
        }

        // 浮点数精度格式处理
        if (numberType === NumberSpinBox.NumberTypes.Double || numberType === NumberSpinBox.NumberTypes.DoubleOnlyPositive) {
            if (numberTextInput.text.indexOf('.') === -1) {
                numberTextInput.text += "." + "0".repeat(doublePrecision)
            } else {
                var numList = numberTextInput.text.split(".")
                if (numList.length < 2) {
                    numberTextInput.text += "0".repeat(doublePrecision)
                } else if(numList[1].length < doublePrecision) {
                    numberTextInput.text += "0".repeat(doublePrecision - numList[1].length)
                } else {
                    numberTextInput.text = numList[0] + "." + numList[1].slice(0, doublePrecision)
                }
            }
        }
    }

    function updateValue() {
        format()
        value = Number(numberTextInput.text)
    }

    function setNumberText(text) {
        numberText = text
        updateValue()
    }

    Component.onCompleted: {
        format()
        value = Number(numberTextInput.text)
    }
}

