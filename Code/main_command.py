from Const import *
from ManageSystem import *
from typing import List, Callable
from GameAdaptationModule import *
import colorama
import os
import json
import traceback


launch_info = f"""
-------------------------
Wishes v3 (For Windows 7)
版本: {VERSION}

输入 'help' 获取帮助信息
-------------------------
"""


# PROGRAM_DIR = os.getcwd()

# CARDS_DIR = os.path.join(PROGRAM_DIR, r"Data/Cards")
# CARDS_DIR_CONFIG_FILE = os.path.join(PROGRAM_DIR, r"Data/Config/CardsDirConfig.json")
# RESIDENT_GROUP_DIR = os.path.join(PROGRAM_DIR, r"Data/StandardGroups")
# CARD_GROUP_DIR = os.path.join(PROGRAM_DIR, r"Data/CardGroups")
# LOGIC_CONFIG_DIR =os.path.join(PROGRAM_DIR, r"Data/LogicConfig")
# CARD_POOL_DIR = os.path.join(PROGRAM_DIR, r"Data/CardPools")

# STAR_RARITY_MAP_FILE = os.path.join(PROGRAM_DIR, r"Data/Config/StarRarityMap.json")


class Program:
    def __init__(self) -> None:
        colorama.just_fix_windows_console()

        print(colorama.Fore.GREEN + launch_info + colorama.Fore.RESET)

        self._init_system()

        self.commands: dict[str, Callable] = {
            "help": self.help_info,
            "w": self.wish_one,
            "wt": self.wish_ten,
            "wc": self.wish_count,
            "lgs": self.lgs,
            "cgs": self.cgs,
            "cps": self.cps,
            "ccg": self.ccg,
            "clg": self.clg,
            "ccp": self.ccp,
            "sw": self.switch,
            "sv": self.save,
            "dcg": self.dcg,
            "dlg": self.dlg,
            "dcp": self.dcp,
            "dcd": self.dcd,
            "dcdn": self.dcdn,
            "rs": self.reset,
            "clr": self.clear,
            "rd": self.rd,
            "rds": self.record_set,
            "exit": self.exit,
        }

        self.command_docs: dict[str, tuple[tuple, str]] = {
            "help": ((), "显示帮助信息"),
            "w": ((), "单抽"),
            "wt": ((), "十连"),
            "wc": (("int times",), "指定次数抽卡"),
            "lgs": ((), "列出所有可用抽卡逻辑"),
            "cgs": ((), "列出所有可用卡组"),
            "cps": ((), "列出所有可用卡池"),
            "ccg": ((), "查看当前卡池所使用卡组的详细信息"),
            "clg": ((), "查看当前卡池的抽卡逻辑信息"),
            "ccp": ((), "查看当前卡池的详细信息"),
            "sw": (("str name",), "切换到指定卡池"),
            "sv": ((), "保存当前卡池的抽卡记录"),
            "dcg": (("str name",), "查看指定卡组的详细信息"),
            "dlg": ((), "查询抽卡逻辑信息"),
            "dcp": (("str name",), "查看指定卡池的详细信息"),
            "dcd": ((), "查询卡片"),
            "dcdn": (("str name",), "根据卡片名称搜索卡片"),
            "rs": ((), "重置当前卡池"),
            "clr": ((), "清除当前卡池的抽卡记录"),
            "rd": ((), "查看当前卡池的抽卡记录"),
            "rds": (("on / off",), "设置自动记录策略"),
            "exit": ((), "退出程序"),
        }

        self.current_card_pool: Optional[CardPool] = None
        self.is_saved = True
        self.counter = 0
    
    def _init_system(self):
        # 初始化管理系统
        try:
            with open(CARDS_DIR_CONFIG_FILE, "r", encoding="utf-8") as f:
                cards_dir_config = json.load(f)
            
            self.card_system = CardSystem(CARDS_DIR, cards_dir_config)
            self.standard_group_system = StandardGroupSystem(RESIDENT_GROUP_DIR, self.card_system)
            self.card_group_system = CardGroupSystem(CARD_GROUP_DIR, self.card_system, self.standard_group_system)
            self.wish_logic_system = WishLogicSystem(LOGIC_CONFIG_DIR)
            self.card_pool_system = CardPoolSystem(CARD_POOL_DIR, self.card_group_system, self.wish_logic_system)

            self.star_rarity_adaptor = StarRarityAdapter(STAR_RARITY_MAP_FILE)

        except:
            print(colorama.Fore.RED + " 初始化错误 ".center(50, "-"))
            print("详细信息:")
            traceback.print_exc()
            print("-" * 18, "请检查配置文件", sep="\n")
            input("按下回车键退出程序 >>> " + colorama.Fore.RESET)
            self.exit()
    
    def mainloop(self):
        while True:
            msg = input(">>> ")
            if not msg.strip():
                continue

            lst = msg.split()
            func = self.commands.get(lst[0])
            if not func:
                self.report_error(f"未知命令: <{lst[0]}>")
                continue

            para_len = len(self.command_docs[lst[0]][0])
            if para_len != len(lst) - 1:
                self.report_error("无效参数")
                continue
            
            try:
                if para_len:
                    func(lst[1:])
                else:
                    func()
            except SystemExit:
                break
            except:
                print(colorama.Fore.RED + " 发生未知错误 ".center(50, "-"), "\n详细信息:")
                traceback.print_exc()
                print(colorama.Fore.RESET)
    
    def help_info(self):
        max_command_l, max_para_l, max_desc_l = 0, 0, 0
        for command, (para, desc) in self.command_docs.items():
            max_command_l = max(max_command_l, len(command))
            max_para_l = max(max_para_l, len(",".join(para)) + 2)
            max_desc_l = max(max_desc_l, len(desc))
        
        print("-" * (max_command_l + max_para_l + max_desc_l + 10))
        print("所有命令:")

        print("命令".ljust(max_command_l), "参数".ljust(max_para_l), "描述")
        for command, (para, desc) in self.command_docs.items():
            print(
                command.ljust(max_command_l), 
                ("(" + ",".join(para) + ")").ljust(max_para_l), 
                desc
            )
        
        print("-" * (max_command_l + max_para_l + max_desc_l + 10))

    def report_error(self, msg: str):
        print(colorama.Fore.RED + (f" Error: {msg} ").center(50, "-") + colorama.Fore.RESET)
    
    def report_type_error(self, type_: str):
        print(colorama.Fore.RED + f" TypeError: 非期望参数类型: <{type_}> ".center(50, "-") + colorama.Fore.RESET)

    def report_tip(self, msg: str):
        print(colorama.Fore.YELLOW + (f" {msg} ").center(50, "-") + colorama.Fore.RESET)

    def exit(self):
        print(" Wishes 已退出 ".center(50, "-"))
        exit()

    def wish_one(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        
        self.counter += 1
        result = self.current_card_pool.wish_one()
        packed_card = result.get_one()
        print(colorama.Fore.MAGENTA + f"{self.counter}. {packed_card}" + colorama.Style.RESET_ALL)
        
        self.is_saved = False
    
    def wish_ten(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        
        result = self.current_card_pool.wish_ten()
        for packed_card in result.cards:
            self.counter += 1
            print(colorama.Fore.MAGENTA + f"{self.counter}. {packed_card}" + colorama.Style.RESET_ALL)

        self.is_saved = False

    def wish_count(self, para_list: List[str]):
        times: str = para_list[0]
        if not times.isdigit():
            self.report_type_error("int")
            return
        
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        
        count = int(times)
        if count <= 0:
            self.report_error("抽卡次数必须大于 0")
            return
        if count >= 10_000:
            self.report_tip("抽卡次数较大，可能会导致程序运行缓慢，是否继续? (y/n)")
            while True:
                m = input(colorama.Fore.YELLOW + "continue >>> " + colorama.Fore.RESET).strip().lower()
                if m == "y":
                    break
                elif m == "n":
                    self.report_tip("已取消抽卡")
                    return

        result = self.current_card_pool.wish_count(count)
        for packed_card in result.cards:
            self.counter += 1
            print(colorama.Fore.MAGENTA + f"{self.counter}. {packed_card}" + colorama.Style.RESET_ALL)

        self.is_saved = False

    def lgs(self):
        print("-" * 20 + "\n所有可用抽卡逻辑:\n")
        counter = 1
        max_number_length = len(str(len(self.wish_logic_system.logics)))
        for logic_name in self.wish_logic_system.get_logic_names():
            print(f"{counter:>{max_number_length}}. {logic_name}")
            counter += 1
        print("-" * 20)

    def cgs(self):
        print("-" * 20 + "\n所有可用卡组:\n")
        counter = 1
        max_number_length = len(str(len(self.card_group_system.get_card_group_names())))
        for card_group_name in self.card_group_system.get_card_group_names():
            print(f"{counter:>{max_number_length}}. {card_group_name}")
            counter += 1
        print("-" * 20)

    def cps(self):
        print("-" * 20 + "\n所有可用卡池:\n")
        counter = 1
        max_number_length = len(str(len(self.card_pool_system.get_card_pool_names())))
        for card_pool_name in self.card_pool_system.get_card_pool_names():
            print(f"{counter:>{max_number_length}}. {card_pool_name}")
            counter += 1
        print("-" * 20)

    def ccg(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        print(" 当前卡组信息 ".center(50, "-") + "\n")
        print(self.current_card_pool.card_group)
        print("-" * 50)
    
    def clg(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        print(" 当前抽卡逻辑 ".center(50, "-"), "\n")
        print(self.current_card_pool.logic.info())
        print("-" * 50)

    def ccp(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        self.report_tip("当前卡池信息")
        print("\n" + self.current_card_pool.__str__() + "\n\n" + "-" * 50)

    def switch(self, para_list: List[str]):
        name: str = para_list[0]
        if name not in self.card_pool_system.get_card_pool_names():
            self.report_error(f"卡池 '{name}' 不存在")
            return
        
        if not self.is_saved:
            self.report_tip("当前卡池记录未保存，是否保存？(y/n)")
            while True:
                m = input(colorama.Fore.YELLOW + "save >>> " + colorama.Fore.RESET).strip().lower()
                if m == "y":
                    self.save()
                    break
                elif m == "n":
                    break

        self.counter = 0
        self.current_card_pool = self.card_pool_system.get_card_pool(name)
        self.report_tip(f"已切换到卡池 '{name}'")

        if not self.current_card_pool.recorder.auto_to_file:
            print("*当前卡池未启用自动记录，抽卡记录不会自动保存至记录文件",
                  "通过 'save' 命令手动保存抽卡记录",
                  "或通过 'rds on' 命令启用自动记录",
                  sep="\n")

    def save(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        self.card_pool_system.save_card_pool(
            self.current_card_pool.name,
            os.path.join(CARD_POOL_DIR, self.current_card_pool.name + ".json")
        )
        self.report_tip(f"卡池 '{self.current_card_pool.name}' 的抽卡数据及记录已保存")
        self.is_saved = True

    def dcg(self, para_list: List[str]):
        name = para_list[0]

        if name not in self.card_group_system.get_card_group_names():
            self.report_error(f"卡组 '{name}' 不存在")
            return
        
        card_group = self.card_group_system.get_group(name)
        print(" 卡组信息 ".center(50, "-"))
        print(card_group)
        print("-" * 50)
    
    def dlg(self):
        self.lgs()
        print("选择查询的抽卡逻辑:(数字编号/ q 退出 / r 重新显示列表)")
        lst = self.wish_logic_system.get_logic_names()
        l = len(lst)
        while True:
            m = input(">>> ")
            if m.lower() == "q":
                self.report_tip("已退出查询")
                break
            if m.lower() == "r":
                self.lgs()
                continue
            if not m.isdigit() or not 0 < int(m) <= l:
                continue
            print(self.wish_logic_system.get_logic(lst[int(m)-1]).info())

    def dcp(self, para_list: List[str]):
        name = para_list[0]

        if name not in self.card_pool_system.get_card_pool_names():
            self.report_error(f"卡池 '{name}' 不存在")
            return
        
        card_pool = self.card_pool_system.get_card_pool(name)

        print(" 卡池信息 ".center(50, "-"))
        print(card_pool)
        print("-" * 50)
    
    def dcd(self):
        print("查询卡片".center(50, "-"))

        games = ["不选择"] + self.card_system.games()

        print("\n".join((
            "选择游戏: (数字编号)",
            " | ".join([
                f"{num}. {game}" for num, game in zip(range(len(games) + 1), games)
            ]),
            "-" * 20
        )))

        while True:
            s_1 = input("game >>> ")
            if s_1.isdigit() and 0 <= int(s_1) < len(games):
                g = int(s_1)
                break
        
        t_game = games[g] if g else None

        types = ["不选择"] + self.card_system.types(t_game)
        print("\n".join((
            "选择类型 (数字编号)",
            " | ".join([
                f"{num}. {type_}" for num, type_ in zip(range(len(types) + 1), types)
            ]),
            "-" * 20
        )))
        
        while True:
            s_2 = input("type >>> ")
            if s_2.isdigit() and 0 <= int(s_2) < len(types):
                t = int(s_2)
                break
        
        t_type = types[t] if t else None

        stars = ["不选择"] + self.card_system.stars(t_game, t_type)
        print("\n".join((
            "选择星级(稀有度) (数字编号)",
            " | ".join([
                f"{num}. {star_}" for num, star_ in zip(range(len(stars) + 1), stars)
            ]),
            "-" * 20
        )))

        while True:
            s_3 = input("star >>> ")
            if s_3.isdigit() and 0 <= int(s_3) < len(stars):
                s = int(s_3)
                break
        
        t_star: Optional[int] = stars[s] if s else None # type: ignore

        cards = self.card_system.get_cards(t_game, t_type, t_star)
        
        print("\n".join((
            "-" * 20,
            f"共筛选出 {len(cards)} 个符合条件的卡片",
            f"筛选条件 {t_game} -> {t_type} -> {t_star}",
            *[f"{num}. {card}" for num, card in zip(range(1, len(cards) + 1), cards)]
        )))
    
    def dcdn(self, para_list: List[str]):
        name = para_list[0]
        cards = self.card_system.get_cards(content=name)

        print("\n".join((
            f"共搜索到 {len(cards)} 个名称为 '{name}' 的卡片",
            *[f"{num}. {card}" for num, card in zip(range(1, len(cards) + 1), cards)]
        )))

    def reset(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        
        self.report_tip("确认重置当前卡池数据 (y/n)")
        while True:
            m = input(colorama.Fore.YELLOW + "continue >>> " + colorama.Fore.RESET).strip().lower()
            if m == "y":
                break
            elif m == "n":
                self.report_tip("已取消重置")
                return
        
        with_records = False
        self.report_tip("是否同时清空抽卡记录? (y/n)")
        while True:
            m = input(colorama.Fore.YELLOW + "continue >>> " + colorama.Fore.RESET).strip().lower()
            if m == "y":
                with_records = True
                break
            elif m == "n":
                break

        self.current_card_pool.reset(with_records)
        self.counter = 0
        self.report_tip(f"卡池 '{self.current_card_pool.name}' 已重置")
        if with_records:
            self.report_tip("抽卡记录已清空")

    def clear(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        self.current_card_pool.recorder.clear()
        self.report_tip(f"卡池 '{self.current_card_pool.name}' 的抽卡记录已清空")
    
    def rd(self):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return

        width = 56
        recorder = self.current_card_pool.recorder
        print("\n".join((
            f" 卡池 '{self.current_card_pool.name}' 抽卡记录 ".center(50, "-"),
            "总抽数:" + f"{recorder.total_counter}".rjust(width - 7),
            *[
                (s := f"- {star} 星数:") + 
                f"{recorder.count(star=star)}".rjust(width - len(s) - 2)
                for star in recorder.all_stars()
            ],
            *[
                (t := f"- {type_} 类型数:") +
                f"{recorder.count(type_=type_)}".rjust(width - len(t) - 3)
                for type_ in recorder.all_types()
            ],
            "详情:",
            *[
                f"- {tag} 标签:\n" +
                "\n".join([
                    " " * 2 + f"- {type_} 类型:\n" +
                    "\n".join([
                        (s := " " * 4 + f"- {star} 星数:") +
                        f"{num}".rjust(width - len(s) - 2)
                        for star, num in recorder.counters[tag][type_].items()
                    ])
                    for type_ in recorder.counters[tag].keys()
                ])
                for tag in recorder.all_tags()
            ],
            "-" * width
        )))

    def record_set(self, para_list: List[str]):
        if not self.current_card_pool:
            self.report_tip("当前未选择卡池")
            return
        
        m = para_list[0].lower()
        if m == "on":
            self.current_card_pool.recorder.auto_to_file = True
            self.report_tip(f"已为卡池 '{self.current_card_pool.name}' 启用自动记录")
        elif m == "off":
            self.current_card_pool.recorder.auto_to_file = False
            self.report_tip(f"已为卡池 '{self.current_card_pool.name}' 已禁用自动记录")
        else:
            self.report_error("参数错误: 应为 'on' 或 'off'")

def main():
    program = Program()
    program.mainloop()


if __name__ == "__main__":
    main()
