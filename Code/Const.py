r"""
Wishes v3.0
-----------

Module
_
    Const

Description
_
    Wishes 常量定义
"""
import os

# NOTE: Wishes 基本信息
VERSION = "v3.0.1"

# NOTE: 抽卡部分
MAX_PROBABILITY = 10000

# NOTE: 卡组内卡片分类标签
TAG_UP = "up"               # UP 组
TAG_FES = "fes"             # Fes 组, 包含于 UP 组
TAG_APPOINT = "appoint"     # Appoint (定轨) 组, 包含于 UP 组和 Fes 组
TAG_STANDARD = "standard"   # 常驻组

# NOTE: 记录模块缓存大小
CACHE_SIZE = 10

# NOTE: 路径
BASE_DIR = os.getcwd()                                                                      # 项目根目录
CARDS_DIR = os.path.join(BASE_DIR, r"Data/Cards")                                           # 卡片 配置目录
CARDS_DIR_CONFIG_FILE = os.path.join(BASE_DIR, r"Data/Config/CardsDirConfig.json")          # 卡片目录配置文件
RESIDENT_GROUP_DIR = os.path.join(BASE_DIR, r"Data/StandardGroups")                         # 常驻卡组 配置目录
CARD_GROUP_DIR = os.path.join(BASE_DIR, r"Data/CardGroups")                                 # 卡组 配置目录
LOGIC_CONFIG_DIR = os.path.join(BASE_DIR, r"Data/LogicConfig")                              # 抽卡逻辑 配置目录
CARD_POOL_DIR = os.path.join(BASE_DIR, r"Data/CardPools")                                   # 卡池 配置目录
STAR_RARITY_MAP_FILE = os.path.join(BASE_DIR, r"Data/Config/StarRarityMap.json")            # 星级-稀有度 配置文件
PROFESSION_IMAGE_PATH_CONFIG_FILE = os.path.join(BASE_DIR, r"Data/ImagePathConfig/Profession.json")
                                                                                            # 职业 图片路径 配置文件
ATTRIBUTE_IMAGE_PATH_CONFIG_FILE = os.path.join(BASE_DIR, r"Data/ImagePathConfig/Attribute.json")
                                                                                            # 属性 图片路径 配置文件
