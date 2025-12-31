import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Controls"
import "../../WishesUI/Theme"

Item {
    id: root

    // Text {
    //     text: "About Page"
    //     anchors.centerIn: parent
    //     color: WishesTheme.current.titleColor
    //     font {
    //         pointSize: 50
    //         bold: true
    //         family: WishesTheme.fontFamily
    //     }
    // }

    // Image {
    //     anchors.centerIn: parent
    //     width: 100
    //     height: 100
    //     fillMode: Image.PreserveAspectFit
    //     source: "../../logos/Qt-PySide2-badge.svg"
    // }

    Badge {
        id: qtPySide2Badge
        textL: "Qt"
        textR: "PySide2"

        boldR: true
        boldL: true

        height: 20
        colorR: "green"

        colorRDarker: 1.1

        url: "https://pypi.org/project/PySide2/"
    }
}