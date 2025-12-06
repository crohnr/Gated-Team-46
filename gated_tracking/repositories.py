from abc import ABC, abstractmethod
from typing import List, Optional, Dict
from .models import TrackingItem


class TrackingItemRepository(ABC):

    @abstractmethod
    def add(self, item: TrackingItem) -> TrackingItem:
        ...

    @abstractmethod
    def get_by_id(self, item_id: int) -> Optional[TrackingItem]:
        ...

    @abstractmethod
    def get_by_user(self, user_id: int) -> List[TrackingItem]:
        ...

    @abstractmethod
    def update(self, item: TrackingItem) -> None:
        ...


class InMemoryTrackingItemRepository(TrackingItemRepository):

    def __init__(self):
        self._items: Dict[int, TrackingItem] = {}
        self._next_id = 1

    def add(self, item: TrackingItem) -> TrackingItem:
        item.id = self._next_id
        self._next_id += 1
        self._items[item.id] = item
        return item

    def get_by_id(self, item_id: int) -> Optional[TrackingItem]:
        return self._items.get(item_id)

    def get_by_user(self, user_id: int) -> List[TrackingItem]:
        return [item for item in self._items.values() if item.user_id == user_id]

    def update(self, item: TrackingItem) -> None:
        self._items[item.id] = item
