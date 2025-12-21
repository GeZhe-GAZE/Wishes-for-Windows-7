import QtQuick 2.15
import "../Base"
import "../Button"
import "../../UI/Pages"
import "../Theme"
import "../Controls"

Item {
    id: root

    function switchToPage(page) {
        if (page == "wish") {
            wishPage.visible = true
            toWishAnimation.start()
        } else if (page == "main") {
            switchView.visible = true
            toMainAnimation.start()
        }
    }

    WishPage {
        id: wishPage
        visible: false
        x: 0
        y: root.height
        z: 10
        width: parent.width
        height: parent.height

        onReturnToMain: {
            root.switchToPage("main")
        }
    }

    ParallelAnimation {
        id: toWishAnimation
        property int duration: 400

        NumberAnimation {
            target: wishPage
            property: "y"
            from: root.height
            to: 0
            duration: toWishAnimation.duration
            easing.type: Easing.OutQuad
        }

        onStopped: {
            switchView.visible = false
        }
    }

    ParallelAnimation {
        id: toMainAnimation
        property int duration: 400

        NumberAnimation {
            target: wishPage
            property: "y"
            from: 0
            to: root.height
            duration: toMainAnimation.duration
            easing.type: Easing.InQuad
        }

        onStopped: {
            wishPage.visible = false
            switchView.visible = true
            switchView.switchTag("main")
        }
    }

    WRectangle {
        id: pageBackground
        color: WishesTheme.current.backgroundColor
        anchors.fill: parent
        cornersRadius: [50, 0, 0, 0]
    }

    NavigationBar {
        id: navigationBar
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: 60
        layoutWeights: [1, 2, 1]

        initTag: "main"

        topButtonList: ListModel {
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/main.png"; tag: "main"; text: "首页"}
        }

        centerButtonList: ListModel {
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/management.svg"; tag: "management"; text: "管理"}
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/records.svg"; tag: "records"; text: "抽卡记录"}
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/analysis.svg"; tag: "analysis"; text: "抽卡分析"}
        }

        bottomButtonList: ListModel {
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/settings.png"; tag: "settings"; text: "设置"}
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/appearance.png"; tag: "appearance"; text: "外观"}
            ListElement {imageSource_: "../../UI/Icons/NavigationBar/about.png"; tag: "about"; text: "关于"}
        }

        onCurrentTagChanged: {
            switchView.switchTag(currentTag)
        }
    }

    SwitchView {
        id: switchView
        anchors {
            top: parent.top
            right: parent.right
            bottom:parent.bottom
            left: navigationBar.right
            margins: 20
        }
        background.visible: false

        initTag: "main"

        MainPage {
            id: mainPage
            // width: parent.width
            // height: parent.height
            property string tag: "main"

            onCardPoolSwitched: (cardPool) => {
                root.switchToPage("wish")
                wishPage.currentCardPool = cardPool
            }
        }

        ManagementPage {
            id: managementPage
            property string tag: "management"
        }

        RecordsPage {
            id: recordsPage
            property string tag: "records"
        }

        AnalysisPage {
            id: analysisPage
            property string tag: "analysis"
        }

        SettingsPage {
            id: settingsPage
            property string tag: "settings"
        }

        AppearancePage {
            id: appearancePage
            property string tag: "appearance"
        }

        AboutPage {
            id: aboutPage
            property string tag: "about"
        }
    }

    // Item {
    //     id: mainAndWishGroup
    //     property Item current: mainPage
    //     anchors {
    //         top: parent.top
    //         right: parent.right
    //         bottom:parent.bottom
    //         left: navigationBar.right
    //     }

    //     function switchTo(page) {
    //         if (page == wishPage) {
    //             mainPage.visible = true
    //             wishPage.visible = true
    //             mainToWishAnimation.start()
    //         } else if (page == mainPage) {
    //             mainPage.visible = true
    //             wishPage.visible = true
    //             wishToMainAnimation.start()
    //         }
    //     }

    //     ParallelAnimation {
    //         id: mainToWishAnimation
    //         property int duration: 400
    
    //         NumberAnimation {
    //             target: wishPage
    //             property: "y"
    //             from: wishPage.height
    //             to: 0
    //             duration: mainToWishAnimation.duration
    //             easing.type: Easing.OutQuad
    //         }

    //         onStopped: {
    //             mainPage.visible = false
    //         }
    //     }

    //     ParallelAnimation {
    //         id: wishToMainAnimation
    //         property int duration: 400
    
    //         NumberAnimation {
    //             target: wishPage
    //             property: "y"
    //             from: 0
    //             to: wishPage.height
    //             duration: wishToMainAnimation.duration
    //             easing.type: Easing.InQuad
    //         }

    //         onStopped: {
    //             wishPage.visible = false
    //         }
    //     }

    //     // WishPage {
    //     //     id: wishPage
    //     //     visible: false
    //     //     x: 0
    //     //     y: -height
    //     //     width: parent.width
    //     //     height: parent.height

    //     //     onReturnToMain: {
    //     //         parent.switchTo(mainPage)
    //     //     }
    //     // }
    // }
}
