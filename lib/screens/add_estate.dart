import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/models/PricePrediction.dart';
import 'package:smart_real_estate/models/PropertyPredictRequest.dart';
import 'package:smart_real_estate/screens/addImageProperty.dart';
import '../providers/AuthProvider.dart';
import '../providers/estate_provider.dart';
import '../service/ApiService.dart';

const _provinces = [
  'Cairo',
  'Giza',
  'Alexandria',
  'Red Sea',
  'Suez',
  'Matruh',
  'Sinai',
  'Dakahlia',
  'Sharqia',
  'Gharbia',
  'Ismailia',
  'Port Said',
  'Damietta',
  'Asyut',
];

const _cities = [
  'New Cairo',
  'Nasr City',
  'Maadi',
  'Zamalek',
  'Heliopolis',
  'Sheikh Zayed',
  '6th of October',
  'Madinaty',
  'Shorouk City',
  'New Capital City',
  'Katameya',
  'Mostakbal City',
  'Mokattam',
  'Obour City',
  'Badr City',
  'New Heliopolis',
  'Hurghada',
  'Gouna',
  'Ain Sukhna',
  'North Coast',
  'Alamein',
  'Alexandria',
  'Smoha',
  'Stanley',
  'Glim',
  'Sidi Gaber',
  'Sidi Beshr',
  'Miami',
  'Agami',
  'Borg al-Arab',
  'Camp Caesar',
  'Roushdy',
  'Kafr Abdo',
  'Moharam Bik',
  'Cairo',
];

const _propertyTypes = [
  'Apartments',
  'Villas',
  'Townhouses',
  'Twin Houses',
  'Duplexes',
  'Penthouses',
  'Chalets',
  'Hotel Apartments',
  'Roofs',
  'Rooms',
  'Lands',
  'Cabins',
  'Other Residential',
];

const _furnishingOptions = ['unfurnished', 'furnished', 'unknown'];
const _completionOptions = ['completed', 'under-construction'];

class AddEstatePage extends StatefulWidget {
  const AddEstatePage({super.key});

  @override
  State<AddEstatePage> createState() => _AddEstatePageState();
}

class _AddEstatePageState extends State<AddEstatePage> {
  // ── Form data ──
  final _areaCtrl = TextEditingController();
  int _rooms = 2, _baths = 1;
  final _nameCtrl = TextEditingController();
  final _manualPriceCtrl = TextEditingController();
  String _province = _provinces[0];
  String _city = _cities[0];
  String _propertyType = _propertyTypes[0];
  String _furnishing = _furnishingOptions[0];
  String _completion = _completionOptions[0];
  Map<String, bool> _amenities = {
    'Swimming Pool': false,
    'Gym': false,
    'Parking': false,
    'Garden': false,
    'Security': false,
    'Balcony': false,
    'Jacuzzi': false,
    'Sauna': false,
    'CCTV': false,
  };

  int _step = 0;
  bool _predicting = false;
  PricePrediction? _prediction;
  String? _errorMsg;

  static const Color _green = Color(0xFF8BC34A);
  static const Color _navy = Color(0xFF252B5C);
  static const Color _dark = Color(0xFF1A3460);

  @override
  void dispose() {
    _areaCtrl.dispose();
    super.dispose();
  }


  Future<void> _handlePublish() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final estateProvider = Provider.of<EstateProvider>(context, listen: false);

    if (_nameCtrl.text.isEmpty || _manualPriceCtrl.text.isEmpty) {
      setState(() => _errorMsg = 'Please enter a name and your final price');
      return;
    }

    final String newPropertyId = "p${DateTime.now().millisecondsSinceEpoch}";

    final Map<String, dynamic> newProperty = {
      "id": newPropertyId,
      "name": _nameCtrl.text.trim(),
      "price": _manualPriceCtrl.text.trim(),
      "area": int.tryParse(_areaCtrl.text) ?? 0,
      "rooms": _rooms,
      "baths": _baths,
      "province": _province,
      "city": _city,
      "property_type": _propertyType,
      "furnishing_status": _furnishing,
      "completion_status": _completion,
      "has_swimming_pool": _amenities['Swimming Pool'] ?? false,
      "has_gym": _amenities['Gym'] ?? false,
      "has_covered_parking": _amenities['Parking'] ?? false,
      "has_garden": _amenities['Garden'] ?? false,
      "has_security": _amenities['Security'] ?? false,
      "has_balcony": _amenities['Balcony'] ?? false,
      "has_jacuzzi": _amenities['Jacuzzi'] ?? false,
      "has_sauna": _amenities['Sauna'] ?? false,
      "has_cctv": _amenities['CCTV'] ?? false,
      "lat": 30.0444,
      "lng": 31.2357,
      "rate": 4.0,
      "image": null,
      "owner_id": authProvider.userId,
      "owner_name": authProvider.userName,
      "images": [],
      "review_ids": []
    };

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: _green)),
      );

      await ApiService.addEstate(newProperty);


      final List<String> updatedListingIds = [
        ...authProvider.userProperties,
        newPropertyId
      ];

      await ApiService.updateUser(authProvider.userId!, {
        'my_properties': updatedListingIds
      });

      authProvider.updateUserProperties(updatedListingIds);
      await estateProvider.loadEstates();

      if (mounted) {
        Navigator.pop(context);
        _showPublishSheet(context, (s) => s);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding property: $e')),
      );
    }
  }  Future<void> _predictPrice() async {
    final area = double.tryParse(_areaCtrl.text.trim());
    if (area == null || area <= 0) {
      setState(() => _errorMsg = 'Please enter a valid area in m²');
      return;
    }
    setState(() {
      _predicting = true;
      _errorMsg = null;
    });
    try {
      final result = await ApiService.predictPrice(
        PropertyPredictRequest(
          area: area,
          rooms: _rooms,
          baths: _baths,
          province: _province,
          city: _city,
          propertyType: _propertyType,
          furnishingStatus: _furnishing,
          completionStatus: _completion,
          hasSwimmingPool: _amenities['Swimming Pool']!,
          hasGym: _amenities['Gym']!,
          hasCoveredParking: _amenities['Parking']!,
          hasGarden: _amenities['Garden']!,
          hasSecurity: _amenities['Security']!,
          hasBalcony: _amenities['Balcony']!,
          hasJacuzzi: _amenities['Jacuzzi']!,
          hasSauna: _amenities['Sauna']!,
          hasCctv: _amenities['CCTV']!,
        ),
      );
      setState(() {
        _prediction = result;
        _step = 2;
      });
    } catch (e) {
      setState(
        () => _errorMsg =
            'Prediction failed – is the ML API running?\n'
            'Run: cd bayut_api && uvicorn app.main:app --host 0.0.0.0 --port 8000',
      );
    } finally {
      setState(() => _predicting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double scale = (w / 375).clamp(0.85, 1.3);
    double r(double s) => s * scale;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(r),
            _buildStepIndicator(r),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: r(20),
                  vertical: r(10),
                ),
                physics: const BouncingScrollPhysics(),
                child: _step == 0
                    ? _buildStep1(r)
                    : _step == 1
                    ? _buildStep2(r)
                    : _buildStep3(r),
              ),
            ),
            _buildBottomBar(r),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(double Function(double) r) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r(20), vertical: r(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _step > 0
                ? setState(() => _step--)
                : Navigator.maybePop(context),
            child: Container(
              width: r(40),
              height: r(40),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(r(12)),
              ),
              child: Icon(Icons.arrow_back_ios_new, color: _navy, size: r(16)),
            ),
          ),
          const Spacer(),
          Text(
            _step == 0
                ? 'Property Details'
                : _step == 1
                ? 'Amenities'
                : 'Price Estimate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _navy,
              fontSize: r(16),
            ),
          ),
          const Spacer(),
          SizedBox(width: r(40)),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(double Function(double) r) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r(20)),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: r(4),
                    decoration: BoxDecoration(
                      color: done || active ? _green : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(r(4)),
                    ),
                  ),
                ),
                if (i < 2) SizedBox(width: r(6)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1(double Function(double) r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: r(16)),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: r(22), color: _dark, height: 1.3),
            children: [
              TextSpan(
                text: 'Tell us about\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: 'your property'),
            ],
          ),
        ),
        SizedBox(height: r(24)),

        // Area
        _sectionLabel('Area (m²)', r),
        _inputBox(
          child: TextField(
            controller: _areaCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: r(15), color: _navy),
            decoration: InputDecoration(
              hintText: 'e.g. 120',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: r(16),
                vertical: r(16),
              ),
              suffixText: 'm²',
              suffixStyle: TextStyle(color: _navy, fontWeight: FontWeight.bold),
            ),
          ),
          r: r,
        ),
        SizedBox(height: r(16)),
        _sectionLabel('Property Name', r),
        _inputBox(
          child: TextField(
            controller: _nameCtrl,
            style: TextStyle(fontSize: r(15), color: _navy),
            decoration: InputDecoration(
              hintText: 'e.g. Sunny Apartment',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(r(16)),
            ),
          ),
          r: r,
        ),
        SizedBox(height: r(16)),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Bedrooms', r),
                  _counterBox(_rooms, (v) => setState(() => _rooms = v), r),
                ],
              ),
            ),
            SizedBox(width: r(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Bathrooms', r),
                  _counterBox(_baths, (v) => setState(() => _baths = v), r),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: r(16)),

        // Province
        _sectionLabel('Province', r),
        _dropdownBox(
          value: _province,
          items: _provinces,
          onChanged: (v) => setState(() => _province = v!),
          r: r,
        ),
        SizedBox(height: r(12)),

        _sectionLabel('City', r),
        _dropdownBox(
          value: _city,
          items: _cities,
          onChanged: (v) => setState(() => _city = v!),
          r: r,
        ),
        SizedBox(height: r(12)),

        _sectionLabel('Property Type', r),
        _dropdownBox(
          value: _propertyType,
          items: _propertyTypes,
          onChanged: (v) => setState(() => _propertyType = v!),
          r: r,
        ),
        SizedBox(height: r(12)),

        _sectionLabel('Furnishing Status', r),
        _segmentRow(
          _furnishing,
          _furnishingOptions,
          (v) => setState(() => _furnishing = v),
          r,
        ),
        SizedBox(height: r(12)),

        _sectionLabel('Completion Status', r),
        _segmentRow(
          _completion,
          _completionOptions,
          (v) => setState(() => _completion = v),
          r,
        ),
        SizedBox(height: r(20)),

        if (_errorMsg != null) ...[
          Container(
            padding: EdgeInsets.all(r(12)),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(r(12)),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _errorMsg!,
              style: TextStyle(color: Colors.red.shade700, fontSize: r(12)),
            ),
          ),
          SizedBox(height: r(12)),
        ],
      ],
    );
  }

  Widget _buildStep2(double Function(double) r) {
    final icons = {
      'Swimming Pool': Icons.pool,
      'Gym': Icons.fitness_center,
      'Parking': Icons.local_parking,
      'Garden': Icons.park,
      'Security': Icons.security,
      'Balcony': Icons.balcony,
      'Jacuzzi': Icons.hot_tub,
      'Sauna': Icons.spa,
      'CCTV': Icons.videocam,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: r(16)),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: r(22), color: _dark, height: 1.3),
            children: [
              TextSpan(
                text: 'What amenities\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: 'does it have?'),
            ],
          ),
        ),
        SizedBox(height: r(8)),
        Text(
          'Select all that apply — each one boosts the price estimate.',
          style: TextStyle(color: Colors.grey, fontSize: r(13)),
        ),
        SizedBox(height: r(24)),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: r(10),
          mainAxisSpacing: r(10),
          childAspectRatio: 0.95,
          children: _amenities.keys.map((key) {
            final selected = _amenities[key]!;
            return GestureDetector(
              onTap: () => setState(() => _amenities[key] = !_amenities[key]!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: selected ? _green : const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(r(16)),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: _green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[key] ?? Icons.check_circle_outline,
                      color: selected ? Colors.white : Colors.grey,
                      size: r(26),
                    ),
                    SizedBox(height: r(6)),
                    Text(
                      key,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.grey.shade700,
                        fontSize: r(11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: r(20)),
      ],
    );
  }

  Widget _buildStep3(double Function(double) r) {
    if (_prediction == null) return const SizedBox();

    final amenitiesSelected = _amenities.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: r(16)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(r(24)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A3460), Color(0xFF254F6C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(r(24)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A3460).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF8BC34A),
                    size: 16,
                  ),
                  SizedBox(width: r(6)),
                  Text(
                    'AI Price Estimate',
                    style: TextStyle(color: Colors.white70, fontSize: r(13)),
                  ),
                ],
              ),
              SizedBox(height: r(12)),
              Text(
                '${_prediction!.formattedPrice} EGP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: r(36),
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: r(6)),
              Text(
                'Range: ${_prediction!.formattedRange}',
                style: TextStyle(color: Colors.white70, fontSize: r(13)),
              ),
              SizedBox(height: r(16)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r(16),
                  vertical: r(8),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(r(20)),
                  border: Border.all(color: const Color(0xFF8BC34A), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF8BC34A),
                      size: 14,
                    ),
                    SizedBox(width: r(6)),
                    Text(
                      '${_prediction!.confidence} Confidence',
                      style: TextStyle(
                        color: const Color(0xFF8BC34A),
                        fontSize: r(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: r(24)),

        Text(
          "Finalize Your Listing",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _navy,
            fontSize: r(18),
          ),
        ),
        SizedBox(height: r(12)),

        _sectionLabel('Property Name', r),
        _inputBox(
          child: TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Modern Villa with Pool',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(r(16)),
            ),
          ),
          r: r,
        ),
        SizedBox(height: r(16)),

        _sectionLabel('Your Asking Price (EGP)', r),
        _inputBox(
          child: TextField(
            controller: _manualPriceCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter your final price',
              suffixText: 'EGP',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(r(16)),
            ),
          ),
          r: r,
        ),

        SizedBox(height: r(24)),

        Container(
          padding: EdgeInsets.all(r(20)),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(r(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: r(15),
                  color: _navy,
                ),
              ),
              SizedBox(height: r(16)),
              _summaryRow(Icons.square_foot, 'Area', '${_areaCtrl.text} m²', r),
              _summaryRow(Icons.bed, 'Bedrooms', '$_rooms', r),
              _summaryRow(Icons.bathtub_outlined, 'Bathrooms', '$_baths', r),
              _summaryRow(
                Icons.location_city,
                'Location',
                '$_city, $_province',
                r,
              ),
              _summaryRow(Icons.home_work_outlined, 'Type', _propertyType, r),
              _summaryRow(
                Icons.chair_outlined,
                'Furnishing',
                _furnishing.replaceAll('-', ' '),
                r,
              ),
              _summaryRow(
                Icons.construction_outlined,
                'Completion',
                _completion.replaceAll('-', ' '),
                r,
              ),
              if (amenitiesSelected.isNotEmpty)
                _summaryRow(
                  Icons.star_outline,
                  'Amenities',
                  amenitiesSelected.join(', '),
                  r,
                ),
            ],
          ),
        ),

        SizedBox(height: r(20)),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(Icons.refresh, color: _green, size: r(18)),
                label: Text(
                  'Recalculate',
                  style: TextStyle(color: _green, fontSize: r(14)),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(r(14)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: r(14)),
                ),
                onPressed: () => setState(() {
                  _step = 0;
                  _prediction = null;
                }),
              ),
            ),
            SizedBox(width: r(12)),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.publish, color: Colors.white, size: r(18)),
                label: Text('Publish Now'),
                style: ElevatedButton.styleFrom(backgroundColor: _green),
                onPressed: () {
                  if (_nameCtrl.text.isEmpty || _manualPriceCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a name and price'),
                      ),
                    );
                  } else {
                    _handlePublish();
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(width: r(20)),
      ],
    );
  }

  Widget _buildBottomBar(double Function(double) r) {
    if (_step == 2) return const SizedBox.shrink();
    final isLast = _step == 1;
    return Container(
      padding: EdgeInsets.fromLTRB(r(20), r(12), r(20), r(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: r(54),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r(14)),
            ),
          ),
          onPressed: _predicting
              ? null
              : () {
                  if (isLast) {
                    _predictPrice();
                  } else {
                    final area = double.tryParse(_areaCtrl.text.trim());
                    if (area == null || area <= 0) {
                      setState(
                        () => _errorMsg = 'Please enter a valid area in m²',
                      );
                      return;
                    }
                    setState(() {
                      _step = 1;
                      _errorMsg = null;
                    });
                  }
                },
          child: _predicting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: r(18),
                      height: r(18),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: r(10)),
                    Text(
                      'Predicting price…',
                      style: TextStyle(color: Colors.white, fontSize: r(15)),
                    ),
                  ],
                )
              : Text(
                  isLast ? 'Next' : 'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: r(15),
                  ),
                ),
        ),
      ),
    );
  }


  Widget _sectionLabel(String text, double Function(double) r) {
    return Padding(
      padding: EdgeInsets.only(bottom: r(8)),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: _navy,
          fontSize: r(13),
        ),
      ),
    );
  }

  Widget _inputBox({
    required Widget child,
    required double Function(double) r,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F8),
        borderRadius: BorderRadius.circular(r(12)),
      ),
      child: child,
    );
  }

  Widget _counterBox(
    int value,
    void Function(int) onChange,
    double Function(double) r,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r(12), vertical: r(10)),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F8),
        borderRadius: BorderRadius.circular(r(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _cBtn(Icons.remove, () => onChange(value > 0 ? value - 1 : 0), r),
          Text(
            '$value',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: r(16),
              color: _navy,
            ),
          ),
          _cBtn(Icons.add, () => onChange(value + 1), r),
        ],
      ),
    );
  }

  Widget _cBtn(IconData icon, VoidCallback onTap, double Function(double) r) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: r(28),
        height: r(28),
        decoration: BoxDecoration(
          color: _navy,
          borderRadius: BorderRadius.circular(r(8)),
        ),
        child: Icon(icon, color: Colors.white, size: r(14)),
      ),
    );
  }

  Widget _dropdownBox<T>({
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required double Function(double) r,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F8),
        borderRadius: BorderRadius.circular(r(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          style: TextStyle(color: _navy, fontSize: r(14)),
          icon: Icon(Icons.keyboard_arrow_down, color: _navy, size: r(20)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _segmentRow(
    String selected,
    List<String> options,
    void Function(String) onChanged,
    double Function(double) r,
  ) {
    return Row(
      children: options.map((opt) {
        final isSelected = opt == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: opt != options.last ? r(8) : 0),
              padding: EdgeInsets.symmetric(vertical: r(12)),
              decoration: BoxDecoration(
                color: isSelected ? _navy : const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(r(12)),
              ),
              child: Center(
                child: Text(
                  opt.replaceAll('-', ' '),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: r(12),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _summaryRow(
    IconData icon,
    String label,
    String value,
    double Function(double) r,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: r(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: r(16), color: _green),
          SizedBox(width: r(10)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: r(13), color: Colors.grey),
                children: [
                  TextSpan(text: '$label: '),
                  TextSpan(
                    text: value,
                    style: TextStyle(color: _navy, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPublishSheet(BuildContext context, double Function(double) r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(r(30))),
        ),
        padding: EdgeInsets.all(r(24)),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Container(
              width: r(40),
              height: r(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(r(4)),
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(r(20)),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(r(16)),
                decoration: const BoxDecoration(
                  color: _green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: r(36)),
              ),
            ),
            SizedBox(height: r(20)),
            Text(
              'Listing Published!',
              style: TextStyle(
                fontSize: r(22),
                fontWeight: FontWeight.bold,
                color: _dark,
              ),
            ),
            SizedBox(height: r(8)),

            Text(
              'Your property "${_nameCtrl.text}" is now live.\nListed Price: ${_manualPriceCtrl.text} EGP',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: r(14)),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r(14)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: r(14)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _step = 0;
                        _prediction = null;
                        _areaCtrl.clear();
                      });
                    },
                    child: Text(
                      'Add Another',
                      style: TextStyle(color: _green, fontSize: r(14)),
                    ),
                  ),
                ),
                SizedBox(width: r(12)),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r(14)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: r(14)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close sheet
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/Home',
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Go Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: r(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
