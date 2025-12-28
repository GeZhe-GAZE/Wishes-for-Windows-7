from PySide2.QtCore import QObject, Property, Slot, Signal
from dataclasses import dataclass
from typing import cast, Optional
from Base import *
from CardPool import CardPool


Property = cast(type, Property)     # 使 vscode 的类型检查能正确识别 Property 修饰器
Slot = cast(type, Slot)


@dataclass
class CardQueryParams(QObject):
    _content: Optional[str] = None
    _game: Optional[str] = None
    _type: Optional[str] = None
    _star: Optional[int] = None
    _attribute: Optional[str] = None
    _profession: Optional[str] = None
    _start: int = 0
    _num: int = -1
    _reverse: bool = False

    def __init__(self, parent: Optional[QObject]= None) -> None:
        super().__init__(parent)

    @Property(str)
    def content(self) -> str:
        return self._content if self._content else ""
    
    @content.setter
    def _w_content(self, value: str):
        if value != self._content:
            self._content = value
    
    @Property(str)
    def game(self) -> str:
        return self._game if self._game else ""
    
    @game.setter
    def _w_game(self, value: str):
        if value != self._game:
            self._game = value

    @Property(str)
    def type(self) -> str:
        return self._type if self._type else ""
    
    @type.setter
    def _w_type(self, value: str):
        if value != self._type:
            self._type = value
    
    @Property(int)
    def star(self) -> int:
        return self._star if self._star else 0
    
    @star.setter
    def _w_star(self, value: int):
        if value != self._star:
            self._star = value
    
    @Property(str)
    def attribute(self) -> str:
        return self._attribute if self._attribute else ""
    
    @attribute.setter
    def _w_attribute(self, value: str):
        if value != self._attribute:
            self._attribute = value
    
    @Property(str)
    def profession(self) -> str:
        return self._profession if self._profession else ""
    
    @profession.setter
    def _w_profession(self, value: str):
        if value != self._profession:
            self._profession = value
    
    @Property(int)
    def start(self) -> int:
        return self._start
    
    @start.setter
    def _w_start(self, value: int):
        if value != self._start:
            self._start = value
    
    @Property(int)
    def num(self) -> int:
        return self._num
    
    @num.setter
    def _w_num(self, value: int):
        if value != self._num:
            self._num = value
    
    @Property(bool)
    def reverse(self) -> bool:
        return self._reverse
    
    @reverse.setter
    def _w_reverse(self, value: bool):
        if self._reverse != value:
            self._reverse = value


class QCard(QObject):
    contentChanged = Signal()
    gameChanged = Signal()
    starChanged = Signal()
    rarityChanged = Signal()
    typeChanged = Signal()
    attributeChanged = Signal()
    titleChanged = Signal()
    professionChanged = Signal()
    imagePathChanged = Signal()
    tagChanged = Signal()

    def __init__(self, packed_card: PackedCard, parent: Optional[QObject]= None) -> None:
        super().__init__(parent)
        self.packed_card = packed_card

    @Property(str, notify=contentChanged)
    def content(self) -> str:
        return self.packed_card.card.content
    
    @Property(str, notify=gameChanged)
    def game(self) -> str:
        return self.packed_card.card.game
    
    @Property(int, notify=starChanged)
    def star(self) -> int:
        return self.packed_card.card.star
    
    @Property(str, notify=rarityChanged)
    def rarity(self) -> str:
        return self.packed_card.rarity
    
    @Property(bool)
    def rarity_using_star(self) -> bool:
        return self.packed_card.rarity_using_star
    
    @Property(str, notify=typeChanged)
    def type(self) -> str:
        return self.packed_card.card.type
    
    @Property(str, notify=attributeChanged)
    def attribute(self) -> str:
        return self.packed_card.card.attribute
    
    @Property(str, notify=titleChanged)
    def title(self) -> str:
        return self.packed_card.card.title

    @Property(str, notify=professionChanged)
    def profession(self) -> str:
        return self.packed_card.card.profession
    
    @Property(str, notify=imagePathChanged)
    def imagePath(self) -> str:
        return self.packed_card.card.image_path
    
    @Property(str, notify=tagChanged)
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
        
