import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Theme"
import "../../UI/Controls"

Item {
    id: root

    property QCardPool currentCardPool

    signal returnToMain()

    BlockGradientRectangle {
        id: bg
        anchors.fill: parent
        direction: BlockGradientRectangle.LayoutDirection.COLUMN
        blockNum: 20
        gradStartColor: WishesTheme.current.backgroundColor
        gradEndColor: WishesTheme.current.primaryColor
    }

    ImageButton {
        id: returnButton
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }
        width: 60
        height: width
        radius: 5
        colorNormal: WishesTheme.current.backgroundColor
        imageSource: "../../UI/Icons/WishPage/return.svg"

        onClickedLeft: {
            root.returnToMain()
        }
    }

    CardPoolRectangle {
        id: cpRect
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            margins: 50
        }
        width: root.width * 0.85
    }
}