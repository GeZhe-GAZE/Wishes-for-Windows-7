import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Controls"
import "../../WishesUI/Theme"

Item {
    id: root

    property real radius: 20

    property double infoAreaTopWidth: 0.6
    property double infoAreaBottomWidth: 0.4

    WRectangle {
        id: bg
        anchors.fill: parent
        cornersRadius: [0, root.radius, 0, root.radius]
    }

    Canvas {
        id: infoAreaTop
        anchors {
            top: parent.top
            left: parent.left
        }
        width: root.width * root.infoAreaTopWidth
        height: root.height / 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.beginPath()
            ctx.lineWidth = 0
            ctx.fillStyle = "red"
            ctx.moveTo(0, 0)
            ctx.lineTo(width, 0)
            ctx.lineTo(root.width * (root.infoAreaTopWidth + root.infoAreaBottomWidth) / 2, height)
            ctx.lineTo(0, height)
            ctx.lineTo(0, 0)
            ctx.fill()
            ctx.closePath()
        }
    }

    Canvas {
        id: infoAreaBottom
        anchors {
            top: infoAreaTop.bottom
            left: parent.left
            bottom: parent.bottom
        }
        width: root.width * (root.infoAreaTopWidth + root.infoAreaBottomWidth) / 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.beginPath()
            ctx.fillStyle = "black"
            ctx.lineWidth = 0
            ctx.moveTo(0, 0)
            ctx.lineTo(width, 0)
            ctx.lineTo(root.width * root.infoAreaBottomWidth, height)
            ctx.lineTo(0, height)
            ctx.lineTo(0, 0)
            ctx.fill()
            ctx.closePath()
        }

        Rectangle {
        z: 100
        radius: 10
        width: 20
        height: width
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 20
        }
    }
    }
}