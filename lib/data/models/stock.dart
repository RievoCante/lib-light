// Stock quote model
import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String symbol;
  final double currentPrice;
  final String currency;
  final double change;
  final double percentChange;
  final double high;
  final double low;
  final double open;
  final double previousClose;
  final double ceiling;
  final double floor;

  const Stock({
    required this.symbol,
    required this.currentPrice,
    this.currency = 'THB',
    this.change = 0.0,
    this.percentChange = 0.0,
    this.high = 0.0,
    this.low = 0.0,
    this.open = 0.0,
    this.previousClose = 0.0,
    this.ceiling = 0.0,
    this.floor = 0.0,
  });

  bool get isPositive => change >= 0;

  Stock copyWith({
    String? symbol,
    double? currentPrice,
    String? currency,
    double? change,
    double? percentChange,
    double? high,
    double? low,
    double? open,
    double? previousClose,
    double? ceiling,
    double? floor,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      currency: currency ?? this.currency,
      change: change ?? this.change,
      percentChange: percentChange ?? this.percentChange,
      high: high ?? this.high,
      low: low ?? this.low,
      open: open ?? this.open,
      previousClose: previousClose ?? this.previousClose,
      ceiling: ceiling ?? this.ceiling,
      floor: floor ?? this.floor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'currentPrice': currentPrice,
      'currency': currency,
      'change': change,
      'percentChange': percentChange,
      'high': high,
      'low': low,
      'open': open,
      'previousClose': previousClose,
      'ceiling': ceiling,
      'floor': floor,
    };
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'THB',
      change: (json['change'] as num?)?.toDouble() ?? 0.0,
      percentChange: (json['percentChange'] as num?)?.toDouble() ?? 0.0,
      high: (json['high'] as num?)?.toDouble() ?? 0.0,
      low: (json['low'] as num?)?.toDouble() ?? 0.0,
      open: (json['open'] as num?)?.toDouble() ?? 0.0,
      previousClose: (json['previousClose'] as num?)?.toDouble() ?? 0.0,
      ceiling: (json['ceiling'] as num?)?.toDouble() ?? 0.0,
      floor: (json['floor'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
    symbol,
    currentPrice,
    currency,
    change,
    percentChange,
    high,
    low,
    open,
    previousClose,
    ceiling,
    floor,
  ];
}
