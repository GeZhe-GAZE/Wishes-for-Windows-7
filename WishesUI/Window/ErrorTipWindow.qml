import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.0
import "../Theme"
import "../Base"
import "../Button"

Window {
    id: root
    width: UIConfig.errorTipWidth
    height: UIConfig.errorTipHeight
    visible: false
    flags: Qt.FramelessWindowHint
    color: "transparent"

    property int showDuration: 300

    function pop(errorType, details) {
        errorTypeText.text = errorType
        detailsText.text = details
        show()
        showAnimation.start()
    }

    function hideWithAnimation() {
        hideAnimation.start()
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 10
        color: WishesTheme.current.backgroundColor
    }
    
    Text {
        id: titleText
        anchors {
            top: parent.top
            left: parent.left
            margins: 25
        }
        font {
            family: WishesTheme.fontFamily
            pointSize: 35
            bold: true
        }
        text: "发生错误"
        color: WishesTheme.current.titleColor

        DropShadow {
            source: titleText
            anchors.fill: parent
            radius: 8
            samples: 16
            horizontalOffset: 5
            verticalOffset: 5
            color: WishesTheme.current.shadowColor
            opacity: WishesTheme.current.shadowOpacity
        }
    }

    Text {
        id: errorTypeText
        anchors {
            top: titleText.bottom
            left: parent.left
            leftMargin: 25
            topMargin: 20
        }
        font {
            family: WishesTheme.fontFamily
            pointSize: 25
        }
        color: WishesTheme.current.textColor
    }

    Text {
        id: detailsText
        anchors {
            top: errorTypeText.bottom
            left: parent.left
            bottom: closeButton.top
            right: parent.right
            margins: 25
        }
        wrapMode: Text.WordWrap
        font {
            family: WishesTheme.fontFamily
            pointSize: 15
        }
        color: WishesTheme.current.textColor
    }

    TextButton {
        id: closeButton
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 25
        }
        width: 80
        height: 40
        radius: 10
        text: "关闭"
        fontPointSize: 18
        
        onClickedLeft: {
            root.hideWithAnimation()
        }
    }

    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: root.showDuration
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root
            property: "y"
            from: (Screen.height - root.height) / 2 + 100
            to: (Screen.height - root.height) / 2
            duration: root.showDuration
            easing.type: Easing.InOutQuad
        }
    }

    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: root
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: root.showDuration
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root
            property: "y"
            from: (Screen.height - root.height) / 2
            to: (Screen.height - root.height) / 2 - 100
            duration: root.showDuration
            easing.type: Easing.InOutQuad
        }

        onStopped: {
            root.hide()
        }
    }
}