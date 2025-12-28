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

    property real padding: 5
    property real spacing: 5
    property real buttonWidth: 100
    property real buttonRadius: 5

    property string fontFamily: WishesTheme.fontFamily
    property bool fontBold: false
    property int fontPointSize: 15

    property ListModel model: ListModel {
        // string tag
    }
    property string currentTag: ""

    property bool uncheckByMouse: false

    function _uncheck() {
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).tag != currentTag) {
                repeater.itemAt(i).uncheck()
            }
        }
    }

    ScrollView {
        id: view
        anchors.fill: parent
        anchors.margins: root.padding

        Row {
            spacing: root.spacing
            height: view.height
            Repeater {
                id: repeater
                model: root.model

                ToggleTextButton {
                    required property string tag

                    height: view.height
                    width: root.buttonWidth
                    radius: root.buttonRadius
                    text: tag
                    
                    fontFamily: root.fontFamily
                    fontPointSize: root.fontPointSize
                    fontBold: root.fontBold

                    uncheckable: root.uncheckByMouse

                    onToggled: {
                        root.currentTag = tag
                        root._uncheck()
                    }

                    onUncheckedByMouse: {
                        root.currentTag = ""
                    }
                }
            }
        }
    }
}