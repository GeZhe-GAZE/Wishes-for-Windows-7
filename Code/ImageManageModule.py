r"""
Wishes v3.0
-----------

Module
_
    ImageManageModule

Description
_
    Wishes 图像管理模块

    注: QML 中使用 ImageManager 提供的绝对路径需要添加 file:/// 前缀
"""


import os
import json
from Const import *


class ProfessionImageManager:
    def __init__(self, config_file: str):
        with open(config_file, 'r', encoding='utf-8') as f:
            self.config = json.load(f)

    def get_path(self, game: str, profession: str) -> str:
        if game not in self.config:
            raise ValueError(f'ProfessionImageManager: 游戏 {game} 不存在')
        if profession not in self.config[game]:
            raise ValueError(f'ProfessionImageManager: 职业 {profession} 不存在')
        path = "/".join([BASE_DIR, self.config[game][profession]])
        if not os.path.exists(path):
            raise FileNotFoundError(f'ProfessionImageManager: 职业 {profession} 的图像文件不存在: {path}')
        return path


class AttributeImageManager:
    def __init__(self, config_file: str):
        with open(config_file, 'r', encoding='utf-8') as f:
            self.config = json.load(f)

    def get_path(self, game: str,  attribute: str) -> str:
        if game not in self.config:
            raise ValueError(f'AttributeImageManager: 游戏 {game} 不存在')
        if attribute not in self.config[game]:
            raise ValueError(f'AttributeImageManager: 属性 {attribute} 不存在')
        path = os.path.join(BASE_DIR, self.config[game][attribute])
        if not os.path.exists(path):
            raise FileNotFoundError(f'AttributeImageManager: 属性 {attribute} 的图像文件不存在: {path}')
        return path
