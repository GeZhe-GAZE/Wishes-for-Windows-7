pragma Singleton

import QtQuick 2.15
import "../Font"

Item {
    id: root
    property ThemeBase current: light

    property string fontFamily: SmileySansFontLoader.name

    ThemeBase {
        id: light
        theme: "light"

        // 基础背景
        backgroundColor: "#e6e6e6"
        barColor:        "#f5f2f4"   
        rectangleColor:  "#f5f2f4"   
        lineColor:       "#b9b9b9"   
        shadowColor:     "#3b3c3e"

        shadowOpacity:   0.7

        // 交互组件
        buttonColor:     "#e1e1e2"   
        hoveredColor:    "#d1d1d2"   
        clickedColor:    "#bcbbbe"   
        toggledColor:    "#3c3b3e"   
        borderColor:     "#808080"

        // 图形元素
        imageColor:      "#1b1c1e"   
        imageActiveColor:"#dbdcde"   

        // 文字系统
        textColor:       "#222222"   
        titleColor:      "#111111"   
        textActiveColor: "#f4f4f4"   

        // 品牌色
        primaryColor:    "#6b61ff"   
        secondaryColor:  "#a9a3ff"   

    }

    ThemeBase {
        id: dark
        theme: "dark"

        backgroundColor: "#1b1c1e"
        barColor:        "#2b2c2e"
        rectangleColor:  "#2b2c2e"
        lineColor:       "#4d4e51"
        shadowColor:     "#3b3c3e"

        shadowOpacity:   0.7

        buttonColor:     "#3b3c3e"
        hoveredColor:    "#4b4c4e"
        clickedColor:    "#6b6c6e"
        toggledColor:    "#e5e5e5"
        borderColor:     "#c9c9c9"
        imageColor:      "#fbfcfe"
        imageActiveColor:"#737373"

        textColor:       "#ffffff"
        titleColor:      "#f4f4f4"
        textActiveColor: "#222222"

        primaryColor:    "#6b61ff"
        secondaryColor:  "#8d89c2"
    }

    function switchTheme(target) {
        if (target == "light") {
            current = light
        } else if (target == "dark") {
            current = dark
        }
    }
}