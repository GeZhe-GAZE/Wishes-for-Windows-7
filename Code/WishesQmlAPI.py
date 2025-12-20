from PySide2.QtCore import QObject, Property, Slot, Signal
from dataclasses import dataclass
from typing import cast, Optional
from Base import *
from CardPool import CardPool


Property = cast(type, Property)     # 使 vscode 的类型检查能正确识别 Property 修饰器
Slot = cast(type, Slot)


class QCard(QObject):
    def __init__(self, packed_card: PackedCard, parent: Optional[QObject]= None) -> None:
        super().__init__(parent)
        self.packed_card = packed_card

    @Property(str)
    def content(self) -> str:
        return self.packed_card.card.content
    
    @Property(str)
    def game(self) -> str:
        return self.packed_card.card.game
    
    @Property(int)
    def star(self) -> int:
        return self.packed_card.card.star
    
    @Property(str)
    def rarity(self) -> str:
        return self.packed_card.rarity
    
    @Property(str)
    def type(self) -> str:
        return self.packed_card.card.type
    
    @Property(str)
    def attribute(self) -> str:
        return self.packed_card.card.attribute
    
    @Property(str)
    def title(self) -> str:
        return self.packed_card.card.title

    @Property(str)
    def profession(self) -> str:
        return self.packed_card.card.profession
    
    @Property(str)
    def image_path(self) -> str:
        return self.packed_card.card.image_path
    
    @Property(str)
    def tag(self) -> str:
        return self.packed_card.real_tag


class QWishResult(QObject):
    maxStarChanged = Signal()
    countChanged = Signal()

    def __init__(self, wish_result: WishResult, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self.wish_result = wish_result
    
    @Property(int, notify=maxStarChanged)
    def max_star(self) -> int:
        return self.wish_result.max_star

    @Property(int, notify=countChanged)
    def count(self) -> int:
        return self.wish_result.count
    
    @Slot(int, result=QCard)
    def get(self, index: int) -> QCard:
        if not 0 <= index < self.wish_result.count:
            return QCard(PackedCard(Card.none()), self)
        return QCard(self.wish_result.cards[index], self)


class QCardPool(QObject):
    nameChanged = Signal()

    def __init__(self, card_pool: CardPool, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self.card_pool = card_pool
    
    @Property(str, notify=nameChanged)
    def name(self) -> str:
        return self.card_pool.name
    
    @Slot(result=QWishResult)
    def wish_one(self) -> QWishResult:
        result = self.card_pool.wish_one()
        return QWishResult(result, self)
    
    @Slot(result=QWishResult)
    def wish_ten(self) -> QWishResult:
        result = self.card_pool.wish_ten()
        return QWishResult(result, self)
        
