pragma Singleton

import QtQuick 2.15
import Wishes 1.0


QtObject {
    id: aboutInfo

    property string url1: "https://github.com/GeZhe-GAZE/Wishes-for-Windows-7"
    property string url2: "https://www.iconfont.cn"
    property string url3: "https://atelier-anchor.com/typefaces/smiley-sans"

    property string intro1: "Wishes 是一个完全开源、免费的模拟游戏抽卡工具，提供高自定义化的抽卡模拟。使用 Python 和 PySide2 (Qt5) 开发。"
    property string intro2: "开源地址: <a href=" + url1 + ">" + url1 + "</a>"
    property string intro3: "当前版本: v" + backend.version

    property string copyright1: "Wishes 本体遵循 MIT 开源协议。"
    property string copyright2: "Wishes 的图标由 <a href=" + url2 + ">Iconfont</a> 提供。"
    property string copyright3: "Wishes 的部分内置图片资源来源于「原神」、「崩坏星穹铁道」、「绝区零」©miHoYo 上海米哈游铁影科技有限公司 版权所有。"
    property string copyright4: "Wishes 的默认字体是 「得意黑」(Smiley Sans) ©atelierAnchor <a href=" + url3 + ">" + url3 + "</a>"
    property string copyright5: "Wishes 代码完全开源。产生的所有数据均保存于用户本地。"
    property string copyright6: "仅作个人学习交流使用，请勿用于任何商业或违法违规用途。"

    property string authorCopyright: "© 2025 - 2026 GeZhe-GAZE. All Rights Reserved."
}