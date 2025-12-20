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

    property int card_pool_count: backend.card_pool_count

    property real card_pool_rect_height: 200

    signal cardPoolSwitched(QCardPool cardPool)

    Component.onCompleted: {
        root.syncCardPoolList()
    }

    Connections {
        target: backend
        function onCardPoolListChanged() {
            root.syncCardPoolList()
        }
    }

    function syncCardPoolList() {
        cardPoolList.clear()
        for (var i = 0; i < card_pool_count; i++) {
            cardPoolList.append({
                isAdditionItem: false,
                cardPool: backend.card_pool_list[i]
            })
        }
        cardPoolList.append({
            isAdditionItem: true,
        })
    }

    ListModel {
        id: cardPoolList
        // bool isAdditionItem, QCardPool cardPool
    }
    

    LinearGradient {
        id: titleGradient
        visible: false
        width: title.width
        height: title.height
        start: Qt.point(0, 0)
        end: Qt.point(width, height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8dcfe" }
            GradientStop { position: 1.0; color: "#b3d7ff" }
        }
    }

    DropShadow {
        id: titleShadow
        opacity: WishesTheme.current.shadowOpacity
        anchors.fill: title
        source: title
        color: WishesTheme.current.shadowColor
        radius: 10
        samples: 20
        verticalOffset: 5
        horizontalOffset: 5
    }
    
    Text {
        id: title
        text: "Wishes"
        visible: false
        anchors {
            top: parent.top
            left: parent.left
        }
        font {
            family: WishesTheme.fontFamily
            bold: true
            pointSize: 80
        }
    }

    OpacityMask {
        anchors.fill: title
        source: titleGradient
        maskSource: title
    }

    DropShadow {
        id: versionShadow
        opacity: WishesTheme.current.shadowOpacity
        anchors.fill: versionText
        source: versionText
        color: WishesTheme.current.shadowColor
        radius: 10
        samples: 20
        verticalOffset: 5
        horizontalOffset: 5
    }

    Text {
        id: versionText
        text: backend.version
        color: WishesTheme.current.titleColor
        anchors {
            left: title.right
            bottom: title.bottom
            leftMargin: 10
        }
        font {
            family: WishesTheme.fontFamily
            pointSize: 40
        }
    }

    DropShadow {
        id: sloganText1Shadow
        opacity: WishesTheme.current.shadowOpacity
        anchors.fill: sloganText1
        source: sloganText1
        color: WishesTheme.current.shadowColor
        radius: 10
        samples: 20
        verticalOffset: 5
        horizontalOffset: 5
    }

    DropShadow {
        id: sloganText2Shadow
        opacity: WishesTheme.current.shadowOpacity
        anchors.fill: sloganText2
        source: sloganText2
        color: WishesTheme.current.shadowColor
        radius: 10
        samples: 20
        verticalOffset: 5
        horizontalOffset: 5
    }

    Text {
        id: sloganText1
        text: "Your Wish,"
        color: WishesTheme.current.titleColor
        anchors {
            top: parent.top
            right: sloganText2.left
            topMargin: 30
        }
        font {
            family: WishesTheme.fontFamily
            pointSize: 20
        }
    }


    Text {
        id: sloganText2
        text: "Your Way."
        color: WishesTheme.current.titleColor
        anchors {
            top: sloganText1.bottom
            right: parent.right
            rightMargin: 30
        }
        font {
            family: WishesTheme.fontFamily
            pointSize: 20
        }
    }

    Rectangle {
        id: titleLine
        anchors {
            top: title.bottom
            left: title.left
            right: parent.right
            topMargin: 10
        }
        height: 5
        radius: 2.5
        color: WishesTheme.current.lineColor
    }

    ScrollView {
        id: view
        anchors {
            top: titleLine.bottom
            left: titleLine.left
            right: titleLine.right
            bottom: parent.bottom
            margins: 20
            rightMargin: 0
        }
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        //Flickable.flickDirection: Flickable.VerticalFlick
        contentHeight: layout.height
        clip: true

        Grid {
            id: layout
            rows: parseInt(card_pool_count / 2) + 1
            columns: 2
            height: (root.card_pool_rect_height + spacing) * rows
            width: view.width
            spacing: 20

            Repeater {
                id: cardPoolRepeater
                model: cardPoolList
                Item {
                    required property int index
                    required property bool isAdditionItem
                    required property QCardPool cardPool

                    property bool isHovered: false

                    width: (layout.width - 40) / 2
                    height: root.card_pool_rect_height

                    DropShadow {
                        source: rectBg
                        anchors.fill: rectBg
                        radius: 10
                        samples: 20
                        color: WishesTheme.current.shadowColor
                        opacity: 0.4
                        horizontalOffset: 5
                        verticalOffset: 5
                    }

                    Rectangle {
                        id: rectBg
                        anchors.fill: parent
                        radius: Math.min(width, height) * 0.1
                        color: mouseArea.pressed ? WishesTheme.current.secondaryColor :
                        (parent.isHovered ? WishesTheme.current.hoveredColor :
                        WishesTheme.current.rectangleColor)
                    }

                    Text {
                        anchors.centerIn: parent
                        font {
                            family: WishesTheme.fontFamily
                            pointSize: 20
                            bold: true
                        }
                        color: WishesTheme.current.textColor
                        text: cardPool ? cardPool.name : ""
                    }

                    Image {
                        id: addImage
                        visible: false
                        anchors.centerIn: parent
                        source: "../../UI/Icons/MainPage/add.svg"
                        height: parent.height * 0.5
                        width: parent.width
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        visible: parent.isAdditionItem
                        anchors {
                            top: addImage.bottom
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 5
                        }
                        text: "添加卡池"
                        font {
                            family: WishesTheme.fontFamily
                            pointSize: 12
                        }
                        color: WishesTheme.current.textColor
                    }

                    ColorOverlay {
                        visible: parent.isAdditionItem
                        source: addImage
                        anchors.fill: addImage
                        color: mouseArea.hovered ? WishesTheme.current.imageActiveColor :
                                                   WishesTheme.current.imageColor
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        hoverEnabled: true

                        onEntered: {
                            parent.isHovered = true
                        }

                        onExited: {
                            parent.isHovered = false
                        }

                        onClicked: {
                            if (isAdditionItem) {
                                return
                            }
                            root.cardPoolSwitched(parent.cardPool)
                        }
                    }
                }
            }
        }
    }
}