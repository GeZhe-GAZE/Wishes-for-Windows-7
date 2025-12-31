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

    property string currentFilterGame: ""
    property string currentFilterType: ""
    property string currentFilterRarity: ""

    property QCard currentCard
    property Item currentCardItem

    property int currentCardRow: -1
    property int currentCardColumn: -1

    property real cardRectWidth: (layout.width - 3 * layout.spacing) / layout.columns
    property real cardRectHeight: cardRectWidth * 1.8

    Component.onCompleted: {
        // syncCardList()
        syncGameList()
        syncTypeList()
        syncRarityList()
    }

    // function filterCardList() {
    //     cardList.clear()
    //     var lst = backend.card_system_get_card_list()
    //     for (var i = 0; i < lst.length; i++) {
    //         if (currentFilterGame != "" && lst[i].game != currentFilterGame) continue
    // }

    function updateCardInfo() {
        if (!currentCard) return
        var imageSource = backend.image_get_card(currentCard.imageSource)
        cardImage.source = imageSource == "" ? "" : "file:///" + imageSource
    }

    function syncGameList() {
        gameList.clear()
        var lst = backend.card_system_get_game_list()
        for (var i = 0; i < lst.length; i++) {
            gameList.append({tag: lst[i]})
        }
    }

    function syncTypeList() {
        typeList.clear()
        var lst = backend.card_system_get_type_list()
        for (var i = 0; i < lst.length; i++) {
            typeList.append({tag: lst[i]})
        }
    }

    function syncRarityList() {
        rarityList.clear()
        var lst = backend.card_system_get_rarity_list()
        for (var i = 0; i < lst.length; i++) {
            rarityList.append({tag: lst[i]})
        }
    }

    function syncCardList() {
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
            right: cardInfoArea.left
            rightMargin: 10
        }
        height: 40

        property bool isUnfolded: true

        ImageButton {
            id: unfoldButton
            anchors {
                top: parent.top
                left: parent.left
            }
            width: height
            height: currentFilterArea.height
            imageSource: filterArea.isUnfolded ? "../../UI/Icons/CardManagementPage/down.svg" 
                                               : "../../UI/Icons/CardManagementPage/up.svg"
            radius: 5

            onClickedLeft: {
                if (filterArea.isUnfolded) {
                    filterArea.height = 200
                    filterArea.isUnfolded = false
                } else {
                    filterArea.height = currentFilterArea.height
                    filterArea.isUnfolded = true
                }
            }
        }

        property real leftTextWidth: 100

        Item {
            id: currentFilterArea
            anchors {
                top: parent.top
                left: unfoldButton.right
                right: parent.right
                leftMargin: 5
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

            Text {
                visible: root.currentFilterGame == "" && root.currentFilterType == "" && root.currentFilterRarity == ""
                text: "无"
                color: WishesTheme.current.textColor
                anchors {
                    left: fixedFilterText1.right
                    right: parent.right
                }
                height: parent.height * 0.8
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
                spacing: 5
                
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
                    radius: 5
                    width: 100
                    height: parent.height
                    color: WishesTheme.current.toggledColor

                    Text {
                        anchors.fill: parent
                        anchors.margins: 7
                        text: root.currentFilterType
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
                    visible: root.currentFilterRarity != ""
                    radius: 5
                    width: 100
                    height: parent.height
                    color: WishesTheme.current.toggledColor

                    Text {
                        anchors.fill: parent
                        anchors.margins: 7
                        text: root.currentFilterRarity
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
            }
        }

        Column {
            visible: !filterArea.isUnfolded
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
                        top: parent.top
                        bottom: parent.bottom
                        topMargin: 10
                        bottomMargin: 10
                    }
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
                        right: parent.right
                    }
                    height: parent.height
                    clip: true
                    uncheckByMouse: true
                    model: ListModel {
                        id: gameList
                    }

                    onCurrentTagChanged: {
                        root.currentFilterGame = currentTag
                    }
                }
            }

            Item {
                height: (parent.height - 3 * parent.spacing) / 3
                width: parent.width

                Text {
                    id: fixedFilterText3
                    text: "类型"
                    color: WishesTheme.current.textColor
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        topMargin: 10
                        bottomMargin: 10
                    }
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
                        left: fixedFilterText3.right
                        right: parent.right
                    }
                    height: parent.height
                    clip: true
                    uncheckByMouse: true
                    model: ListModel {
                        id: typeList
                    }

                    onCurrentTagChanged: {
                        root.currentFilterType = currentTag
                    }
                }
            }

            Item {
                height: (parent.height - 3 * parent.spacing) / 3
                width: parent.width

                Text {
                    id: fixedFilterText4
                    text: "稀有度"
                    color: WishesTheme.current.textColor
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        topMargin: 10
                        bottomMargin: 10
                    }
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
                        left: fixedFilterText4.right
                        right: parent.right
                    }
                    height: parent.height
                    clip: true
                    uncheckByMouse: true
                    model: ListModel {
                        id: rarityList
                    }

                    onCurrentTagChanged: {
                        root.currentFilterRarity = currentTag
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
        clip: true

        Rectangle {
            id: currentCardTip
            color: "blue"
            opacity: 0.4
            x: root.currentCardItem.x + (root.currentCardItem.width - width) / 2
            y: root.currentCardItem.y + (root.currentCardItem.height - height) / 2
            width: cardRectWidth * 1.1
            height: cardRectHeight * 1.1
        }

        Grid {
            id: layout
            width: cardView.width - 10
            spacing: 10
            columns: 4
            
            Repeater {
                id: cardRepeater
                model: cardList

                CardRectangle {
                    id: cardRect
                    required property QCard modelData
                    required property int index
                    card: modelData
                    width: root.cardRectWidth
                    height: root.cardRectHeight

                    Component.onCompleted: {
                        load()
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        propagateComposedEvents: true

                        onClicked: (mouse) => {
                            root.currentCard = card
                            root.currentCardColumn = index % layout.columns
                            root.currentCardRow = parseInt(index / layout.columns)
                            root.currentCardItem = parent
                            //mouse.accepted = false
                        }
                    }
                }
            }
        }
    }

    Item {
        id: cardInfoArea
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: root.width * 0.35

        Rectangle {
            anchors.fill: parent
            color: WishesTheme.current.rectangleColor
            radius: 10
        }

        Image {
            id: cardImage
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10
            }
            height: width
            fillMode: Image.PreserveAspectFit
        }
    }

    // CardRectangle {
    //     width: 200
    //     height: 350
    //     anchors.centerIn: parent
    //     card: backend.card_system_get_card("胡桃")
    // }
}