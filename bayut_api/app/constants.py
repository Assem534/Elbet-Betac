PROVINCE_MAP = {
    "Alexandria": "الإسكندرية",
    "Asyut": "أسيوط",
    "Cairo": "القاهرة",
    "Dakahlia": "الدقهلية",
    "Damietta": "دمياط",
    "Gharbia": "الغربية",
    "Giza": "الجيزة",
    "Ismailia": "الإسماعيلية",
    "Matruh": "مطروح",
    "Port Said": "بور سعيد",
    "Red Sea": "البحر الأحمر",
    "Sharqia": "الشرقية",
    "Sinai": "سيناء",
    "Suez": "السويس",
}

CITY_MAP = {
    "6th of October": "6 أكتوبر",
    "Agami": "عجمي",
    "Ain Sukhna": "العين السخنة",
    "Alamein": "العلمين",
    "Alexandria": "الإسكندرية",
    "Amreya": "العامرية",
    "Badr City": "مدينة بدر",
    "Borg al-Arab": "برج العرب",
    "Cairo": "القاهرة",
    "Camp Caesar": "كامب شيزار",
    "Glim": "جليم",
    "Gouna": "الجونة",
    "Hadayek October": "حدائق اكتوبر",
    "Hurghada": "الغردقة",
    "Kafr Abdo": "كفر عبدو",
    "Katameya": "القطامية",
    "Maadi": "المعادي",
    "Madinaty": "مدينتي",
    "Miami": "ميامي",
    "Moharam Bik": "محرّم بيك",
    "Mokattam": "المقطم",
    "Mostakbal City": "مدينة المستقبل",
    "Nasr City": "مدينة نصر",
    "New Cairo": "القاهرة الجديدة",
    "New Capital City": "العاصمة الإدارية الجديدة",
    "New Heliopolis": "هليوبوليس الجديدة",
    "North Coast": "الساحل الشمالي",
    "Obour City": "العبور",
    "Red Sea": "البحر الأحمر",
    "Roushdy": "رشدي",
    "Sheikh Zayed": "الشيخ زايد",
    "Sheraton": "شيراتون",
    "Shorouk City": "مدينة الشروق",
    "Sidi Beshr": "سيدي بشر",
    "Sidi Gaber": "سيدي جابر",
    "Smoha": "سموحة",
    "Stanley": "ستانلي",
    "Zamalek": "الزمالك",
}

PROPERTY_TYPE_MAP = {
    "Apartments": "شقق",
    "Cabins": "كبائن",
    "Chalets": "شاليهات",
    "Duplexes": "دوبليكس",
    "Hotel Apartments": "شقق فندقية",
    "Lands": "أراضي",
    "Other Residential": "وحدات سكنية أخرى",
    "Penthouses": "بنتهاوس",
    "Roofs": "روف",
    "Rooms": "غرف",
    "Townhouses": "تاون هاوس",
    "Twin Houses": "توين هاوس",
    "Villas": "فيلات",
    "iVillas": "آي فيلا",
}

FURNISHING_MAP = {
    "unfurnished": "غير مفروش",
    "furnished": "مفروش",
    "unknown": "غير محدد",
}

COMPLETION_MAP = {
    "completed": "تسليم فوري",
    "under-construction": "تحت الإنشاء",
}

# Reverse maps — support both EN and AR as lookup keys
ALL_PROVINCES = {v: k for k, v in PROVINCE_MAP.items()} | PROVINCE_MAP
ALL_CITIES = {v: k for k, v in CITY_MAP.items()} | CITY_MAP
ALL_PROPERTY_TYPES = {v: k for k, v in PROPERTY_TYPE_MAP.items()} | PROPERTY_TYPE_MAP
ALL_FURNISHING = {v: k for k, v in FURNISHING_MAP.items()} | FURNISHING_MAP
ALL_COMPLETION = {v: k for k, v in COMPLETION_MAP.items()} | COMPLETION_MAP