import QtQuick 2.15
import QtQuick.Controls 2.15
import Wishes 1.0
import "../../WishesUI/Base"
import "../../WishesUI/Button"
import "../../WishesUI/Controls"
import "../../WishesUI/Theme"
import "../../WishesUI/Font"

Item {
    id: root

    Item {
        id: topArea
        height: 128
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Image {
            id: logo
            source: "../../logos/Wishes-icon-white-gradient-512x512.png"
            anchors {
                top: parent.top
                left: parent.left
            }
            width: 128
            height: 128
        }

        Text {
            id: title
            text: "Wishes"
            font {
                pixelSize: 100
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.titleColor
            anchors {
                verticalCenter: logo.verticalCenter
                left: logo.right
                leftMargin: 32
            }
        }

        Text {
            id: versionText
            text: "v" + backend.version
            font {
                pixelSize: 30
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.titleColor
            anchors {
                bottom: title.bottom
                left: title.right
                leftMargin: 8
                bottomMargin: 12
            }
        }
    }

    Row {
        id: badgeRow
        anchors {
            top: topArea.bottom
            topMargin: 10
            left: parent.left
            right: parent.right
        }
        height: 30
        spacing: 10

        Badge {
            height: parent.height
            textL: "Python"
            colorL: "#3776AB"
            logo: "../../logos/python.svg"
            logoColor: "white"
            url: "https://www.python.org"
        }

        Badge {
            height: parent.height
            textL: "Qt"
            textR: "PySide2"
            colorR: "#41CD52"
            logo: "../../logos/qt.svg"
            logoColor: "white"
            url: "https://www.pypi.org/project/PySide2"
        }

        Badge {
            height: parent.height
            textL: "JSON"
            colorL: "#000000"
            logo: "../../logos/json.png"
            logoColor: "white"
            url: "https://www.json.org"
        }

        Badge {
            height: parent.height
            textL: "git"
            colorL: "#F05032"
            logo: "../../logos/git.svg"
            logoColor: "white"
            url: "https://git-scm.com"
        }
    }

    Rectangle {
        id: titleLine
        anchors {
            top: badgeRow.bottom
            topMargin: 10
            left: parent.left
            right: parent.right
        }
        radius: height / 2
        height: 2
        color: WishesTheme.current.lineColor
    }

    Item {
        id: introInfoArea
        anchors {
            top: titleLine.bottom
            topMargin: 10
            left: parent.left
            right: parent.right
        }
        height: 100

        Text {
            id: fixedText1
            text: "简介"
            width: 100
            anchors {
                top: parent.top
                left: parent.left
            }
            font {
                pixelSize: 40
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            id: introLine
            anchors {
                top: parent.top
                left: fixedText1.right
                leftMargin: 10
            }
            height: parent.height
            radius: width / 2
            width: 2
            color: WishesTheme.current.lineColor
        }

        Text {
            id: introText1
            anchors {
                top: parent.top
                left: introLine.right
                leftMargin: 10
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            text: AboutInfo.intro1
            wrapMode: Text.WordWrap
        }

        Text {
            id: introText2
            anchors {
                top: introText1.bottom
                left: introText1.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            textFormat: Text.RichText
            color: WishesTheme.current.textColor
            text: AboutInfo.intro2
            wrapMode: Text.WordWrap
            onLinkActivated: {
                Qt.openUrlExternally(AboutInfo.url1)
            }
        }

        Text {
            id: introText3
            anchors {
                top: introText2.bottom
                left: introText2.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            text: AboutInfo.intro3
            wrapMode: Text.WordWrap
        }
    }

    Item {
        id: copyrightInfoArea
        anchors {
            top: introInfoArea.bottom
            topMargin: 10
            left: parent.left
            right: parent.right
        }
        height: 200

        Text {
            id: fixedText2
            text: "版权\n声明"
            width: 100
            anchors {
                top: parent.top
                left: parent.left
            }
            font {
                pixelSize: 40
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            id: copyrightLine
            anchors {
                top: parent.top
                left: fixedText2.right
                leftMargin: 10
            }
            height: parent.height
            radius: width / 2
            width: 2
            color: WishesTheme.current.lineColor
        }

        Text {
            id: copyrightText1
            anchors {
                top: parent.top
                left: copyrightLine.right
                leftMargin: 10
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            text: AboutInfo.copyright1
            wrapMode: Text.WordWrap
        }

        Text {
            id: copyrightText2
            anchors {
                top: copyrightText1.bottom
                left: copyrightText1.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            textFormat: Text.RichText
            color: WishesTheme.current.textColor
            text: AboutInfo.copyright2
            wrapMode: Text.WordWrap
            onLinkActivated: {
                Qt.openUrlExternally(AboutInfo.url2)
            }
        }

        Text {
            id: copyrightText3
            anchors {
                top: copyrightText2.bottom
                left: copyrightText2.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            text: AboutInfo.copyright3
            wrapMode: Text.WordWrap
        }

        Text {
            id: copyrightText4
            anchors {
                top: copyrightText3.bottom
                left: copyrightText3.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            textFormat: Text.RichText
            color: WishesTheme.current.textColor
            text: AboutInfo.copyright4
            wrapMode: Text.WordWrap
            onLinkActivated: {
                Qt.openUrlExternally(AboutInfo.url3)
            }
        }

        Text {
            id: copyrightText5
            anchors {
                top: copyrightText4.bottom
                left: copyrightText4.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            text: AboutInfo.copyright5
            wrapMode: Text.WordWrap
        }

        Text {
            id: copyrightText6
            anchors {
                top: copyrightText5.bottom
                left: copyrightText5.left
                right: parent.right
            }
            font {
                pixelSize: 20
                family: SmileySansFontLoader.name
            }
            color: WishesTheme.current.textColor
            text: AboutInfo.copyright6
            wrapMode: Text.WordWrap
        }
    }

    Item {
        id: bottomArea
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: 64 + 30

        Rectangle {
            id: logoRect
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }
            height: 64
            width: 160
            radius: 8
            color: "#2b2c2e"

            Image {
                id: authorLogo
                source: "../../logos/GAZE-logo-line-white-transparent-128x128.png"
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: bottomPartingLine.left
                    rightMargin: 8
                }
                height: 64
                width: height
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }

            Rectangle {
                id: bottomPartingLine
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                color: WishesTheme.current.lineColor
                height: 60
                width: 2
                radius: width / 2
            }

            Image {
                id: qtLogo
                source: "../../logos/Qt-logo-neon-transparent.png"
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: bottomPartingLine.right
                    leftMargin: 8
                }
                height: 64
                width: height
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
        }

        Text {
            id: authorCopyrightText
            text: AboutInfo.authorCopyright
            font {
                family: SmileySansFontLoader.name
                pixelSize: 16
            }
            color: WishesTheme.current.textColor
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
        }
    }
}