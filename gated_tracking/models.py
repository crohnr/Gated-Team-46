from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Optional


class Carrier(str, Enum):
    USPS = "USPS"
    UPS = "UPS"
    FEDEX = "FEDEX"


class TrackingStatus(str, Enum):
    CREATED = "CREATED"
    IN_TRANSIT = "IN_TRANSIT"
    OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY"
    DELIVERED = "DELIVERED"
    UNKNOWN = "UNKNOWN"


@dataclass
class User:
    id: int
    email: str


@dataclass
class TrackingItem:
    id: int
    user_id: int
    tracking_number: str
    carrier: Carrier
    label: str
    status: TrackingStatus = TrackingStatus.CREATED
    created_at: datetime = field(default_factory=datetime.utcnow)
    last_synced_at: Optional[datetime] = None
    estimated_delivery: Optional[datetime] = None

    def update_status(
        self,
        status: TrackingStatus,
        estimated_delivery: Optional[datetime] = None
    ):
        self.status = status
        self.last_synced_at = datetime.utcnow()
        if estimated_delivery:
            self.estimated_delivery = estimated_delivery
