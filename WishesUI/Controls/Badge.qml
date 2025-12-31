import QtQuick 2.15
import QtGraphicalEffects 1.12
import "../Base"

Item {
    id: root

    property string fontFamily: "Verdana"

    property string textL: "Badge"
    property string textR: "badge"

    property bool boldL: false
    property bool boldR: false

    property color colorL: "#313233"
    property color colorR: "#007ec6"

    property real colorLDarker: 1.3
    property real colorRDarker: 1.3

    property color colorTL: "white"
    property color colorTR: "white"

    property string logo: ""
    property string logoColor: "white"

    property real padding: 5
    property int radius: 3

    property string url: ""

    height: 20
    width: leftRect.width + rightRect.width

    Canvas {
        id: leftRect
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: leftRect.right
        }
        visible: textL != ""
        width: root.textL == "" ? 0 : textItemL.width + root.padding * 2

        onPaint: {
            var ctx = getContext("2d")
            
            console.log(leftRect.visible)
            var ltr = root.textL != "" ? root.radius : 0
            var rtr = root.textR != "" ? 0 : root.radius
            var rbr = root.textR != "" ? 0 : root.radius
            var lbr = root.textL != "" ? root.radius : 0

            console.log(ltr, rtr, rbr, lbr)

            ctx.beginPath()
            ctx.moveTo(0, ltr)
            ctx.arc(ltr, ltr, ltr, Math.PI, Math.PI * 1.5)
            
            ctx.lineTo(width - rtr, 0)
            ctx.arc(width - rtr, rtr, rtr, Math.PI * 1.5, Math.PI * 2)

            ctx.lineTo(width, height - rbr)
            ctx.arc(width - rbr, height - rbr, rbr, 0, Math.PI * 0.5)

            ctx.lineTo(lbr, height)
            ctx.arc(lbr, height - lbr, lbr, Math.PI * 0.5, Math.PI)

            ctx.lineTo(0, ltr)
            ctx.closePath()

            var gradient = ctx.createLinearGradient(0, 0, 0, height)
            gradient.addColorStop(0.0, root.colorL)
            gradient.addColorStop(1.0, Qt.darker(root.colorL, root.colorLDarker))
            ctx.fillStyle = gradient
            ctx.fill()
        }

        Image{
            id: logoL
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: source != "" ? root.padding : 0
            }
            source: root.textL != "" ? root.logo : ""
            height: parent.height - root.padding * 2
            width: source != "" ? height : 0
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay {
            anchors.fill: logoL
            source: logoL
            color: root.logoColor
            visible: logoL.source != ""
        }

        Text {
            x: textItemL.x
            y: textItemL.y + 1
            text: root.textL
            font {
                family: root.fontFamily
                pixelSize: leftRect.height - root.padding * 2
                bold: root.boldL
            }
            color: "#010101"
            opacity: 0.4
        }

        Text {
            id: textItemL
            anchors {
                verticalCenter: parent.verticalCenter
                left: logoL.right
                leftMargin: root.padding
            }
            text: root.textL
            font {
                family: root.fontFamily
                pixelSize: leftRect.height - root.padding * 2
                bold: root.boldL
            }
            color: root.colorTL
        }
    }

    Canvas {
        id: rightRect
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: leftRect.right
        }
        visible: textR != ""
        width: root.textR == "" ? 0 : textItemR.width + root.padding * 2

        onPaint: {
            var ctx = getContext("2d")
            
            console.log(leftRect.visible)
            var ltr = root.textL != "" ? 0 : root.radius
            var rtr = root.textR != "" ? root.radius : 0
            var rbr = root.textR != "" ? root.radius : 0
            var lbr = root.textL != "" ? 0 : root.radius

            console.log(ltr, rtr, rbr, lbr)

            ctx.beginPath()
            ctx.moveTo(0, ltr)
            ctx.arc(ltr, ltr, ltr, Math.PI, Math.PI * 1.5)
            
            ctx.lineTo(width - rtr, 0)
            ctx.arc(width - rtr, rtr, rtr, Math.PI * 1.5, Math.PI * 2)

            ctx.lineTo(width, height - rbr)
            ctx.arc(width - rbr, height - rbr, rbr, 0, Math.PI * 0.5)

            ctx.lineTo(lbr, height)
            ctx.arc(lbr, height - lbr, lbr, Math.PI * 0.5, Math.PI)

            ctx.lineTo(0, ltr)
            ctx.closePath()

            var gradient = ctx.createLinearGradient(0, 0, 0, height)
            gradient.addColorStop(0.0, root.colorR)
            gradient.addColorStop(1.0, Qt.darker(root.colorR, root.colorRDarker))
            ctx.fillStyle = gradient
            ctx.fill()
        }

        Text {
            x: textItemR.x
            y: textItemR.y + 1
            text: root.textR
            font {
                family: root.fontFamily
                pixelSize: leftRect.height - root.padding * 2
                bold: root.boldR
            }
            color: "#010101"
            opacity: 0.4
        }

        Text {
            id: textItemR
            anchors.centerIn: parent
            text: root.textR
            font {
                family: root.fontFamily
                pixelSize: rightRect.height - root.padding * 2
                bold: root.boldR
            }
            color: root.colorTR
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.url == "") return
            Qt.openUrlExternally(root.url)
        }
    }
}