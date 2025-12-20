import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: root
    x: (Screen.width - width) / 2
    y: yShow
    visible: false

    color: "transparent"
    flags: Qt.ToolTip | Qt.WindowStaysOnTopHint

    property alias title: titleMsg.text
    property alias text: msg.text
    property int fontSize: 23
    property bool isShow: false

    property string messageImageSuccessSource: "../Images/suc_msg_box_success.png"
    property string messageImageInfoSource: "../Images/suc_msg_box_info.png"
    property string messageImageErrorSource: "../Images/suc_msg_box_error.png"

    // 提示类型枚举
    enum Hints {
        INFO = 1,
        SUCCESS = 2,
        ERROR = 3
    }

    property int hint: SucMessageBox.Hints.INFO

    // 位置与偏移
    property real yFrom: yStay + yOffset  // 起始
    property real yStay: (Screen.height - height) / 2  // 停留
    property real yTo: yStay - yOffset  // 结束
    property real yShow: yFrom  // 当前
    property real yOffset: 80  // 偏移

    Rectangle {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        color: {
            switch (root.hint) {
            case SucMessageBox.Hints.INFO:
                return "#f0f9ff"
            case SucMessageBox.Hints.SUCCESS:
                return "#f0f9eb"
            case SucMessageBox.Hints.ERROR:
                return "#fef0f0"
            default:
                return "#f0f9ff"
            }
        }
        border.color: root.hint & SucMessageBox.Hints.INFO ? "#d6f4ff" :
                      root.hint & SucMessageBox.Hints.SUCCESS ? "#e1f3d8" : "#fde2e2"
        radius: 8
    }

    Image {
        id: img
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        source: {
            switch (root.hint) {
            case SucMessageBox.Hints.INFO:
                return root.messageImageInfoSource
            case SucMessageBox.Hints.SUCCESS:
                return root.messageImageSuccessSource
            case SucMessageBox.Hints.ERROR:
                return root.messageImageErrorSource
            default:
                return root.messageImageInfoSource
            }
        }
        width: 35
        height: 35
    }

    Text {
        id: titleMsg
        anchors {
            verticalCenter: parent.verticalCenter
            left: img.right
            leftMargin: 10
        }
        color: {
            switch (root.hint) {
            case SucMessageBox.Hints.INFO:
                return "#1296db"
            case SucMessageBox.Hints.SUCCESS:
                return "#24cc2c"
            case SucMessageBox.Hints.ERROR:
                return "#e3422d"
            default:
                return "#1296db"
            }
        }
        font {
            family: "Microsoft YaHei"
            pixelSize: root.fontSize
            bold: true
        }
        textFormat: Text.Normal
    }

    Text {
        id: msg
        anchors {
            verticalCenter: parent.verticalCenter
            left: titleMsg.right
            leftMargin: 10
        }
        color: {
            switch (root.hint) {
            case SucMessageBox.Hints.INFO:
                return "#1296db"
            case SucMessageBox.Hints.SUCCESS:
                return "#24cc2c"
            case SucMessageBox.Hints.ERROR:
                return "#e3422d"
            default:
                return "#1296db"
            }
        }
        font {
            family: "Microsoft YaHei"
            pixelSize: root.fontSize
        }
        textFormat: Text.Normal
    }

    SequentialAnimation {
        id: sequential
        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                from: 0.1
                to: 1
                duration: 350
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: root
                property: "yShow"
                from: root.yFrom
                to: root.yStay
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        NumberAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: 2500
        }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                to: 0.1
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: root
                property: "yShow"
                to: root.yTo
                duration: 400
                easing.type: Easing.InCubic
            }
        }

        onStarted: {
            root.isShow = true
        }

        // Qt Creator 错误提示以下onFinished信号不存在，实际存在
        onStopped: {
            root.close()
            root.isShow = false
        }
    }

    function pop(tipHint, titleText, tipText) {
        if (isShow) return

        root.hint = tipHint
        root.title = titleText
        root.text = tipText
        root.width = img.implicitWidth + titleMsg.implicitWidth + msg.implicitWidth <= 350 ?
                350 : titleMsg.implicitWidth + msg.implicitWidth + 80
        root.height = titleMsg.implicitHeight + 20
        background.width = width
        background.height = height
        root.opacity = 0.1
        root.show()
        sequential.start()
    }
}

