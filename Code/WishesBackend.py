from ManageSystem import *
from GameAdaptationModule import *
from ImageManageModule import *
from WishesQmlAPI import QCard, QCardPool, QWishResult, CardQueryParams
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

            self.profession_image_manager = ProfessionImageManager(PROFESSION_IMAGE_PATH_CONFIG_FILE)
            self.attribute_image_manager = AttributeImageManager(ATTRIBUTE_IMAGE_PATH_CONFIG_FILE)

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
    
    @Slot(result=CardQueryParams)
    def request_card_query_params(self) -> CardQueryParams:
        return CardQueryParams(self)

    @Slot(str, str, result=str)
    def image_get_profession(self, game: str, profession: str) -> str:
        try:
            res = self.profession_image_manager.get_path(game, profession)
            return res
        except ValueError as e:
            self.errorHappened.emit("图像获取错误", str(e)) # type: ignore
        except FileNotFoundError as e:
            self.errorHappened.emit("图像获取错误", str(e)) # type: ignore
        except Exception:
            msg = traceback.format_exc()
            self.errorHappened.emit("图像获取错误", msg) # type: ignore

        return ""

    @Slot(str, str, result=str)
    def image_get_attribute(self, game: str, attribute: str) -> str:
        try:
            res = self.attribute_image_manager.get_path(game, attribute)
            return res
        except ValueError as e:
            self.errorHappened.emit("图像获取错误", str(e)) # type: ignore
        except FileNotFoundError as e:
            self.errorHappened.emit("图像获取错误", str(e)) # type: ignore
        except Exception:
            msg = traceback.format_exc()
            self.errorHappened.emit("图像获取错误", msg) # type: ignore

        return ""
    
    @Slot(str, result=str)
    def image_get_card(self, relative_image_path: str) -> str:
        try:
            path = os.path.join(BASE_DIR, relative_image_path)
            if os.path.exists(path):
                return path
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("图像获取错误", msg) # type: ignore
        
        return ""
    
    @Slot(str, int, result=bool)
    def adapter_check_using_star(self, game, star) -> bool:
        try:
            return self.star_rarity_adapter.check_using_star(game, star)
        except ValueError as e:
            self.errorHappened.emit("", str(e)) # type: ignore
        # TODO
        
        return True
    
    @Slot(str, int, result=str)
    def adapter_get_rarity(self, game: str, star: int) -> str:
        try:
            return self.star_rarity_adapter.get_rarity(game, star)
        except ValueError as e:
            self.errorHappened.emit("", str(e)) # type: ignore
        
        return ""
    
    @Slot(str, int, result=str)
    def adapter_get_color(self, game: str, star: int) -> str:
        try:
            return self.star_rarity_adapter.get_color(game, star)
        except ValueError as e:
            self.errorHappened.emit("", str(e)) # type: ignore
        
        return ""
    
    @Slot(CardQueryParams, result=QCard)
    def card_system_get_card(self, params: CardQueryParams) -> QCard:
        try:
            card = self.card_system.get_card(params._content, params._game, params._type, params._star)
            return QCard(PackedCard(card), self)
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("获取卡片错误", msg) # type: ignore
        
        return QCard(PackedCard(Card.none()), self)
    
    @Slot(CardQueryParams, result=list)
    def card_system_get_cards(self, params: CardQueryParams) -> List[QCard]:
        try:
            cards = self.card_system.get_cards(
                params._game, params._type, params._star, params._content
            )
            if params._start >= len(cards):
                return []
            lst = cards[params._start:-1 if (params._start + params._num >= len(cards)) else (params._start + params._num)]
            lst.sort(key=lambda x: x.star, reverse=params._reverse)
            res = [
                QCard(PackedCard(card), self)
                for card in lst
            ]
            return res
            
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("", msg) # type: ignore
        
        return []
    
    @Slot(result=list)
    def card_system_get_card_list(self) -> List[QCard]:
        try:
            cards = self.card_system.get_cards()
            res = []
            for card in cards:
                packed_card = PackedCard(card)
                packed_card.rarity_using_star = self.star_rarity_adapter.check_using_star(card.game, card.star)
                packed_card.rarity = self.star_rarity_adapter.get_rarity(card.game, card.star)
                res.append(QCard(packed_card, self))
            return res
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("获取卡片列表错误", msg) # type: ignore
        
        return []
    
    @Slot(result=list)
    def card_system_get_game_list(self) -> List[str]:
        try:
            return self.card_system.games()
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("", msg) # type: ignore
        
        return []
    
    @Slot(result=list)
    def card_system_get_type_list(self) -> List[str]:
        try:
            return self.card_system.types()
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("", msg) # type: ignore
        
        return []
    
    @Slot(result=list)
    def card_system_get_rarity_list(self) -> List[str]:
        try:
            res = []
            for game, star in self.card_system.game_star_info():
                rarity = self.star_rarity_adapter.get_rarity(game, star)
                if rarity not in res:
                    res.append(rarity)
            return res
        except:
            msg = traceback.format_exc()
            self.errorHappened.emit("", msg) # type: ignore
        
        return []
    
    # @Slot(QCardPool, result=QWishResult)
    # def card_pool_wish_one(self, q_card_pool: QCardPool) -> QWishResult:
    #     try:
    #         card_pool = q_card_pool.card_pool
    #         result = card_pool.wish_one()
    #         packed_card = result.get_one()
    #         card = packed_card.card
    #         packed_card.rarity_using_star = self.star_rarity_adapter.check_using_star(card.game, card.star)
    #         packed_card.rarity = self.star_rarity_adapter.get_rarity(card.game, card.star)
            
    #     except:
    #         msg = traceback.format_exc()
    #         self.errorHappened.emit(f"卡池 '{card_pool.name}': 抽卡时错误", msg) # type: ignore
    


if __name__ == "__main__":
    pass

