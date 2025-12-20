// pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Base"
import "../Theme"

Item {
    id: root

    readonly property alias background: background
    readonly property alias text: text
    readonly property alias arrow: arrow
    readonly property alias popup: popup

    property string currentText: ""
    property int currentIndex: -1
    property ListModel model: ListModel {}

    property real padding: 4

    function switchItem(index) {
        view.itemAtIndex(index).click()
    }

    function switchItemText(text) {
        for (let i = 0; i < model.count; i++) {
            if (model.get(i).modelData == text) {
                view.positionViewAtIndex(i, ListView.Beginning)
                view.itemAtIndex(i).click()
            }
        }
    }

    WRectangle {
        id: background
        anchors.fill: parent
        color: WishesTheme.current.buttonColor
        borderColor: WishesTheme.current.borderColor
    }

    Text {
        id: text
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            right: arrow.left
            margins: root.padding
        }
        verticalAlignment: Text.AlignVCenter
        text: root.currentText
        elide: Text.ElideRight
        color: WishesTheme.current.textColor
        font {
            family: WishesTheme.textFamily
        }
    }

    Canvas {
        id: arrow
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            margins: root.padding
        }
        width: Math.min(root.width * 0.2, 20)

        property real imageHeight: height / 10
        property real imageWidth: imageHeight * 3

        onPaint: {
            var ctx = getContext("2d")
            ctx.beginPath()
            ctx.strokeStyle = mouseArea.containsMouse ? WishesTheme.current.imageActiveColor :
                                                        WishesTheme.current.imageColor
            ctx.lineWidth = 1
            ctx.moveTo(Math.max(2, (width - imageWidth) / 2), (height - imageHeight) / 2)
            ctx.lineTo(width / 2, (height + imageHeight) / 2)
            ctx.lineTo(Math.min(width - 2, (width + imageWidth) / 2), (height - imageHeight) / 2)
            ctx.stroke()
        }
        rotation: popup.visible ? 180 : 0
        Behavior on rotation { NumberAnimation { duration: 100 } }

        Connections {
            target: WishesTheme

            function onCurrentChanged() {
                arrow.requestPaint()
            }
        }
    }

    Popup {
        id: popup
        y: root.height + 2
        width: root.width
        height: Math.min(200, view.contentHeight + 2 * padding)
        padding: 4
        spacing: 2

        property color textColor: WishesTheme.current.textColor
        property color textHighlightedColor: WishesTheme.current.textActiveColor
        property color backgroundColor: root.background.color
        property color backgroundHoveredColor: WishesTheme.current.hoveredColor
        property color backgroundHighlightedColor: WishesTheme.current.toggledColor

        property string fontFamily: WishesTheme.textFamily
        property int fontPointSize: 10

        property real itemHeight: 40

        property string currentText: ""

        background: Rectangle {
            radius: width * 0.05
            color: root.background.color
            layer.enabled: true
        }

        contentItem: ListView {
            id: view
            clip: true
            model: root.model
            currentIndex: root.currentIndex
            spacing: popup.spacing

            delegate: ItemDelegate {
                id: item
                required property var modelData
                required property int index
                width: view.width
                height: popup.itemHeight
                highlighted: view.currentIndex == index
                contentItem: Text {
                    text: item.modelData
                    color: item.highlighted ? popup.textHighlightedColor : popup.textColor
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    font {
                        bold: item.index == view.currentIndex
                        pointSize: popup.fontPointSize
                        family: popup.fontFamily
                    }
                }

                background: Rectangle {
                    color: item.highlighted ? popup.backgroundHighlightedColor :
                           item.hovered ? popup.backgroundHoveredColor :
                                          popup.backgroundColor
                    radius: height * 0.1
                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                onClicked: {
                    popup.currentText = item.modelData
                    root.currentIndex = index
                    root.currentText = item.modelData
                    popup.close()
                }
            }

            focus: true
            Keys.enabled: true
            Keys.onPressed: (event) => {
                // 跳转到首字母项
                if (Qt.Key_A <= event.key <= Qt.Key_Z) {
                    let letter = String.fromCharCode(event.key).toLowerCase()
                    for (let i = 0; i < model.count; i++ ) {
                        if (model.get(i).modelData.toLowerCase().startsWith(letter)) {
                            view.positionViewAtIndex(i, ListView.Beginning)
                            break
                        }
                    }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {}
        }

        onOpened: forceActiveFocus()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            popup.visible = true
        }

        onContainsMouseChanged: {
            arrow.requestPaint()
        }
    }
}

