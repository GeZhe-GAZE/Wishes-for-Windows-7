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

    Item {
        id: toggleGroup
        anchors {
            top: parent.top
            right: parent.right
        }
        height: 60
        width: 300
    }

    SwitchView {
        id: view
        anchors.fill: parent
        verticalAnimation: false
        animationInOffset: width
        animationOutOffset: -width

        initTag: "card"

        CardManagementPage {
            id: cardManagementPage
            property string tag: "card"
            toggleGroupWidth: toggleGroup.width
            toggleGroupHeight: toggleGroup.height
        }

        CardGroupManagementPage {
            id: cardGroupManagementPage
            property string tag: "card-group"
            toggleGroupWidth: toggleGroup.width
            toggleGroupHeight: toggleGroup.height
        }

        WishLogicManagementPage {
            id: wishLogicManagementPage
            property string tag: "logic"
            toggleGroupWidth: toggleGroup.width
            toggleGroupHeight: toggleGroup.height
        }

        CardPoolManagementPage {
            id: cardPoolManagementPage
            property string tag: "card-pool"
            toggleGroupWidth: toggleGroup.width
            toggleGroupHeight: toggleGroup.height
        }
    }
}