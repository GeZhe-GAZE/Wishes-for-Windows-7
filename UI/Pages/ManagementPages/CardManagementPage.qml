import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../../WishesUI/Base"
import "../../../WishesUI/Button"
import "../../../WishesUI/Controls"
import "../../../WishesUI/Theme"

Item {
    id: root

    property real toggleGroupWidth: 0
    property real toggleGroupHeight: 0

    Item {
        id: filterArea
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            rightMargin: root.toggleGroupWidth + 20
        }
        height: 60
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
    }

    Item {
        id: cardInfoArea
        anchors {
            top: parent.top
        }
    }
}