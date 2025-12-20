import QtQuick 2.15

Item {
    id: root

    property color gradStartColor: "white"
    property color gradEndColor: "white"
    property int blockNum: 2    // blockNum >= 2

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]

    enum LayoutDirection {
        ROW,
        COLUMN
    }
    property int direction: BlockGradientRectangle.LayoutDirection.ROW

    property var blockColors: getBlockColors()

    function getBlockColors() {
        var lst = []
        lst.push(gradStartColor)

        // 计算步长
        var stepR = (gradEndColor.r - gradStartColor.r) / (blockNum - 1)
        var stepG = (gradEndColor.g - gradStartColor.g) / (blockNum - 1)
        var stepB = (gradEndColor.b - gradStartColor.b) / (blockNum - 1)

        for (var i = 1; i < blockNum; i++) {
            var clr = Qt.rgba(
                        gradStartColor.r + stepR * i,
                        gradStartColor.g + stepG * i,
                        gradStartColor.b + stepB * i,
                        1.0)
            lst.push(clr)
        }

        return lst
    }

    ListModel {
        id: blockModel
        // {blockIndex: int}
    }

    Loader {
        id: layoutLoder
        anchors.fill: parent
        sourceComponent: {
            switch(root.direction) {
            case BlockGradientRectangle.LayoutDirection.ROW:
                return rowComp
            case BlockGradientRectangle.LayoutDirection.COLUMN:
                return columnComp
            default:
                return rowComp
            }
        }
    }

    Component {
        id: rowComp
        Row {
            Repeater {
                model: blockModel
                WRectangle {
                    required property int blockIndex
                    width: root.width / root.blockNum
                    height: root.height
                    color: root.blockColors[blockIndex]
                    cornersRadius: [blockIndex === 0 ? root.cornersRadius[0] : 0,
                    blockIndex === root.blockNum - 1 ? root.cornersRadius[1] : 0,
                    blockIndex === root.blockNum - 1 ? root.cornersRadius[2] : 0,
                    blockIndex === 0 ? root.cornersRadius[3] : 0]
                }
            }
        }
    }

    Component {
        id: columnComp
        Column {
            Repeater {
                model: blockModel
                WRectangle {
                    required property int blockIndex
                    width: root.width
                    height: root.height / root.blockNum
                    color: root.blockColors[blockIndex]
                    cornersRadius: [blockIndex === 0 ? root.cornersRadius[0] : 0,
                    blockIndex === 0 ? root.cornersRadius[1] : 0,
                    blockIndex === root.blockNum - 1 ? root.cornersRadius[2] : 0,
                    blockIndex === root.blockNum - 1 ? root.cornersRadius[3] : 0]
                }
            }
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < blockNum; i++) {
            blockModel.append({blockIndex: i})
        }
    }
}

