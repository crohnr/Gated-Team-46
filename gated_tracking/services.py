from typing import List
from .models import TrackingItem, Carrier, TrackingStatus
from .repositories import TrackingItemRepository
from .api_clients import CarrierClientFactory


class TrackingService:

    def __init__(self, repo: TrackingItemRepository):
        self.repo = repo

    def add_tracking_item(
        self,
        user_id: int,
        tracking_number: str,
        carrier: Carrier,
        label: str
    ) -> TrackingItem:
        item = TrackingItem(
            id=0,  # repository will set real ID
            user_id=user_id,
            tracking_number=tracking_number,
            carrier=carrier,
            label=label,
        )
        return self.repo.add(item)

    def get_user_tracking_items(self, user_id: int) -> List[TrackingItem]:
        return self.repo.get_by_user(user_id)

    def sync_item_with_carrier(self, item_id: int) -> TrackingItem:
        item = self.repo.get_by_id(item_id)
        if not item:
            raise ValueError("Tracking item not found")

        client = CarrierClientFactory.create(item.carrier)
        update = client.fetch_tracking_update(item.tracking_number)

        item.update_status(
            status=update["status"],
            estimated_delivery=update["estimated_delivery"]
        )

        self.repo.update(item)
        return item
