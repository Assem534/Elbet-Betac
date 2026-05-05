from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.schemas import PropertyInput, PredictionResponse
from app.processor import PropertyProcessor
from app.constants import (
    PROVINCE_MAP, CITY_MAP, PROPERTY_TYPE_MAP,
    FURNISHING_MAP, COMPLETION_MAP
)
import os

app = FastAPI(title="Real Estate Price API", version="2.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

processor = PropertyProcessor(
    models_dir=os.path.join(BASE_DIR, "models"),
    data_path=os.path.join(BASE_DIR, "data", "X_train.csv")
)


@app.post("/predict", response_model=PredictionResponse)
async def predict(data: PropertyInput):
    try:
        X = processor.prepare_features(data)
        price = processor.predict(X)

        return {
            "predicted_price": int(price),
            "price_range_low": int(price * 0.85),
            "price_range_high": int(price * 1.15),
            "currency": "EGP",
            "confidence": "High"
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/constants")
def get_constants():
    def to_options(mapping: dict) -> list[dict]:
        return [{"en": en, "ar": ar} for en, ar in mapping.items()]

    return {
        "provinces": to_options(PROVINCE_MAP),
        "cities": to_options(CITY_MAP),
        "property_types": to_options(PROPERTY_TYPE_MAP),
        "furnishing_statuses": to_options(FURNISHING_MAP),
        "completion_statuses": to_options(COMPLETION_MAP),
    }


@app.get("/health")
def health():
    return {"status": "ok"}