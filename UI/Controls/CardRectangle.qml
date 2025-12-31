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

    clip: true

    property QCard card

    property color starColor: "white"
    property real iconSize: 0.25

    function load() {
        if (!card) return
        starColor = backend.adapter_get_color(card.game, card.star)
        var attributeImagePath = backend.image_get_attribute(card.game, card.attribute)
        attributeImage.source = attributeImagePath == "" ? "" : "file:///" + attributeImagePath
        var professionImagePath = backend.image_get_profession(card.game, card.profession)
        professionImage.source = professionImagePath == "" ? "" : "file:///" + professionImagePath
        
        var rarityImagePath = backend.image_get_rarity(card.game, card.star)
        if (rarityImagePath != "") {
            rarityImage.visible = true
            rarityImage.source = "file:///" + rarityImagePath
            starRarity.visible = false
            starText.visible = false
        } else {
            starRarity.visible = backend.adapter_check_using_star(card.game, card.star)
            starText.text = card.star
            rarityText.text = card.rarity
        }

        contentText.text = card.content
        var contentImagePath = backend.image_get_card(card.imagePath)
        contentImage.source = contentImagePath == "" ? "" : "file:///" + contentImagePath
    }

    Rectangle {
        id: bg
        anchors.fill: parent

        color: ControlsConfig.cardBackgroundColor
    }

    Image {
        id: contentImage
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: bottomRect.bottom
            margins: -root.width * 0.2
        }
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }

    Column {
        id: iconLayout
        anchors {
            top: parent.top
            left: parent.left
            margins: 5
        }
        width: 30
        height: 30

        Image {
            id: attributeImage
            visible: source != ""
            width: Math.min(root.width * root.iconSize, 30)
            height: width
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }

        Image {
            id: professionImage
            visible: source != ""
            width: Math.min(root.width * root.iconSize, 30)
            height: width
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }
    }

    Item {
        id: starRarity
        anchors {
            top: parent.top
            right: parent.right
        }
        height: Math.min(parent.width * root.iconSize, 30)
        width: height * 2
        
        Image {
            id: starImage
            source: "../../UI/Icons/CardRectangle/star.svg"
            anchors.right: parent.right
            width: height
            height: parent.height
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }

        Text {
            id: starText
            anchors {
                right: starImage.left
                left: parent.left
                rightMargin: 2
            }
            height: parent.height
            // text: card.star
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            fontSizeMode: Text.Fit
            minimumPointSize: 5
            color: "white"
            font {
                family: WishesTheme.fontFamily
                pointSize: 50
            }
        }
    }

    Text {
        id: rarityText
        visible: false
        anchors {
            top: parent.top
            right: parent.right
            margins: 5
        }
        color: root.starColor
        width: height
        height: Math.min(parent.width * root.iconSize, 30)
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignRight
        fontSizeMode: Text.Fit
        minimumPointSize: 5
        font {
            family: WishesTheme.fontFamily
            pointSize: 50
        }
    }

    Image {
        id: rarityImage
        anchors {
            top: parent.top
            right: parent.right
            margins: 5
        }
        width: height
        height: Math.min(parent.width * root.iconSize, 30)
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    Rectangle {
        id: contentBg
        visible: false
        anchors {
            bottom: bottomRect.top
            left: parent.left
            right: parent.right
        }
        height: parent.height * 0.3
    }

    LinearGradient {
        anchors.fill: contentBg
        start: Qt.point(0, 0)
        end: Qt.point(0, height)
        gradient: Gradient {
            GradientStop {position: 0.0; color: Qt.rgba(root.starColor.r, root.starColor.g, root.starColor.b, 0.0)}
            GradientStop {position: 0.65; color: Qt.rgba(root.starColor.r, root.starColor.g, root.starColor.b, 0.2)}
            GradientStop {position: 1.0; color: Qt.rgba(root.starColor.r, root.starColor.g, root.starColor.b, 0.4)}
        }
    }

    Text {
        id: contentText
        // text: card.content
        color: "white"
        anchors {
            left: contentBg.left
            right: contentBg.right
            bottom: contentBg.bottom
            bottomMargin: contentBg.height * 0.25
        }
        height: contentBg.height * 0.3
        fontSizeMode: Text.Fit
        minimumPointSize: 5
        font {
            family: WishesTheme.fontFamily
            pointSize: 50
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: bottomRect
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: root.height * 0.02
        color: root.starColor
    }
}