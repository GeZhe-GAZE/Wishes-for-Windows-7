import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Controls"
import "../../WishesUI/Theme"
import "../../UI/GameFonts"

Item {
    id: root

    property real itemRectHeight: 80

    Text {
        id: title
        text: "外观"
        color: WishesTheme.current.titleColor
        anchors {
            top: parent.top
            left: parent.left
        }
        font {
            pointSize: 60
            bold: true
            family: WishesTheme.fontFamily
        }
    }

    Text {
        text: "Appearance"
        color: WishesTheme.current.titleColor
        anchors {
            bottom: title.bottom
            left: title.right
            bottomMargin: 10
            leftMargin: 10
        }
        font {
            pointSize: 30
            bold: true
            family: WishesTheme.fontFamily
        }
    }

    Rectangle {
        id: titleLine
        height: 5
        radius: height / 2
        color: WishesTheme.current.lineColor
        anchors {
            top: title.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
        }
    }

    ScrollView {
        id: view
        anchors {
            top: titleLine.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 10
        }
        clip: true
        //contentHeight: contentLayout.children.length * (root.itemRectHeight + contentLayout.spacing)
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Column {
            id: contentLayout
            width: root.width
            height: 1
            spacing: 10

            WRectangle {
                height: root.itemRectHeight
                width: parent.width
                color: WishesTheme.current.rectangleColor
                radius: height * 0.1

                Text {
                    text: "主题"
                    color: WishesTheme.current.textColor
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                    font {
                        pointSize: 25
                        family: WishesTheme.fontFamily
                    }
                }

                WComboBox {
                    id: themeComboBox
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 10
                    }
                    height: parent.height * 0.8
                    width: 200

                    text {
                        font.pointSize: 18
                    }

                    model: ListModel {
                        ListElement {modelData: "light"}
                        ListElement {modelData: "dark"}
                    }

                    onCurrentTextChanged: {
                        if (currentText === "light") {
                            WishesTheme.switchTheme("light")
                        } else if (currentText === "dark") {
                            WishesTheme.switchTheme("dark")
                        }
                    }

                    Component.onCompleted: {
                        switchItemText("light")
                    }
                }
            }

            WRectangle {
                height: root.itemRectHeight
                width: parent.width
                color: WishesTheme.current.rectangleColor
                radius: height * 0.1

                Text {
                    text: "字体"
                    color: WishesTheme.current.textColor
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                    font {
                        pointSize: 25
                        family: WishesTheme.fontFamily
                    }
                }

                WComboBox {
                    id: fontFamilyComboBox
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 10
                    }
                    height: parent.height * 0.8
                    width: 200

                    text {
                        font.pointSize: 18
                    }

                    model: ListModel {
                        id: fontFamilyList
                    }

                    onCurrentTextChanged: {
                        WishesTheme.fontFamily = currentText
                    }

                    onPopupClicked: {
                        WishesTheme.fontFamily = currentText
                    }

                    Component.onCompleted: {
                        var lst = Qt.fontFamilies()
                        for (var i = 0; i < lst.length; i++) {
                            fontFamilyList.append({modelData: lst[i]})
                        }
                        switchItemText("Smiley Sans")
                    }
                }
            }

            WRectangle {
                width: parent.width
                height: fixedText1.height + gameFontsLayout.height + 20
                radius: 10
                
                Text {
                    id: fixedText1
                    text: "内置游戏字体"
                    color: WishesTheme.current.textColor
                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 10
                    }
                    font {
                        pointSize: 25
                        family: WishesTheme.fontFamily
                    }
                }

                Column {
                    id: gameFontsLayout
                    anchors {
                        top: fixedText1.bottom
                        left: parent.left
                        right: parent.right
                        margins: 5
                    }
                    spacing: 20

                    Item {
                        height: 50
                        width: parent.width

                        Text {
                            text: "原神 - 汉仪文黑-85W"
                            color: WishesTheme.current.textColor
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 10
                            }
                            font {
                                pointSize: 25
                                family: GenshinFontLoader.name
                            }
                        }

                        SwitchButton {
                            id: applyGenshinFontButton
                            anchors {
                                verticalCenter: parent.verticalCenter
                                right: parent.right
                            }
                            height: parent.height * 0.8

                            textOn: "使用中"
                            textOff: "启用"

                            onClicked: {
                                if (isOn) {
                                    WishesTheme.fontFamily = GenshinFontLoader.name
                                } else {
                                    WishesTheme.fontFamily = fontFamilyComboBox.currentText
                                }
                            }

                            Connections {
                                target: WishesTheme
                                function onFontFamilyChanged() {
                                    if (WishesTheme.fontFamily != GenshinFontLoader.name) {
                                        applyGenshinFontButton.uncheck()
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        height: 50
                        width: parent.width

                        Text {
                            text: "崩坏：星穹铁道 - 汉仪润圆-75W"
                            color: WishesTheme.current.textColor
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 10
                            }
                            font {
                                pointSize: 25
                                family: StarRailFontLoader.name
                            }
                        }

                        SwitchButton {
                            id: applyStarRailFontButton
                            anchors {
                                verticalCenter: parent.verticalCenter
                                right: parent.right
                            }
                            height: parent.height * 0.8

                            textOn: "使用中"
                            textOff: "启用"

                            onClicked: {
                                if (isOn) {
                                    WishesTheme.fontFamily = StarRailFontLoader.name
                                } else {
                                    WishesTheme.fontFamily = fontFamilyComboBox.currentText
                                }
                            }

                            Connections {
                                target: WishesTheme
                                function onFontFamilyChanged() {
                                    if (WishesTheme.fontFamily != StarRailFontLoader.name) {
                                        applyStarRailFontButton.uncheck()
                                    }
                                }
                            }
                        }

                        // ToggleTextButton {
                        //     id: applyStarRailFontButton
                        //     text: WishesTheme.fontFamily == StarRailFontLoader.name ?
                        //             "已启用" : "启用"
                        //     anchors {
                        //         verticalCenter: parent.verticalCenter
                        //         right: parent.right
                        //     }
                        //     height: parent.height * 0.8
                        //     width: 100
                        //     radius: 5

                        //     onToggled: {
                        //         WishesTheme.fontFamily = StarRailFontLoader.name
                        //     }

                        //     Connections {
                        //         target: WishesTheme
                        //         function onFontFamilyChanged() {
                        //             if (WishesTheme.fontFamily != StarRailFontLoader.name) {
                        //                 applyStarRailFontButton.uncheck()
                        //             }
                        //         }
                        //     }
                        // }
                    }

                    Item {
                        height: 50
                        width: parent.width

                        Text {
                            text: "绝区零 - 印品鸿蒙体"
                            color: WishesTheme.current.textColor
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 10
                            }
                            font {
                                pointSize: 25
                                family: ZZZFontLoader.name
                            }
                        }

                        SwitchButton {
                            id: applyZZZFontButton
                            anchors {
                                verticalCenter: parent.verticalCenter
                                right: parent.right
                            }
                            height: parent.height * 0.8

                            textOn: "使用中"
                            textOff: "启用"

                            onClicked: {
                                if (isOn) {
                                    WishesTheme.fontFamily = ZZZFontLoader.name
                                } else {
                                    WishesTheme.fontFamily = fontFamilyComboBox.currentText
                                }
                            }

                            Connections {
                                target: WishesTheme
                                function onFontFamilyChanged() {
                                    if (WishesTheme.fontFamily != ZZZFontLoader.name) {
                                        applyZZZFontButton.uncheck()
                                    }
                                }
                            }
                        }

                        // ToggleTextButton {
                        //     id: applyZZZFontButton
                        //     text: WishesTheme.fontFamily == ZZZFontLoader.name ?
                        //             "已启用" : "启用"
                        //     anchors {
                        //         verticalCenter: parent.verticalCenter
                        //         right: parent.right
                        //     }
                        //     height: parent.height * 0.8
                        //     width: 100
                        //     radius: 5

                        //     onToggled: {
                        //         WishesTheme.fontFamily = ZZZFontLoader.name
                        //     }

                        //     Connections {
                        //         target: WishesTheme
                        //         function onFontFamilyChanged() {
                        //             if (WishesTheme.fontFamily != ZZZFontLoader.name) {
                        //                 applyZZZFontButton.uncheck()
                        //             }
                        //         }
                        //     }
                        // }
                    }
                }
            }
        }
    }
}