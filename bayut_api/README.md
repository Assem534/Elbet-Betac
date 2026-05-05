# 🏘️ Bayut Egypt — FastAPI Price Prediction

## تشغيل الـ API

```bash
# 1. ثبّت المكتبات
pip install fastapi uvicorn python-multipart

# 2. شغّل السيرفر
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## الـ Endpoints

| Method | URL | الوظيفة |
|---|---|---|
| GET | `/` | تأكد إن السيرفر شغال |
| GET | `/options` | جيب كل الخيارات للـ dropdown |
| POST | `/predict` | توقع سعر العقار |
| GET | `/health` | حالة السيرفر |

---

## مثال Request من Flutter

```dart
// ─── Flutter Code ───────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;

class PropertyPriceService {
  static const String baseUrl = 'http://YOUR_SERVER_IP:8000';

  // ① جيب الخيارات للـ dropdowns
  static Future<Map<String, dynamic>> getOptions() async {
    final response = await http.get(Uri.parse('$baseUrl/options'));
    return jsonDecode(response.body);
  }

  // ② ابعت بيانات العقار واستقبل السعر
  static Future<Map<String, dynamic>> predictPrice({
    required double area,
    required int rooms,
    required int baths,
    required String province,
    required String city,
    required String propertyType,
    required String furnishingStatus,
    required String completionStatus,
    bool hasPool = false,
    bool hasGym = false,
    bool hasParking = false,
    bool hasGarden = false,
    bool hasSecurity = false,
    bool hasBalcony = false,
  }) async {

    final body = jsonEncode({
      "area":               area,
      "rooms":              rooms,
      "baths":              baths,
      "province":           province,        // "القاهرة" أو "Cairo"
      "city":               city,            // "القاهرة الجديدة" أو "New Cairo"
      "property_type":      propertyType,    // "شقة" أو "Apartments"
      "furnishing_status":  furnishingStatus, // "مفروش" أو "furnished"
      "completion_status":  completionStatus, // "تسليم فوري" أو "completed"
      "has_swimming_pool":  hasPool,
      "has_gym":            hasGym,
      "has_covered_parking": hasParking,
      "has_garden":         hasGarden,
      "has_security":       hasSecurity,
      "has_balcony":        hasBalcony,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل في التوقع: ${response.body}');
    }
  }
}

// ─── Response اللي بترجع ─────────────────────────────────
// {
//   "predicted_price": 1992688,
//   "price_range_low": 1715122,
//   "price_range_high": 2315173,
//   "currency": "EGP",
//   "confidence": "عالية",
//   "property_summary": {
//     "area": 150,
//     "rooms": 3,
//     "baths": 2,
//     "city": "القاهرة الجديدة",
//     "property_type": "شقة",
//     "price_per_sqm": 13284
//   }
// }
```

---

## مثال Request بـ curl للتجربة

```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "area": 150,
    "rooms": 3,
    "baths": 2,
    "province": "القاهرة",
    "city": "القاهرة الجديدة",
    "property_type": "شقة",
    "furnishing_status": "غير مفروش",
    "completion_status": "تسليم فوري",
    "has_covered_parking": true,
    "has_security": true
  }'
```

---

## هيكل الملفات

```
bayut_api/
├── main.py          ← الـ FastAPI (هنا الكود كله)
├── models/          ← انسخ من bayut_project/models/
│   ├── best_model.pkl
│   ├── target_encoders.pkl
│   └── feature_columns.pkl
└── data/
    └── X_train.csv  ← انسخ من bayut_project/data/
```

---

## أنواع العقارات المدعومة

| عربي | إنجليزي | عدد العينات |
|---|---|---|
| شقة | Apartments | 2,029 |
| فيلا | Villas | 719 |
| شاليه | Chalets | 549 |
| تاون هاوس | Townhouses | 240 |
| توين هاوس | Twin Houses | 134 |
| دوبلكس | Duplexes | 111 |
| بنتهاوس | Penthouses | 97 |
| فيلا مستقلة | iVillas | 64 |

## المحافظات المدعومة

القاهرة، الجيزة، مطروح، الإسكندرية، السويس، البحر الأحمر، الدقهلية، دمياط، سيناء، الشرقية
