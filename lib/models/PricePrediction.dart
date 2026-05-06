import 'package:intl/intl.dart';

class PricePrediction {
  final int predictedPrice, priceRangeLow, priceRangeHigh;
  final String currency, confidence;

  PricePrediction({
    required this.predictedPrice,
    required this.priceRangeLow,
    required this.priceRangeHigh,
    required this.currency,
    required this.confidence,
  });

  factory PricePrediction.fromJson(Map<String, dynamic> j) => PricePrediction(
    predictedPrice: j['predicted_price'] as int,
    priceRangeLow: j['price_range_low'] as int,
    priceRangeHigh: j['price_range_high'] as int,
    currency: j['currency'] as String,
    confidence: j['confidence'] as String,
  );

  String _fmt(int n) {
    final formatter = NumberFormat('#,###');
    if (n >= 1000000) return '${formatter.format(n)}';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }

  String get formattedPrice => _fmt(predictedPrice);

  String get formattedRange =>
      '${_fmt(priceRangeLow)} – ${_fmt(priceRangeHigh)} $currency';
}
