from dataclasses import dataclass
from enum import Enum


class Env(str, Enum):
    DEV = "dev"
    PROD = "prod"


@dataclass
class Settings:
    environment: Env = Env.DEV
    database_url: str = "sqlite://:memory:"
    usps_api_key: str = "FAKE_USPS_KEY"
    ups_api_key: str = "FAKE_UPS_KEY"
    fedex_api_key: str = "FAKE_FEDEX_KEY"


settings = Settings()
