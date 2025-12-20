import QtQuick 2.15
import "../Base"
import "../Theme"

Item {
    id: root

    property real minValue: 0
    property real maxValue: 100
    property real value: 50
    property real initValue: 50
    property real step: 1

    property int radius: height * 0.5

    property color backColor: WishesTheme.current.rectangleColor

    property color barColor: WishesTheme.current.primaryColor
    property real barPadding: 3

    property real thumbRadius: height * 0.4
    property color thumbColor: WishesTheme.current.buttonColor
    property color thumbColorHovered: WishesTheme.current.secondaryColor
    property real thumbScaleHovered: 1.0
    property real thumbBorderWidth: 0
    property color thumbBorderColor: WishesTheme.current.borderColor
    property int thumbStateSwitchDuration: 200

    property bool moveByMouse: false
    property bool realTime: false

    readonly property real contentWidth: width - 2 * barPadding

    onValueChanged: {
        if (!thumbDrag.active) {
            thumb.updateX()
        }
    }

    function snapToStep(rawValue) {
        if (step == 0) return rawValue  // 步长为 0，不启用步长功能
        const steppedValue = minValue + Math.round((rawValue - minValue) / step) * step
        return Math.max(minValue, Math.min(steppedValue, maxValue))
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.radius
        color: root.backColor

        // 点击直接跳转进度，吸附到步长点
        MouseArea {
            visible: root.moveByMouse
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: (mouse) => {
                const targetValue = Math.max(Math.min((mouse.x - root.barPadding - background.radius)
                                                      / (background.width - background.radius * 2) *
                                    (root.maxValue - root.minValue) + root.minValue, root.maxValue), root.minValue)
                root.value = root.snapToStep(targetValue)
            }
        }
    }

    Rectangle {
        id: bar
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: root.barPadding
        }
        radius: root.radius - root.barPadding
        color: root.barColor
        width: Math.min((root.contentWidth - radius * 2) * (root.value - root.minValue) /
                        (root.maxValue - root.minValue) + radius * 2,
                        root.contentWidth)
        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: thumb
        visible: root.moveByMouse
        anchors.verticalCenter: parent.verticalCenter
        height: root.thumbRadius * 2
        width: height
        radius: root.thumbRadius
        color: root.thumbColor
        border {
            width: root.thumbBorderWidth
            color: root.thumbBorderColor
        }
        x: 0

        onXChanged: {
            if (root.realTime) {
                const targetValue = (thumb.x - thumbDrag.xAxis.minimum) /
                                    (thumbDrag.xAxis.maximum - thumbDrag.xAxis.minimum) *
                                    (root.maxValue - root.minValue) + root.minValue
                root.value = root.snapToStep(targetValue)
            }
        }

        function updateX() {
            x = thumbDrag.xAxis.minimum + (root.value - root.minValue)
                / (root.maxValue - root.minValue) *
                (thumbDrag.xAxis.maximum - thumbDrag.xAxis.minimum)
        }

        // 拖拽
        DragHandler {
            id: thumbDrag
            target: thumb
            xAxis.minimum: root.barPadding + bar.radius - thumb.radius
            xAxis.maximum: root.width - root.barPadding - bar.radius - thumb.radius
            xAxis.onMaximumChanged: {
                thumb.updateX()
            }
            onActiveChanged: {
                if (!active) {
                    const targetValue = (thumb.x - xAxis.minimum) /
                                        (xAxis.maximum - xAxis.minimum) *
                                        (root.maxValue - root.minValue) + root.minValue
                    root.value = root.snapToStep(targetValue)
                    thumb.updateX()
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                root.state = "hovered"
            }

            onExited: {
                root.state = "normal"
            }
        }
    }

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: thumb
                color: root.thumbColor
                scale: 1.0
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: thumb
                color: root.thumbColorHovered
                scale: root.thumbScaleHovered
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "normal"
            ColorAnimation { duration: root.thumbStateSwitchDuration }
            ScaleAnimator { duration: root.thumbStateSwitchDuration }
        },
        Transition {
            from: "*"
            to: "hovered"
            ColorAnimation { duration: root.thumbStateSwitchDuration }
            ScaleAnimator { duration: root.thumbStateSwitchDuration }
        }
    ]

    Component.onCompleted: {
        value = initValue
    }
}
