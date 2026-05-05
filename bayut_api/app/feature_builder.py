# app/feature_builder.py

import pandas as pd
import numpy as np
from app.constants import ALL_PROVINCES, ALL_CITIES, ALL_PROPERTY_TYPES, ALL_FURNISHING


def build_features(data, encoders):
    prov_en = ALL_PROVINCES.get(data.province, data.province)
    city_en = ALL_CITIES.get(data.city, data.city)
    prop_en = ALL_PROPERTY_TYPES.get(data.property_type, data.property_type)
    furn_en = ALL_FURNISHING.get(data.furnishing_status, "unknown")

    amenities = [
        data.has_swimming_pool,
        data.has_gym_or_health_club,
        data.has_covered_parking,
        data.has_lawn_or_garden,
        data.has_security_staff,
        data.has_balcony_or_terrace,
        data.has_jacuzzi,
        data.has_sauna,
        data.has_cctv_security,
    ]

    row = {
        "area": data.area,
        "rooms": data.rooms,
        "baths": data.baths,
        "lat": data.lat,
        "lng": data.lng,

        "rooms_x_baths": data.rooms * data.baths,
        "area_per_room": data.area / max(data.rooms, 1),
        "total_amenities": sum(amenities),

        # TARGET ENCODING (SAME AS TRAINING)
        "city_en_enc": encoders["city_en"][0].get(city_en, encoders["city_en"][1]),
        "province_en_enc": encoders["province_en"][0].get(prov_en, encoders["province_en"][1]),
        "neighbourhood_en_enc": encoders.get("neighbourhood_en", ({}, 0))[0].get(city_en, 0),
    }

    # furnishing OHE
    for f in ["unfurnished", "furnished", "unknown"]:
        row[f"furnishingStatus_{f}"] = int(furn_en == f)

    # completion OHE
    for c in ["completed", "under-construction"]:
        row[f"completionStatus_{c}"] = int(data.completion_status == c)

    # property type OHE
    for t in [
        "Apartments", "Villas", "Chalets", "Twin Houses",
        "Duplexes", "Townhouses"
    ]:
        row[f"property_type_en_{t}"] = int(prop_en == t)

    return row