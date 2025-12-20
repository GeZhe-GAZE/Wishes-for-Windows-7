import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import "../Theme"
import "../Base"
import "../Window"

Item {
    id: root
    clip: true

    //property WishesWindow window

    property bool isAnimationFinished: false

    Component.onCompleted: {
        animation.start()
    }

    ParallelAnimation {
        id: animation

        NumberAnimation {
            target: bgTitle.anchors
            property: "margins"
            from: -20
            to: 0
            duration: 2000
            easing.type: Easing.OutQuad
        }

        onStopped: {
            root.isAnimationFinished = true
        }
    }

    WRectangle {
        id: bg
        anchors.fill: parent
        gradStartColor: "#f8dcfe"
        gradEndColor: "#b3d7ff"
    }

    Text {
        id: bgTitle
        anchors {
            left: root.left
            bottom: root.bottom
        }
        text: "Wishes"
        color: "white"
        font {
            pointSize: 300
            bold: true
            family: WishesTheme.fontFamily
        }
        opacity: 0.4
    }

    DropShadow {
        id: titleShadow
        anchors.fill: title
        source: title
        color: WishesTheme.current.shadowColor
        radius: 10
        samples: 20
        verticalOffset: 5
        horizontalOffset: 5
        opacity: WishesTheme.current.shadowOpacity
    }

    Text {
        id: title
        anchors.centerIn: parent
        text: "Wishes v3.0"
        color: "black"
        font {
            pointSize: 60
            bold: true
            family: WishesTheme.fontFamily
        }
    }

    BusyIndicator {
        id: loadIndicator
        anchors {
            bottom: root.bottom
            bottomMargin: 20
            horizontalCenter: root.horizontalCenter
        }
        running: true
        palette.dark: "white"
    }
}
