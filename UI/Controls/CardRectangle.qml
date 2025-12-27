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

    property QCard card

    property color star_color: backend.adapter_get_color(card.game, card.star)
    property real iconSize: 0.25

    function load() {
        if (!card) return
        star_color = backend.adapter_get_color(card.game, card.star)
        var attributeImagePath = backend.image_get_attribute(card.game, card.attribute)
        attributeImage.source = attributeImagePath == "" ? "" : "file:///" + attributeImagePath
        var professionImagePath = backend.image_get_profession(card.game, card.profession)
        professionImage.source = professionImagePath == "" ? "" : "file:///" + professionImagePath
        starRarity.visible = backend.adapter_check_using_star(card.game, card.star)
        rarityText.visible = !starRarity.visible
        starText.text = card.star
        rarityText.text = card.rarity
        contentText.text = card.content
    }

    Rectangle {
        id: bg
        anchors.fill: parent

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, height)
            gradient: Gradient {
                GradientStop {position: 0.0; color: root.star_color}
                GradientStop {position: 0.7; color: Qt.lighter(root.star_color, 1.7)}
                GradientStop {position: 1.0; color: Qt.lighter(root.star_color, 2.0)}
            }
        }
    }

    Rectangle {
        anchors.fill: attributeImage
        color: "#808080"
        radius: width / 2
    }

    Image {
        id: attributeImage
        // source: "file:///" + backend.image_get_attribute(card.game, card.attribute)
        anchors {
            top: parent.top
            left: parent.left
        }
        width: Math.min(parent.width * 0.2, 30)
        height: width
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    Rectangle {
        anchors.fill: professionImage
        color: "#808080"
        radius: width / 2
    }
    
    Image {
        id: professionImage
        // source: "file:///" + backend.image_get_profession(card.game, card.profession)
        anchors {
            top: attributeImage.bottom
            left: parent.left
        }
        width: Math.min(parent.width * root.iconSize, 30)
        height: width
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    Item {
        id: starRarity
        // visible: backend.adapter_check_using_star(card.game, card.star)
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
            }
            height: parent.height
            // text: card.star
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 5
            font {
                family: WishesTheme.fontFamily
                pointSize: 50
            }
        }
    }

    Text {
        id: rarityText
        // visible: !backend.adapter_check_using_star(card.game, card.star)
        anchors {
            top: parent.top
            right: parent.right
        }
        // text: card.rarity
        width: height * 2
        height: Math.min(parent.width * root.iconSize, 30)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        minimumPointSize: 5
        font {
            family: WishesTheme.fontFamily
            pointSize: 50
        }
    }

    Rectangle {
        id: contentBg
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: parent.height * 0.1
        color: "black"
        opacity: 0.4
    }

    Text {
        id: contentText
        // text: card.content
        color: "white"
        anchors.fill: contentBg
        anchors.margins: contentBg.height * 0.1
        fontSizeMode: Text.Fit
        minimumPointSize: 5
        font {
            family: WishesTheme.fontFamily
            pointSize: 50
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}