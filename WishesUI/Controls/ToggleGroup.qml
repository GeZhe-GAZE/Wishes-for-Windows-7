import QtQuick 2.15
import "../Base"
import "../Button"
import "../Theme"

// 选择按钮组
Item {
    id: root

    property bool fontBold: false
    property int fontPointSize: 18
    property string fontFamily: WishesTheme.fontFamily

    property int layoutDirection: Qt.Horizontal
    property int spacing: 0
    property int currentIndex: -1
    property string currentText: ""

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    property ListModel model: ListModel {
        // string text
    }
    property Repeater repeater

    function check(index) {
        if (index < 0 || index >= model.count) return
        repeater.itemAt(index).check()
    }

    function checkText(index) {}
    function uncheck() {}
    
    function _uncheck() {
        for (var i = 0; i < model.count; i++) {
            if (i != currentIndex) {
                repeater.itemAt(i).uncheck()
            }
        }
    }

    Loader {
        id: layoutLoader
        anchors.fill: parent
        sourceComponent: {
            switch(root.layoutDirection) {
            case Qt.Horizontal:
                return horizontalComponent
            case Qt.Vertical:
                return verticalComponent
            default:
                return horizontalComponent
            }
        }
    }

    Component {
        id: horizontalComponent
        Row {
            spacing: root.spacing
            Repeater {
                id: horizontalRepeater
                model: root.model
                ToggleTextButton {
                    required property int index
                    required property string modelData

                    width: (parent.width - (model.count - 1) * root.spacing) / model.count
                    height: parent.height
                    cornersRadius: (model.count == 1) ? root.cornersRadius : [
                        (index == 0) ? root.cornersRadius[0] : 0,
                        (index == model.count - 1) ? root.cornersRadius[1] : 0,
                        (index == model.count - 1) ? root.cornersRadius[2] : 0,
                        (index == 0) ? root.cornersRadius[3] : 0
                    ]

                    text: modelData
                    fontFamily: root.fontFamily
                    fontPointSize: root.fontPointSize
                    fontBold: root.fontBold

                    onToggled: {
                        root.currentIndex = index
                        root.currentText = text
                        root._uncheck()
                    }
                }
            }

            Component.onCompleted: {
                root.repeater = verticalRepeater
            }
        }
    }

    Component {
        id: verticalComponent
        Column {
            spacing: root.spacing
            Repeater {
                id: verticalRepeater
                model: root.model
                ToggleTextButton {
                    required property int index
                    required property string modelData

                    width: parent.width
                    height: (parent.height - (model.count - 1) * root.spacing) / model.count
                    cornersRadius: (model.count == 1) ? root.cornersRadius : [
                        (index == 0) ? root.cornersRadius[0] : 0,
                        (index == 0) ? root.cornersRadius[1] : 0,
                        (index == model.count - 1) ? root.cornersRadius[2] : 0,
                        (index == model.count - 1) ? root.cornersRadius[3] : 0
                    ]

                    text: modelData
                    fontFamily: root.fontFamily
                    fontPointSize: root.fontPointSize
                    fontBold: root.fontBold

                    onToggled: {
                        root.currentIndex = index
                        root.currentText = text
                        root._uncheck()
                    }
                }
            }

            Component.onCompleted: {
                root.repeater = verticalRepeater
            }
        }
    }
}