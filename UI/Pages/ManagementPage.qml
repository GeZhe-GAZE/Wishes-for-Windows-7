import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Controls"
import "../../WishesUI/Theme"
import "../../UI/Pages/ManagementPages"

Item {
    id: root

    Text {
        text: "管理"
        anchors {
            top: parent.top
            right: parent.right
        }
        font {
            family: WishesTheme.fontFamily
            pointSize: 20
            bold: true
        }
        color: WishesTheme.current.titleColor
    }

    ToggleGroup {
        id: toggleGroup
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        height: 200
        width: 50
        layoutDirection: Qt.Vertical

        radius: 10

        model: ListModel {
            ListElement {text: "卡片"}
            ListElement {text: "卡组"}
            ListElement {text: "逻辑"}
            ListElement {text: "卡池"}
        }

        onCurrentIndexChanged: {
            view.switchItem(currentIndex)
        }

        Component.onCompleted: {
            check(0)
        }
    }

    SwitchView {
        id: view
        anchors {
            top: parent.top
            left: parent.left
            right: toggleGroup.left
            bottom: parent.bottom
            rightMargin: 10
        }
        verticalAnimation: false
        animationInOffset: width
        animationOutOffset: -width

        initTag: "card"

        background.visible: false

        CardManagementPage {
            id: cardManagementPage
            property string tag: "card"
        }

        CardGroupManagementPage {
            id: cardGroupManagementPage
            property string tag: "card-group"
        }

        WishLogicManagementPage {
            id: wishLogicManagementPage
            property string tag: "logic"
        }

        CardPoolManagementPage {
            id: cardPoolManagementPage
            property string tag: "card-pool"
        }
    }
}