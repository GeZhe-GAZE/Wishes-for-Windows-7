import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../../WishesUI/Base"
import "../../../WishesUI/Button"
import "../../../WishesUI/Controls"
import "../../../WishesUI/Theme"
import "../../../UI/Controls"

Item {
    id: root

    property real toggleGroupWidth: 0
    property real toggleGroupHeight: 0

    property string currentFilterGame: ""
    property string currentFilterType: ""
    property string currentFilterRarity: ""

    Component.onCompleted: {
        // snycCardList()
        snycGameList()
    }

    function snycGameList() {
        gameList.clear()
        var lst = backend.card_system_get_game_list()
        for (var i = 0; i < lst.length; i++) {
            gameList.append({tag: lst[i]})
        }
    }

    function snycCardList() {
        cardList.clear()
        var lst = backend.card_system_get_card_list()
        for (var i = 0; i < lst.length; i++) {
            cardList.append({modelData: lst[i]})
        }
    }

    ListModel {
        id: cardList
    }

    Item {
        id: filterArea
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            rightMargin: root.toggleGroupWidth + 20
        }
        height: 200

        property real leftTextWidth: 100

        Item {
            id: currentFilterArea
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 40

            Text {
                id: fixedFilterText1
                text: "当前筛选条件"
                color: WishesTheme.current.textColor
                anchors {
                    left: parent.left
                }
                height: parent.height
                width: filterArea.leftTextWidth
                font {
                    family: WishesTheme.fontFamily
                    pointSize: 100
                }
                fontSizeMode: Text.Fit
                minimumPointSize: 5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                anchors {
                    left: fixedFilterText1.right
                    leftMargin: 5
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                
                Rectangle {
                    visible: root.currentFilterGame != ""
                    radius: 5
                    width: 100
                    height: parent.height
                    color: WishesTheme.current.toggledColor

                    Text {
                        anchors.fill: parent
                        anchors.margins: 7
                        text: root.currentFilterGame
                        color: WishesTheme.current.textActiveColor
                        font {
                            pointSize: 100
                            family: WishesTheme.fontFamily
                            bold: true
                        }
                        fontSizeMode: Text.Fit
                        minimumPointSize: 5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                
                Rectangle {
                    visible: root.currentFilterType != ""
                    radius: 10
                    width: 100
                    height: parent.height
                    color: WishesTheme.current.toggledColor
                }

                Rectangle {
                    visible: root.currentFilterRarity != ""
                    radius: 10
                    width: 100
                    height: parent.height
                    color: WishesTheme.current.toggledColor
                }
            }
        }

        Column {
            anchors {
                top: currentFilterArea.bottom
                bottom: parent.bottom
            }
            width: parent.width

            Item {
                height: (parent.height - 3 * parent.spacing) / 3
                width: parent.width

                Text {
                    id: fixedFilterText2
                    text: "游戏"
                    color: WishesTheme.current.textColor
                    anchors {
                        left: parent.left
                    }
                    height: parent.height
                    width: filterArea.leftTextWidth
                    font {
                        family: WishesTheme.fontFamily
                        pointSize: 100
                    }
                    fontSizeMode: Text.Fit
                    minimumPointSize: 5
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                ScrollToggleGroup {
                    anchors {
                        top: parent.top
                        left: fixedFilterText2.right
                        leftMargin: 5
                        right: parent.right
                    }
                    height: parent.height
                    model: ListModel {
                        id: gameList
                    }

                    onCurrentTagChanged: {
                        root.currentFilterGame = currentTag
                    }
                }
            }
        }
    }

    ScrollView {
        id: cardView
        anchors {
            top: filterArea.bottom
            left: parent.left
            right: filterArea.right
            bottom: parent.bottom
            topMargin: 10
        }

        Grid {
            id: layout
            width: cardView.width
            spacing: 10
            columns: 4
            
            Repeater {
                id: cardRepeater
                model: cardList

                CardRectangle {
                    required property QCard modelData
                    card: modelData
                    width: (layout.width - 3 * layout.spacing) / layout.columns
                    height: width * 1.8

                    Component.onCompleted: {
                        load()
                    }
                }
            }
        }
    }

    Item {
        id: cardInfoArea
        anchors {
            top: parent.top
        }
    }

    // CardRectangle {
    //     width: 200
    //     height: 350
    //     anchors.centerIn: parent
    //     card: backend.card_system_get_card("胡桃")
    // }
}