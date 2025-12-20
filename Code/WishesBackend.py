from ManageSystem import *
from GameAdaptationModule import *
from WishesQmlAPI import QCard, QCardPool
from PySide2.QtCore import Property, Slot, Signal, QObject, QAbstractListModel

from typing import cast
from typing import List
import json
import sys
import traceback

Property = cast(type, Property)
Slot = cast(type, Slot)

class Backend(QObject):
    errorHappened = Signal(str, str)    # 错误类型, 详细信息
    versionChanged = Signal()
    cardPoolCountChanged = Signal()
    cardPoolListChanged = Signal()

    def __init__(self) -> None:
        super().__init__()
        self.init_error_flag = False
        self.init_error_content = ()
        self._init_system()
        self.q_card_pool_list = [QCardPool(cp, self) for cp in self.card_pool_system.get_card_pools()]


    def _init_system(self):
        try:
            with open(CARDS_DIR_CONFIG_FILE, "r", encoding="utf-8") as f:
                cards_dir_config = json.load(f)

            self.card_system = CardSystem(CARDS_DIR, cards_dir_config)
            self.standard_group_system = StandardGroupSystem(RESIDENT_GROUP_DIR, self.card_system)
            self.card_group_system = CardGroupSystem(CARD_GROUP_DIR, self.card_system, self.standard_group_system)
            self.wish_logic_system = WishLogicSystem(LOGIC_CONFIG_DIR)
            self.card_pool_system = CardPoolSystem(CARD_POOL_DIR, self.card_group_system, self.wish_logic_system)

            self.star_rarity_adapter = StarRarityAdapter(STAR_RARITY_MAP_FILE)

        except:
            print("Backend Error:")
            msg = traceback.format_exc()
            print(msg)
            self.init_error_flag = True
            self.init_error_content = ("Wishes 管理系统初始化错误", msg)

    @Property(str, notify=versionChanged)
    def version(self) -> str:
        return VERSION
    
    @Property(int, notify=cardPoolCountChanged)
    def card_pool_count(self) -> int:
        return self.card_pool_system.count()
    
    @Property(list, notify=cardPoolListChanged)
    def card_pool_list(self) -> List[QCardPool]:
        return self.q_card_pool_list


if __name__ == "__main__":
    pass

