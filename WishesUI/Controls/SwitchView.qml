import QtQuick 2.15
import "../Base"
import "../Theme"

Item {
    id: root

    readonly property alias background: background

    default property alias content: container.children

    property real contentPadding: 0

    property int currentIndex: -1
    property bool busy: false

    property Item currentItem: Item {}
    property Item nextItem: Item {}

    property string initTag: ""
    property string currentTag: ""

    readonly property real contentWidth: container.width
    readonly property real contentHeight: container.height

    property int animationInterval: 100
    property int animationInDuration: 200
    property int animationOutDuration: 200

    property real animationInOffset: 100
    property real animationOutOffset: -100

    property bool verticalAnimation: true

    clip: true

    function stop() {
        animationOut.stop()
        pauseTimer.stop()
        animationIn.stop()
        busy = false
    }

    function switchTag(tag) {
        if (busy) return
        var index = 0
        for (let i = 0; i < content.length;i++) {
            var item = content[i]
            if (item.tag == tag) {
                nextItem = item
                currentTag = tag
                index = i
                break
            }
        }
        if (nextItem == currentItem) return
        animationOut.start()
        currentIndex = index
    }

    function switchItem(index) {
        if (busy) return
        if (!(0 <= index < content.length)) return
        nextItem = content[index]
        if (nextItem == currentItem) return
        animationOut.start()
        currentIndex = index
        if (nextItem.tag) {
            currentTag = nextItem.tag
        }
    }

    Component.onCompleted: {
        switchTag(initTag)
    }

    WRectangle {
        id: background
        anchors.fill: parent
        color: WishesTheme.current.backgroundColor
    }

    Item {
        id: container
        anchors.fill: parent
        anchors.margins: root.contentPadding

        onChildrenChanged: {
            if (children.length > 0) {
                var child = children[children.length - 1]
                child.visible = false
                child.x = 0
                child.y = 0
            }
        }

        onWidthChanged: {
            for (var index = 0; index < children.length; index++) {
                var item = children[index]
                item.width = width
            }
            // children.forEach(function(item, index) {
            //     item.width = width
            // })
        }

        onHeightChanged: {
            for (var index = 0; index < children.length; index++) {
                var item = children[index]
                item.height = height
            }
            // children.forEach(function(item, index) {
            //     item.height = height
            // })
        }
    }

    Timer {
        id: pauseTimer
        interval: root.animationInterval
        repeat: false

        onTriggered: {
            animationIn.start()
        }
    }

    ParallelAnimation {
        id: animationOut

        NumberAnimation {
            target: root.currentItem
            property: "opacity"
            to: 0
            duration: root.animationOutDuration
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: root.currentItem
            property: root.verticalAnimation ? "y" : "x"
            to: root.animationOutOffset
            duration: root.animationOutDuration
            easing.type: Easing.InOutQuad
        }

        onStarted: {
            root.busy = true
            pauseTimer.start()
        }
    }

    ParallelAnimation {
        id: animationIn

        NumberAnimation {
            target: root.nextItem
            property: "opacity"
            from: 0
            to: 1
            duration: root.animationInDuration
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: root.nextItem
            property: root.verticalAnimation ? "y" : "x"
            from: root.animationInOffset
            to: 0
            duration: root.animationInDuration
            easing.type: Easing.InOutQuad
        }

        onStarted: {
            root.nextItem.visible = true
        }

        onStopped: {
            root.busy = false
            root.currentItem.visible = false
            root.currentItem = root.nextItem
        }
    }
}
