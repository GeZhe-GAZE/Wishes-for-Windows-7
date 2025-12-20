import QtQuick 2.15
import QtQuick.Window 2.5
import "../Theme"
import "../Base"
import "../Controls"

Window {
    id: root
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowSystemMenuHint
    color: "transparent"

    property var rootWindow: undefined

    readonly property alias background: background
    readonly property alias overlay: overlay
    readonly property alias resizeItem: resizeItem

    property int radius: 10
    property var cornersRadius: [radius, radius, radius, radius]
    property var oriCornersRadius: undefined

    property real stayY: (Screen.height - height) / 2

    property bool isOverlay: false

    property bool oriIsMaximized: false

    property bool busy: false

    property int normalWidth: 0
    property int normalHeight: 0

    property real padding: 8

    function open() {
        if (rootWindow) {
            x = rootWindow.x + (rootWindow.width - width) / 2
            stayY = rootWindow.y + (rootWindow.height - height) / 2
        } else {
            x = (Screen.width - width) / 2
            stayY = (Screen.height - height) / 2
        }
        openAnimation.restart()
    }

    function end() {
        endAnimation.restart()
    }

    onVisibilityChanged: (visibilty) => {
        if (visibility == Window.Maximized || visibility == Window.FullScreen) {
            oriCornersRadius = cornersRadius
            cornersRadius = [0, 0, 0, 0]
        } else {
            if (oriCornersRadius) {
                cornersRadius = oriCornersRadius
            }
        }
        if (visibility == Window.Windowed) {
            if (oriIsMaximized) {
                showMaximized()
                oriIsMaximized = false
            }
            normalWidth = width
            normalHeight = height
        }
    }

    WRectangle {
        id: overlay
        visible: root.isOverlay
        z: 10000
        anchors.fill: parent
        cornersRadius: root.cornersRadius
        color: "black"
        opacity: 0.3
    }

    // DropShadow {
    //     id: backgroundShadow
    //     anchors.fill: background
    //     source: background
    //     horizontalOffset: 3
    //     verticalOffset: 3
    //     color: "#000000"
    //     opacity: 0.3
    // }

    WRectangle {
        id: background
        anchors.fill: parent
        cornersRadius: root.cornersRadius
        color: WishesTheme.current.backgroundColor
    }

    ResizeItem {
        id: resizeItem
        z: 10001
        anchors.fill: parent
        areaWidth: root.padding
        target: root
        enabled: root.visibility != Window.Maximized && root.visibility != Window.FullScreen
        minimumWidth: root.minimumWidth
        minimumHeight: root.minimumHeight
    }

    ParallelAnimation {
        id: openAnimation

        NumberAnimation {
            target: root
            property: "y"
            duration: 400
            from: root.stayY + 100
            to: root.stayY
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "opacity"
            duration: 400
            from: 0
            to: 1
            easing.type: Easing.OutCubic
        }

        onStarted: {
            root.show()
            if (root.rootWindow) {
                root.rootWindow.isOverlay = true
            }
            root.busy = true
        }

        onStopped: {
            root.busy = false
        }
    }

    ParallelAnimation {
        id: endAnimation

        NumberAnimation {
            target: root
            property: "y"
            duration: 350
            to: root.y - 100
            easing.type: Easing.InCubic
        }

        NumberAnimation {
            target: root
            property: "opacity"
            duration: 350
            to: 0
            easing.type: Easing.InCubic
        }

        onStarted: {
            root.busy = true
        }

        onStopped: {
            root.close()
            if (root.rootWindow) {
                root.rootWindow.isOverlay = false
            }
            root.busy = false
        }
    }
}
