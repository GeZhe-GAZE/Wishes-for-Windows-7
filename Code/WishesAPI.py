from ManageSystem import *
import os
import traceback


class SystemGroup:
    def __init__(self) -> None:

        try:
            with open(CARDS_DIR_CONFIG_FILE, "r", encoding="utf-8") as f:
                cards_dir_config = json.load(f)

            # 初始化管理系统
            self.card_system = CardSystem(CARDS_DIR, cards_dir_config)
            self.standard_group_system = StandardGroupSystem(RESIDENT_GROUP_DIR, self.card_system)
            self.card_group_system = CardGroupSystem(CARD_GROUP_DIR, self.card_system, self.standard_group_system)
            self.wish_logic_system = WishLogicSystem(LOGIC_CONFIG_DIR)
            self.card_pool_system = CardPoolSystem(CARD_POOL_DIR, self.card_group_system, self.wish_logic_system)

        except:
            print("SystemGroup: Initialization Error:", traceback.format_exc())
            print("Please check the configuration file.")
        
        print("ok")


class Program:
    def __init__(self) -> None:
        system_group = SystemGroup()

