# 🏠 Smart Real Estate App — Setup Guide

## Architecture

```
smart_real_estate/
├── lib/                  ← Flutter app
│   ├── main.dart
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── service/ApiService.dart
│   └── Widget/
├── server/               ← Node.js JSON Server (port 3000)
│   ├── server.js
│   ├── data.json
│   └── package.json
└── bayut_api/            ← FastAPI ML Price Predictor (port 8000)
    └── (copy from your bayut_api folder here)
```

---

## Step 1 — Start the JSON Server

```bash
cd server
npm install
npm start
# → running at http://localhost:3000
```

### Endpoints
| Method | URL | Description |
|--------|-----|-------------|
| POST | /login | Authenticate user |
| POST | /register | Create new user |
| GET | /properties | All properties |
| GET | /users/:id | User by ID |
| PATCH | /users/:id | Update user fields |

---

## Step 2 — Start the Bayut ML API

```bash
cd bayut_api
pip install fastapi uvicorn scikit-learn pandas numpy
uvicorn app.main:app --host 0.0.0.0 --port 8000
# → running at http://localhost:8000
```

### Endpoints
| Method | URL | Description |
|--------|-----|-------------|
| POST | /predict | Predict property price |
| GET | /constants | Get dropdown options |
| GET | /health | Health check |

---

## Step 3 — Configure Flutter base URLs

Open `lib/service/ApiService.dart` and update if needed:

```dart
// Android Emulator
const String _jsonServerUrl = 'http://10.0.2.2:3000';
const String _bayutApiUrl   = 'http://10.0.2.2:8000';

// iOS Simulator
const String _jsonServerUrl = 'http://localhost:3000';
const String _bayutApiUrl   = 'http://localhost:8000';

// Physical device (use your PC's LAN IP)
const String _jsonServerUrl = 'http://192.168.1.X:3000';
const String _bayutApiUrl   = 'http://192.168.1.X:8000';
```

---

## Step 4 — Run the Flutter App

```bash
flutter pub get
flutter run
```

---

## Demo Credentials

| Email | Password |
|-------|----------|
| ahmed@example.com | 123 |
| sara@example.com | 456 |
| michael@example.com | 789 |

---

## Key Features

- ✅ Real login / register → JSON Server
- ✅ Properties loaded from server (not static)
- ✅ Favourites synced to server per user
- ✅ **Agent Profile** — shows agent's listings & stats from server
- ✅ **Personal Profile** — logged-in user's properties & favourites
- ✅ **Add Estate** — 3-step form with **AI price prediction** via Bayut ML API
- ✅ All pages fully responsive
