import QtQuick 2.15

QtObject {
    required property string theme              // 主题名称

    required property color backgroundColor     // 背景色
    required property color barColor            // 标题栏/侧边栏背景色
    required property color rectangleColor      // 矩形背景色
    required property color lineColor           // 线条颜色
    required property color shadowColor         // 阴影颜色

    required property double shadowOpacity      // 阴影透明度

    required property color buttonColor         // 按钮背景色
    required property color hoveredColor        // 按钮悬停背景色
    required property color clickedColor        // 按钮点击背景色
    required property color toggledColor        // 按钮选中状态背景色
    required property color borderColor         // 描边颜色
    required property color imageColor          // 图片颜色
    required property color imageActiveColor    // 图片激活颜色

    required property color textColor           // 文字颜色
    required property color titleColor          // 标题颜色
    required property color textActiveColor     // 文字激活颜色

    required property color primaryColor        // 强调色
    required property color secondaryColor      // 次强调色
}
