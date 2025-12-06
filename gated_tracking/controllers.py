# gated_tracking/controllers.py

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from .models import Carrier
from .repositories import InMemoryTrackingItemRepository
from .services import TrackingService

app = FastAPI(title="Gated Tracking API")

# 👇 NEW: CORS setup for Flutter Web (dev)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # for development; you can restrict later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

repo = InMemoryTrackingItemRepository()
service = TrackingService(repo)


class CreateTrackingRequest(BaseModel):
    user_id: int
    tracking_number: str
    carrier: Carrier
    label: str


@app.post("/tracking")
def create_tracking(req: CreateTrackingRequest):
    item = service.add_tracking_item(
        user_id=req.user_id,
        tracking_number=req.tracking_number,
        carrier=req.carrier,
        label=req.label,
    )
    return item


@app.get("/tracking")
def list_tracking(user_id: int = Query(...)):
    return service.get_user_tracking_items(user_id)


@app.post("/tracking/{item_id}/sync")
def sync_tracking(item_id: int):
    try:
        return service.sync_item_with_carrier(item_id)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
