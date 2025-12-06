from .models import Carrier, TrackingStatus, TrackingItem, User
from .repositories import InMemoryTrackingItemRepository
from .services import TrackingService
from .api_clients import CarrierClientFactory
from .config import settings


def build_tracking_service() -> TrackingService:
    """
    Creates a TrackingService with in-memory storage and real carrier client factory.
    Useful for tests and demos.
    """
    repo = InMemoryTrackingItemRepository()
    return TrackingService(repo=repo)
