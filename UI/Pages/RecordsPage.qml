import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Controls"
import "../../WishesUI/Theme"

Item {
    id: root

    Text {
        text: "Records Page"
        anchors.centerIn: parent
        color: WishesTheme.current.titleColor
        font {
            pointSize: 50
            bold: true
            family: WishesTheme.fontFamily
        }
    }
}