import QtQuick 2.15
import QtQuick.Window 2.15
import "../WishesUI/Base"
import "../WishesUI/Wishes"
import "../WishesUI/Window"
import "../WishesUI/Theme"

Window {
    id: main

    title: "Wishes v" + backend.version

    width: UIConfig.windowLoadingWidth
    height: UIConfig.windowLoadingHeight

    onWidthChanged: {
        console.log("W", width)
    }

    onHeightChanged: {
        console.log("H", height)
    }

    Component.onCompleted: {
        show()
        mainPageLoader.source = "../WishesUI/Wishes/WishesMain.qml"
        loadTimer.start()
    }

    Connections {
        target: backend
        function onErrorHappened(type, details) {
            console.log(type, details)
            errorTip.pop(type, details)
        }
    }

    ErrorTipWindow {
        id: errorTip
    }

    SucMessageBox {
        id: sucMsgBox
    }

    Loader {
        id: mainPageLoader
        opacity: 0.0
        anchors.fill: parent
    }

    WishesSplashScreen {
        id: splash
        anchors.fill: parent
    }

    Timer {
        id: loadTimer
        interval: 200
        repeat: true

        onTriggered: {
            if (mainPageLoader.status == Loader.Ready && splash.isAnimationFinished) {
                splash.visible = false
                main.width = UIConfig.windowNormalWidth
                main.height = UIConfig.windowNormalHeight
                mainPageLoader.opacity = 1.0
                main.x = (Screen.width - main.width) / 2
                main.y = (Screen.height - main.height) / 2
                loadTimer.stop()
                //errorTip.pop("Test", "content")
                //sucMsgBox.pop(SucMessageBox.Hints.SUCCESS, "测试成功信息", "")

                main.minimumWidth = UIConfig.windowMinWidth
                main.minimumHeight = UIConfig.windowMinHeight
            }
        }
    }
}