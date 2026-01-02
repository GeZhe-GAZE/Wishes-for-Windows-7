pragma Singleton

import QtQuick 2.15

QtObject {
    id: config

    property int windowLoadingWidth: 480
    property int windowLoadingHeight: 330

    property int windowNormalWidth: 1080
    property int windowNormalHeight: 720

    property int windowMinWidth: 910
    property int windowMinHeight: 660

    property int errorTipWidth: 480
    property int errorTipHeight: 360
}
