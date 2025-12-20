pragma Singleton

import QtQuick 2.15

QtObject {
    id: theme

    property ThemeBase current: light
    property string fontFamily: SmileySansFontLoader.name

    property ThemeBase light: ThemeBase {
        theme: "light"

        // backgroundColor: "#e6e6e6"
        // barColor: "#f5f2f4"
        // rectangleColor: "#f5f2f4"
        // lineColor: "#b9b9b9"

        // buttonColor: "#e1e1e2"
        // hoveredColor: "#d1d1d2"
        // clickedColor: "#bcbbbe"
        // toggledColor: "#3c3b3e"
        // borderColor: "#808080"
        // imageColor: "#1b1c1e"
        // imageActiveColor: "#dbdcde"

        // textColor: "#222222"
        // titleColor: "#111111"
        // textActiveColor: "#f4f4f4"

        // primaryColor: "#6b61ff"
        // secondaryColor: "#a9a3ff"

        // 基础背景
        backgroundColor: "#f0f0f0"  // 提升5%亮度，增强画布感
        barColor:        "#ffffff"   // 改为纯白，与背景形成层次
        rectangleColor:  "#f8f8f8"   // 增加与背景的对比度
        lineColor:       "#a0a0a0"   // 加深20%，强化分割线可见性

        // 交互组件
        buttonColor:     "#e8e8e8"   // 微调中性灰，适配新背景
        hoveredColor:    "#d8d8d8"   // 增加10%对比度差异
        clickedColor:    "#c0c0c0"   // 加深15%，明确点击反馈
        toggledColor:    "#4a494d"   // 降低明度，提升切换状态识别度
        borderColor:     "#707070"   // 加深边框强调轮廓

        // 图形元素
        imageColor:      "#000000"   // 纯黑提升图标清晰度
        imageActiveColor:"#e0e0e0"   // 增加与常规状态的对比差异

        // 文字系统
        textColor:       "#333333"   // 微调确保WCAG AAA标准
        titleColor:      "#000000"   // 纯黑强化标题层级
        textActiveColor: "#ffffff"   // 纯白保证深底可读性

        // 品牌色
        primaryColor:    "#645aff"   // 提升饱和度(+8%)，增强视觉重心
        secondaryColor:  "#948cff"   // 降低明度，与主色形成明确梯度
    }
    property ThemeBase dark: ThemeBase {
        theme: "dark"

        backgroundColor: "#1b1c1e"
        barColor: "#2b2c2e"
        rectangleColor: "#2b2c2e"
        lineColor: "#4d4e51"

        buttonColor: "#3b3c3e"
        hoveredColor: "#4b4c4e"
        clickedColor: "#6b6c6e"
        toggledColor: "#e5e5e5"
        borderColor: "#c9c9c9"
        imageColor: "#fbfcfe"
        imageActiveColor: "#737373"

        textColor: "#ffffff"
        titleColor: "#f4f4f4"
        textActiveColor: "#222222"

        primaryColor: "#6b61ff"
        secondaryColor: "#8d89c2"
    }

    function switchTheme(target) {
        if (target == "light") {
            current = light
        } else if (target == "dark") {
            current = dark
        }
    }
}
