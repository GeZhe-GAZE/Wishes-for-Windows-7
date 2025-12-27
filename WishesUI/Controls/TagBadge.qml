import QtQuick 2.15
import "../Theme"
import "../Base"
import "../Button"

Item {
    id: root

    readonly property alias background: background
    readonly property alias text: text
    readonly property alias closeButton: closeButton

    property real padding: 2
    property real closeButtonMaxSize: 20

    signal closed()

    width: 40
    height: 20

    WRectangle {
        id: background
        anchors.fill: parent
        radius: 5
    }

    Text {
        id: text
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: closeButton.visible ? closeButton.left : parent.right
            leftMargin: root.padding
        }
        height: parent.height - 2 * root.padding
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font {
            family: WishesTheme.fontFamily
            pointSize: 50
        }
        fontSizeMode: Text.Fit
        minimumPointSize: 5
        color: WishesTheme.current.textColor
    }

    ImageButton {
        id: closeButton
        colorNormal: background.color
        imageSource: "../Images/tag_badge_close.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: root.padding
        }
        height: Math.min(parent.height - 2 * root.padding, root.closeButtonMaxSize)
        width: height
    }
}
