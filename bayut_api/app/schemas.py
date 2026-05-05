from pydantic import BaseModel

class PropertyInput(BaseModel):
    area: float
    rooms: int
    baths: int

    province: str
    city: str
    property_type: str

    furnishing_status: str = "unfurnished"
    completion_status: str = "completed"

    has_swimming_pool: bool = False
    has_gym: bool = False
    has_covered_parking: bool = False
    has_garden: bool = False
    has_security: bool = False
    has_balcony: bool = False
    has_jacuzzi: bool = False
    has_sauna: bool = False
    has_cctv: bool = False

    lat: float = 30.0
    lng: float = 31.0


class PredictionResponse(BaseModel):
    predicted_price: int
    price_range_low: int
    price_range_high: int
    currency: str = "EGP"
    confidence: str