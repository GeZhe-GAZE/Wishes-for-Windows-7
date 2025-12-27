r"""
Wishes v3.0
-----------

Module
_
    GameAdaptationModule

Description
_
    Wishes 游戏适配模块
    用于对不同游戏的适配
    * Wishes 的游戏适配性指的是 对不同游戏的机制的适配程度 和 跨游戏的泛用性
"""


from typing import Dict
import json


class StarRarityAdapter:
    """
    星级-稀有度适配器
    Wishes 内部使用整数的星级标定不同卡片的稀有度，星级越高，稀有度越高
    为满足部分游戏使用字符串标定稀有度的设定(如: "SSR", "SR", "S", "A", "B", "C"等)
    本适配器提供不同游戏内部的 星级-稀有度 映射功能
    所有游戏的 星级-稀有度 映射在 Data/Config/StarRarityMap.json 中定义
    *本适配器内部使用字符串类型的星级，以方便 json 文件解析
    """
    def __init__(self, config_file: str):
        self.config_file = config_file

        # 管理层级: 游戏 -> 星级(字符串) -> 稀有度映射
        self.star_rarity_map: Dict[str, Dict[str, Dict]] = {}
        self.load()

    def load(self):
        """
        加载星级-稀有度映射
        """
        with open(self.config_file, "r", encoding="utf-8") as f:
            self.star_rarity_map = json.load(f)

    def get_rarity(self, game: str, star: int) -> str:
        """
        获取星级对应的稀有度映射
        """
        if game not in self.star_rarity_map:
            raise ValueError(f"StarRarityAdapter.get_rarity: 游戏 '{game}' 不存在")
        if str(star) not in self.star_rarity_map[game]:
            return str(star)
        return self.star_rarity_map[game][str(star)]["map"]
    
    def get_color(self, game: str, star: int) -> str:
        """
        获取星级对应的代表色
        """
        if game not in self.star_rarity_map:
            raise ValueError(f"StarRarityAdapter.get_color: 游戏 '{game}' 不存在")
        if str(star) not in self.star_rarity_map[game]:
            return "blue"
        return self.star_rarity_map[game][str(star)]["color"]
    
    def check_using_star(self, game: str, star: int) -> bool:
        """
        是否使用星级表示稀有度
        """
        if game not in self.star_rarity_map:
            raise ValueError(f"StarRarityAdapter.check_using_star: 游戏 '{game}' 不存在")
        if str(star) not in self.star_rarity_map[game]:
            return True
        return self.star_rarity_map[game][str(star)]["using_star"]

    def add_rarity(self, game: str, star: int, rarity: str):
        """
        添加 星级-稀有度 映射
        """
        if game not in self.star_rarity_map:
            self.star_rarity_map[game] = {}
        self.star_rarity_map[game][str(star)] = rarity
    
    def remove_rarity(self, game: str, star: int):
        """
        删除 星级-稀有度 映射
        """
        if game not in self.star_rarity_map:
            return
        if star not in self.star_rarity_map[game]:
            return
        del self.star_rarity_map[game][star]
    