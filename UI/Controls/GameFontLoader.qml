pragma Singleton

import QtQuick 2.15

Item {
    id: root

    function getFont(game) {
        switch (game) {
            case "Genshin":
                return genshinFontLoader.name
            case "StarRail":
                return starRailFontLoader.name
            case "ZZZ":
                return zzzFontLoader.name
            default:
                return genshinFontLoader.name
        }
    }

    FontLoader {
        id: genshinFontLoader
        source: "../../Fonts/汉仪文黑-85W.ttf"
    }

    FontLoader {
        id: starRailFontLoader
        source: "../../Fonts/汉仪圆润-75W.ttf"
    }

    FontLoader {
        id: zzzFontLoader
        source: "../../Fonts/印品鸿蒙体.ttf"
    }
}