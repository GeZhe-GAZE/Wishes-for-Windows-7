// pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Theme"
import "../Base"
import "../Button"

Item {
    id: root

    readonly property alias background: background
    property ListModel topButtonList: ListModel {}      // 应包含 string imageSource_, string tag
    property ListModel centerButtonList: ListModel {}
    property ListModel bottomButtonList: ListModel {}

    /*
        按钮列表配置演示:
        topButtonList: ListModel {
            ListElement { imageSource: "UI/Icons/Back.png"; tag: "back" }
            ListElement { imageSource: "UI/Icons/Forward.png"; tag: "forward" }
            ListElement { imageSource: "UI/Icons/Refresh.png"; tag: "refresh" }
        }
        or:
        topButtonList.append({ imageSource: "UI/Icons/Back.png"; tag: "back" })
    */

    property int radius: 0
    property var cornersRadius: [radius, radius, radius, radius]
    property real padding: 5
    property real spacing: 5

    property color partingLineColor: WishesTheme.current.lineColor
    property real partingLineHeight: 2
    property real partingLinePadding: 5

    property real buttonSize: 1.0
    property real buttonRadiusSize: 0.1
    property real buttonImageSize: 0.7
    property color buttonColorNormal: WishesTheme.current.barColor
    property color buttonColorHovered:  WishesTheme.current.hoveredColor
    property color buttonColorToggled:  WishesTheme.current.toggledColor

    property color currentTipColor: WishesTheme.current.primaryColor
    property real currentTipHeightSize: 0.7
    property real currentTipWidthSize: 0.5

    readonly property real viewHeight: height - 2 * partingLineHeight - 4 * partingLinePadding - 2 * padding
    readonly property real viewWidth: width - 2 * padding
    readonly property real buttonHeight: root.viewWidth * root.buttonSize

    property var layoutWeights: [1, 1, 1]   // 控制顶部，中部，底部所占区域比例
    property real layoutWeightSum: root.layoutWeights.reduce((total, value) => total + value, 0)

    property string currentTag: ""
    property string initTag: ""

    signal selected(string part, string tag)

    function toggleTag(tag) {
        for (let i = 0; i< topButtonList.count; i++) {
            if (topButtonList.get(i).tag == tag) {
                topButtonRepeater.itemAt(i).toggle()
                return
            }
        }
        for (let i = 0; i< centerButtonList.count; i++) {
            if (centerButtonList.get(i).tag == tag) {
                centerButtonRepeater.itemAt(i).toggle()
                return
            }
        }
        for (let i = 0; i< bottomButtonList.count; i++) {
            if (bottomButtonList.get(i).tag == tag) {
                bottomButtonRepeater.itemAt(i).toggle()
                return
            }
        }
    }

    onCurrentTagChanged: {
        for (let i = 0; i< topButtonList.count; i++) {
            if (topButtonList.get(i).tag != currentTag) {
                topButtonRepeater.itemAt(i).uncheck()
            }
        }
        for (let i = 0; i< centerButtonList.count; i++) {
            if (centerButtonList.get(i).tag != currentTag) {
                centerButtonRepeater.itemAt(i).uncheck()
            }
        }
        for (let i = 0; i< bottomButtonList.count; i++) {
            if (bottomButtonList.get(i).tag != currentTag) {
                bottomButtonRepeater.itemAt(i).uncheck()
            }
        }
    }

    Component.onCompleted: {
        for (let i = 0; i< topButtonList.count; i++) {
            if (topButtonList.get(i).tag == initTag) {
                topButtonRepeater.itemAt(i).toggle()
                return
            }
        }
        for (let i = 0; i< centerButtonList.count; i++) {
            if (centerButtonList.get(i).tag == initTag) {
                centerButtonRepeater.itemAt(i).toggle()
                return
            }
        }
        for (let i = 0; i< bottomButtonList.count; i++) {
            if (bottomButtonList.get(i).tag == initTag) {
                bottomButtonRepeater.itemAt(i).toggle()
                return
            }
        }
    }

    WRectangle {
        id: background
        anchors.fill: root
        cornersRadius: root.cornersRadius
        color: WishesTheme.current.barColor
    }

    // 列表中包含 string imageSource_, string tag

    ScrollView {
        id: topView
        visible: root.topButtonList.count > 0
        anchors {
            top: root.top
            left: root.left
            right: root.right
            margins: root.padding
        }
        clip: true
        height: root.viewHeight * (root.layoutWeights[0] / root.layoutWeightSum)
        contentHeight: root.topButtonList.count * (root.buttonHeight + root.spacing) - root.spacing
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Column {
            spacing: root.spacing
            Repeater {
                id: topButtonRepeater
                model: root.topButtonList

                ToggleImageButton {
                    required property string imageSource_
                    required property string tag

                    width: root.buttonHeight
                    height: width
                    imageSource: imageSource_
                    imageWidth: width * root.buttonImageSize
                    imageHeight: height * root.buttonImageSize
                    radius: width * root.buttonRadiusSize

                    colorNormal: root.buttonColorNormal
                    colorHovered: root.buttonColorHovered
                    colorToggled: root.buttonColorToggled

                    colorOverlay {
                        enabled: true
                        color: isToggled ? WishesTheme.current.imageActiveColor:  WishesTheme.current.imageColor
                    }

                    Rectangle {
                        id: currentTip
                        visible: parent.isToggled
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height * root.currentTipHeightSize
                        width: (parent.width - parent.imageWidth) / 2 * root.currentTipWidthSize
                        radius: width / 2
                        color: root.currentTipColor
                        x: ((parent.width - parent.imageWidth) / 2 - width) / 2
                    }

                    onToggled: {
                        root.currentTag = tag
                        root.selected("top", tag)
                    }
                }
            }
        }
    }

    WRectangle {
        id: partingLine1
        visible: root.topButtonList.count > 0 && root.centerButtonList.count > 0
        anchors {
            top: topView.bottom
            left: parent.left
            right: parent.right
            topMargin: root.partingLinePadding
            leftMargin: root.padding
            rightMargin: root.padding
        }
        height: root.partingLineHeight
        radius: height / 2
        color: root.partingLineColor
    }

    ScrollView {
        id: centerView
        visible: root.centerButtonList.count > 0
        anchors {
            top: partingLine1.bottom
            left: root.left
            right: root.right
            topMargin: root.partingLinePadding
            leftMargin: root.padding
            rightMargin: root.padding
        }
        clip: true
        height: root.viewHeight * (root.layoutWeights[1] / root.layoutWeightSum)
        contentHeight: root.centerButtonList.count * (root.buttonHeight + root.spacing) - root.spacing
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Column {
            spacing: root.spacing
            Repeater {
                id: centerButtonRepeater
                model: root.centerButtonList

                ToggleImageButton {
                    required property string imageSource_
                    required property string tag

                    width: root.buttonHeight
                    height: width
                    imageSource: imageSource_
                    imageWidth: width * root.buttonImageSize
                    imageHeight: height * root.buttonImageSize
                    radius: width * root.buttonRadiusSize

                    colorNormal: root.buttonColorNormal
                    colorHovered: root.buttonColorHovered
                    colorToggled: root.buttonColorToggled

                    colorOverlay {
                        enabled: true
                        color: isToggled ? WishesTheme.current.imageActiveColor:  WishesTheme.current.imageColor
                    }

                    Rectangle {
                        id: currentTip
                        visible: parent.isToggled
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height * root.currentTipHeightSize
                        width: (parent.width - parent.imageWidth) / 2 * root.currentTipWidthSize
                        radius: width / 2
                        color: root.currentTipColor
                        x: ((parent.width - parent.imageWidth) / 2 - width) / 2
                    }

                    onToggled: {
                        root.currentTag = tag
                        root.selected("center", tag)
                    }
                }
            }
        }
    }

    WRectangle {
        id: partingLine2
        visible: root.centerButtonList.count > 0 && root.bottomButtonList.count > 0
        anchors {
            top: centerView.bottom
            left: parent.left
            right: parent.right
            topMargin: root.partingLinePadding
            leftMargin: root.padding
            rightMargin: root.padding
        }
        height: root.partingLineHeight
        radius: height / 2
        color: root.partingLineColor
    }

    ScrollView {
        id: bottomView
        visible: root.bottomButtonList.count > 0
        anchors {
            top: partingLine2.bottom
            left: root.left
            right: root.right
            bottom: root.bottom
            topMargin: root.partingLinePadding
            leftMargin: root.padding
            rightMargin: root.padding
            bottomMargin: root.padding
        }
        clip: true
        //height: root.viewHeight * (root.layoutWeights[1] / root.layoutWeightSum)
        contentHeight: root.bottomButtonList.count * (root.buttonHeight + root.spacing) - root.spacing
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Column {
            spacing: root.spacing
            Repeater {
                id: bottomButtonRepeater
                model: root.bottomButtonList

                ToggleImageButton {
                    required property string imageSource_
                    required property string tag

                    width: root.buttonHeight
                    height: width
                    imageSource: imageSource_
                    imageWidth: width * root.buttonImageSize
                    imageHeight: height * root.buttonImageSize
                    radius: width * root.buttonRadiusSize

                    colorNormal: root.buttonColorNormal
                    colorHovered: root.buttonColorHovered
                    colorToggled: root.buttonColorToggled

                    colorOverlay {
                        enabled: true
                        color: isToggled ? WishesTheme.current.imageActiveColor:  WishesTheme.current.imageColor
                    }

                    Rectangle {
                        id: currentTip
                        visible: parent.isToggled
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height * root.currentTipHeightSize
                        width: (parent.width - parent.imageWidth) / 2 * root.currentTipWidthSize
                        radius: width / 2
                        color: root.currentTipColor
                        x: ((parent.width - parent.imageWidth) / 2 - width) / 2
                    }

                    onToggled: {
                        root.currentTag = tag
                        root.selected("bottom", tag)
                    }
                }
            }
        }
    }
}
