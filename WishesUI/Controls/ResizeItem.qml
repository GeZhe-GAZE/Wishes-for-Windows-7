import QtQuick 2.15

Item {
    id: root

    property var target: undefined
    property point startPoint: Qt.point(0, 0)
    property point fixedPoint: Qt.point(0, 0)
    property real minimumWidth: 0
    property real minimumHeight: 0
    property real areaWidth: 8

    // 左上角
    MouseArea {
        id: areaLeftTop
        x: 0
        y: 0
        width: root.areaWidth
        height: root.areaWidth
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeFDiagCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
            root.fixedPoint = Qt.point(root.target.x + root.target.width, root.target.y + root.target.height)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetX = mouse.x - root.startPoint.x
                var offsetY = mouse.y - root.startPoint.y

                // 宽
                if (root.target.width - offsetX >= root.minimumWidth) {
                    root.target.width -= offsetX
                    root.target.x = root.fixedPoint.x - root.target.width
                } else {
                    root.target.width = root.minimumWidth
                    root.target.x = root.fixedPoint.x - root.minimumWidth
                }
                // 高
                if (root.target.height - offsetY >= root.minimumHeight) {
                    root.target.height -= offsetY
                    root.target.y = root.fixedPoint.y - root.target.height
                } else {
                    root.target.height = root.minimumHeight
                    root.target.y = root.fixedPoint.y - root.minimumHeight
                }
            }
        }
    }

    // 顶部
    MouseArea {
        id: areaTop
        x: root.areaWidth
        y: 0
        width: parent.width - root.areaWidth * 2
        height: root.areaWidth
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeVerCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
            root.fixedPoint = Qt.point(0, root.target.y + root.target.height)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetY = mouse.y - root.startPoint.y

                // 高
                if (root.target.height - offsetY >= root.minimumHeight) {
                    root.target.height -= offsetY
                    root.target.y = root.fixedPoint.y - root.target.height
                } else {
                    root.target.height = root.minimumHeight
                    root.target.y = root.fixedPoint.y - root.minimumHeight
                }
            }
        }
    }

    // 右上角
    MouseArea {
        id: areaRightTop
        x: parent.width - root.areaWidth
        y: 0
        width: root.areaWidth
        height: root.areaWidth
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeBDiagCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
            root.fixedPoint = Qt.point(root.target.x, root.target.y + root.target.height)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetX = mouse.x - root.startPoint.x
                var offsetY = mouse.y - root.startPoint.y

                // 宽
                if (root.target.width + offsetX >= root.minimumWidth) {
                    root.target.width += offsetX
                } else {
                    root.target.width = root.minimumWidth
                }
                // 高
                if (root.target.height - offsetY >= root.minimumHeight) {
                    root.target.height -= offsetY
                    root.target.y = root.fixedPoint.y - root.target.height
                } else {
                    root.target.height = root.minimumHeight
                    root.target.y = root.fixedPoint.y - root.minimumHeight
                }
            }
        }
    }

    // 右部
    MouseArea {
        id: areaRight
        x: parent.width - root.areaWidth
        y: root.areaWidth
        width: root.areaWidth
        height: parent.height - root.areaWidth * 2
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeHorCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetX = mouse.x - root.startPoint.x

                // 宽
                if (root.target.width + offsetX >= root.minimumWidth) {
                    root.target.width += offsetX
                } else {
                    root.target.width = root.minimumWidth
                }
            }
        }
    }

    // 右下角
    MouseArea {
        id: areaRightBottom
        x: parent.width - root.areaWidth
        y: parent.height - root.areaWidth
        width: root.areaWidth
        height: root.areaWidth
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeFDiagCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetX = mouse.x - root.startPoint.x
                var offsetY = mouse.y - root.startPoint.y

                // 宽
                if (root.target.width + offsetX >= root.minimumWidth) {
                    root.target.width += offsetX
                } else {
                    root.target.width = root.minimumWidth
                }
                // 高
                if (root.target.height + offsetY >= root.minimumHeight) {
                    root.target.height += offsetY
                } else {
                    root.target.height = root.minimumHeight
                }
            }
        }
    }

    // 底部
    MouseArea {
        id: areaBottom
        x: root.areaWidth
        y: parent.height - root.areaWidth
        width: parent.width - root.areaWidth * 2
        height: root.areaWidth
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeVerCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetY = mouse.y - root.startPoint.y

                // 高
                if (root.target.height + offsetY >= root.minimumHeight) {
                    root.target.height += offsetY
                } else {
                    root.target.height = root.minimumHeight
                }
            }
        }
    }

    // 左下角
    MouseArea {
        id: areaLeftBottom
        x: 0
        y: parent.height - root.areaWidth
        width: root.areaWidth
        height: root.areaWidth
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeBDiagCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
            root.fixedPoint = Qt.point(root.target.x + root.target.width, root.target.y)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetX = mouse.x - root.startPoint.x
                var offsetY = mouse.y - root.startPoint.y

                // 宽
                if (root.target.width - offsetX >= root.minimumWidth) {
                    root.target.width -= offsetX
                    root.target.x = root.fixedPoint.x - root.target.width
                } else {
                    root.target.width = root.minimumWidth
                    root.target.x = root.fixedPoint.x - root.minimumWidth
                }
                // 高
                if (root.target.height + offsetY >= root.minimumHeight) {
                    root.target.height += offsetY
                } else {
                    root.target.height = root.minimumHeight
                }
            }
        }
    }

    // 左部
    MouseArea {
        id: areaLeft
        x: 0
        y: root.areaWidth
        width: root.areaWidth
        height: parent.height - root.areaWidth * 2
        hoverEnabled: true

        onEntered: cursorShape = Qt.SizeHorCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: (mouse) => {
            root.startPoint = Qt.point(mouse.x, mouse.y)
            root.fixedPoint = Qt.point(root.target.x + root.target.width, 0)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                var offsetX = mouse.x - root.startPoint.x

                // 宽
                if (root.target.width - offsetX >= root.minimumWidth) {
                    root.target.width -= offsetX
                    root.target.x = root.fixedPoint.x - root.target.width
                } else {
                    root.target.width = root.minimumWidth
                    root.target.x = root.fixedPoint.x - root.minimumWidth
                }
            }
        }
    }
}
