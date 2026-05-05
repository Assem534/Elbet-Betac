import os
import pickle
import pandas as pd
import numpy as np


class PropertyProcessor:
    def __init__(self, models_dir: str, data_path: str):
        self.model = self._load(os.path.join(models_dir, "best_model.pkl"))
        self.encoders = self._load(os.path.join(models_dir, "target_encoders.pkl"))
        self.features = self._load(os.path.join(models_dir, "feature_columns.pkl"))

        self.medians = pd.read_csv(data_path).median(numeric_only=True)

    def _load(self, path):
        with open(path, "rb") as f:
            return pickle.load(f)

    def prepare_features(self, data):
        # ---- mapping ----
        row = {
            "rooms": data.rooms,
            "baths": data.baths,
            "area": data.area,
            "lat": data.lat,
            "lng": data.lng,
        }

        # ---- engineered features ----
        row["rooms_x_baths"] = data.rooms * data.baths
        row["area_per_room"] = data.area / max(data.rooms, 1)

        row["total_amenities"] = sum([
            data.has_swimming_pool,
            data.has_gym,
            data.has_covered_parking,
            data.has_garden,
            data.has_security,
            data.has_balcony,
            data.has_jacuzzi,
            data.has_sauna,
            data.has_cctv
        ])

        # ---- target encoding ----
        city_map, city_med = self.encoders["city_en"]
        prov_map, prov_med = self.encoders["province_en"]

        row["city_en_enc"] = city_map.get(data.city, city_med)
        row["province_en_enc"] = prov_map.get(data.province, prov_med)

        # ---- one hot ----
        furn = data.furnishing_status
        for f in ["furnished", "unfurnished", "unknown"]:
            row[f"furnishingStatus_{f}"] = int(furn == f)

        comp = data.completion_status
        for c in ["completed", "under-construction"]:
            row[f"completionStatus_{c}"] = int(comp == c)

        prop = data.property_type
        for col in self.features:
            if col.startswith("property_type_en_"):
                row[col] = int(col.split("_")[-1] == prop)

        # ---- dataframe ----
        df = pd.DataFrame([row])
        df = df.reindex(columns=self.features, fill_value=0)

        # ---- fill missing ----
        df = df.fillna(self.medians)

        return df

    def predict(self, df):
        log_price = self.model.predict(df)[0]
        return np.expm1(log_price)