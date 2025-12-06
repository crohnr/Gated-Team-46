from abc import ABC, abstractmethod
from datetime import datetime, timedelta
import random

from .models import Carrier, TrackingStatus, TrackingItem
from .config import settings


class CarrierApiClient(ABC):

    @abstractmethod
    def fetch_tracking_update(self, tracking_number: str) -> dict:
        """Return a dict containing status + optional estimated_delivery."""


class UspsApiClient(CarrierApiClient):

    def fetch_tracking_update(self, tracking_number: str) -> dict:
        statuses = [
            TrackingStatus.IN_TRANSIT,
            TrackingStatus.OUT_FOR_DELIVERY,
            TrackingStatus.DELIVERED
        ]
        return {
            "status": random.choice(statuses),
            "estimated_delivery": datetime.utcnow() + timedelta(days=random.randint(1, 4)),
        }


class UpsApiClient(CarrierApiClient):

    def fetch_tracking_update(self, tracking_number: str) -> dict:
        statuses = [
            TrackingStatus.IN_TRANSIT,
            TrackingStatus.DELIVERED
        ]
        return {
            "status": random.choice(statuses),
            "estimated_delivery": datetime.utcnow() + timedelta(days=random.randint(2, 5)),
        }


class FedexApiClient(CarrierApiClient):

    def fetch_tracking_update(self, tracking_number: str) -> dict:
        statuses = [
            TrackingStatus.IN_TRANSIT,
            TrackingStatus.OUT_FOR_DELIVERY
        ]
        return {
            "status": random.choice(statuses),
            "estimated_delivery": datetime.utcnow() + timedelta(days=random.randint(1, 3)),
        }


class CarrierClientFactory:

    @staticmethod
    def create(carrier: Carrier) -> CarrierApiClient:
        if carrier == Carrier.USPS:
            return UspsApiClient()
        if carrier == Carrier.UPS:
            return UpsApiClient()
        if carrier == Carrier.FEDEX:
            return FedexApiClient()
        raise ValueError(f"Unsupported carrier: {carrier}")
