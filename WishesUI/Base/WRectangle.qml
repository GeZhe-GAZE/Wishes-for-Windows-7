import QtQuick 2.15
import QtQuick.Shapes 1.0
import "../Theme"

Item {
    id: root

    // 圆角半径
    // 若圆角半径过大，会导致边角交叉，圆角矩形绘制出错
    property int radius: 0

    // 从左上角开始，按顺时针顺序
    property var cornersRadius: [radius, radius, radius, radius]

    // 纯色设置
    property color color: WishesTheme.current.rectangleColor
    property int colorSwitchDuration: 100

    Behavior on color { ColorAnimation { duration: root.colorSwitchDuration } }

    // 快捷设置渐变色，一致时为纯色
    property color gradStartColor: color
    property color gradEndColor: color

    // 更多渐变需求传入gradient列表
    property var gradient: [
        {position: 0.0, color: gradStartColor},
        {position: 1.0, color: gradEndColor}
    ]

    property real borderWidth: 0
    property color borderColor: WishesTheme.current.lineColor

    Canvas {
        id: background
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width + 1, height + 1)  // +1以保证彻底清除原有内容，不留边框
            ctx.fillStyle = root.getGradient(ctx)
            root.roundRect(ctx, x, y, width, height, root.cornersRadius)
            ctx.fill()
        }
    }

    // Shape {
    //     id: borderTest
    //     visible: false
    //     anchors.fill: parent
    //     layer.enabled: true
    //     layer.samples: 9
    //     layer.smooth: true
    //     ShapePath {
    //         startX: root.borderWidth / 2
    //         startY: root.cornersRadius[0] + root.borderWidth / 2
    //         fillColor: "transparent"
    //         strokeColor: root.borderColor
    //         strokeWidth: root.borderWidth

    //         PathArc {
    //             x: root.cornersRadius[0] + root.borderWidth / 2
    //             y: root.borderWidth / 2
    //             radiusX: root.cornersRadius[0]
    //             radiusY: root.cornersRadius[0]
    //         }
    //         PathLine {
    //             x: borderTest.width - root.cornersRadius[1] + root.borderWidth / 2
    //             y: root.borderWidth / 2
    //         }
    //         PathArc {
    //             x: borderTest.width - root.borderWidth / 2
    //             y: root.cornersRadius[1] + root.borderWidth / 2
    //             radiusX: root.cornersRadius[1]
    //             radiusY: root.cornersRadius[1]
    //         }
    //         PathLine {
    //             x: borderTest.width - root.borderWidth / 2
    //             y: borderTest.height - root.cornersRadius[2] - root.borderWidth / 2
    //         }
    //         PathArc {
    //             x: borderTest.width - root.cornersRadius[2] - root.borderWidth / 2
    //             y: borderTest.height - root.borderWidth / 2
    //             radiusX: root.cornersRadius[2]
    //             radiusY: root.cornersRadius[2]
    //         }
    //         PathLine {
    //             x: root.cornersRadius[3] + root.borderWidth / 2;
    //             y: borderTest.height - root.borderWidth / 2
    //         }
    //         PathArc {
    //             x: root.borderWidth / 2
    //             y: borderTest.height - root.cornersRadius[3] + root.borderWidth / 2
    //             radiusX: root.cornersRadius[3]
    //             radiusY: root.cornersRadius[3]
    //         }
    //         PathLine {
    //             x: root.borderWidth / 2;
    //             y: root.cornersRadius[1] + root.borderWidth / 2
    //         }
    //     }
    // }

    Canvas {
        id: border
        // visible: /*root.borderWidth > 0*/ true
        anchors.fill: parent
        onPaint: {
            if (root.borderWidth <= 0) {
                return
            }
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width + 1, height + 1)  // +1以保证彻底清除原有内容，不留边框
            ctx.strokeStyle = root.borderColor
            ctx.lineWidth = root.borderWidth
            root.roundBorder(ctx,
                             x + root.borderWidth / 2,
                             y + root.borderWidth / 2,
                             width - root.borderWidth,
                             height - root.borderWidth,
                             root.cornersRadius)
        }
    }

    // 绘制圆角矩形
    function roundRect(ctx, x, y, w, h, cornersRadius) {
        // cornersRadius: [左上, 右上, 右下, 左下]
        ctx.beginPath()

         // 四个角的半径
        var ltr = cornersRadius[0]
        var rtr = cornersRadius[1]
        var rbr = cornersRadius[2]
        var lbr = cornersRadius[3]

        // 初始点
        ctx.moveTo(x, y + ltr)  // 可省略，第一个arc会自动调用
        ctx.arc(x + ltr, y + ltr, ltr, Math.PI, Math.PI * 1.5)  // 左上角

        ctx.lineTo(x + w - rtr, y)  // 右上角起点
        ctx.arc(x + w - rtr, y + rtr, rtr, Math.PI * 1.5, Math.PI * 2)  // 右上角

        ctx.lineTo(x + w, y + h - rbr)  // 右下角起点
        ctx.arc(x + w - rbr, y + h - rbr, rbr, 0, Math.PI * 0.5)  // 右下角

        ctx.lineTo(x + lbr, y + h)  // 左下角起点
        ctx.arc(x + lbr, y + h - lbr, lbr, Math.PI * 0.5, Math.PI)  // 左下角

        // 回到初始点
        ctx.lineTo(x, y + ltr)

        ctx.fill()
        ctx.closePath()
    }

    function roundBorder(ctx, x, y, w, h, cornersRadius) {
        // cornersRadius: [左上, 右上, 右下, 左下]
        ctx.beginPath()

         // 四个角的半径
        var ltr = cornersRadius[0]
        var rtr = cornersRadius[1]
        var rbr = cornersRadius[2]
        var lbr = cornersRadius[3]

        // 初始点
        ctx.moveTo(x, y + ltr)  // 可省略，第一个arc会自动调用
        ctx.arc(x + ltr, y + ltr, ltr, Math.PI, Math.PI * 1.5)  // 左上角

        ctx.lineTo(x + w - rtr, y)  // 右上角起点
        ctx.arc(x + w - rtr, y + rtr, rtr, Math.PI * 1.5, Math.PI * 2)  // 右上角

        ctx.lineTo(x + w, y + h - rbr)  // 右下角起点
        ctx.arc(x + w - rbr, y + h - rbr, rbr, 0, Math.PI * 0.5)  // 右下角

        ctx.lineTo(x + lbr, y + h)  // 左下角起点
        ctx.arc(x + lbr, y + h - lbr, lbr, Math.PI * 0.5, Math.PI)  // 左下角

        // 回到初始点
        ctx.lineTo(x, y + ltr)

        ctx.stroke()
        ctx.closePath()
    }

    function getGradient(ctx) {
        var cgradient

        cgradient = ctx.createLinearGradient(0, 0, width, height)
        for (var i = 0; i < gradient.length; ++i) {
            cgradient.addColorStop(gradient[i].position, gradient[i].color)
        }

        return cgradient
    }

    // 由于其他变色方式都会改变 gradient ，所以使用 gradient 变色时，单独调用 changeColor 函数
    // 传入gradient渐变实现变色
    function setGradient(newgradient) {
        gradient = newgradient
        background.requestPaint()
    }

    // 改变颜色属性实现变色
    onColorChanged: {
        gradient = [{position: 0.0, color: color},
               {position: 1.0, color: color}]
        background.requestPaint()
    }

    onGradStartColorChanged: {
        gradient = [{position: 0.0, color: gradStartColor},
               {position: 1.0, color: gradEndColor}]
        background.requestPaint()
    }

    onGradEndColorChanged: {
        gradient = [{position: 0.0, color: gradStartColor},
               {position: 1.0, color: gradEndColor}]
        background.requestPaint()
    }

    onBorderWidthChanged: {
        border.requestPaint()
    }

    onBorderColorChanged: {
        border.requestPaint()
    }

    onCornersRadiusChanged: {
        background.requestPaint()
        border.requestPaint()
    }

    onWidthChanged: {
        background.requestPaint()
        border.requestPaint()
    }

    onHeightChanged: {
        background.requestPaint()
        border.requestPaint()
    }
}
