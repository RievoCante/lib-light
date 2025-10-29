// Stock list item model for stock list display
import 'package:equatable/equatable.dart';

class StockListItem extends Equatable {
  final String symbol;
  final String fullName;
  final String shortName;
  final double currentPrice;
  final double change;
  final double percentChange;
  final String currency;

  const StockListItem({
    required this.symbol,
    required this.fullName,
    required this.shortName,
    required this.currentPrice,
    required this.change,
    required this.percentChange,
    required this.currency,
  });

  bool get isPositive => change >= 0;

  @override
  List<Object?> get props => [
    symbol,
    fullName,
    shortName,
    currentPrice,
    change,
    percentChange,
    currency,
  ];

  factory StockListItem.fromJson(Map<String, dynamic> json) {
    return StockListItem(
      symbol: json['symbol'] as String,
      fullName: json['fullName'] as String,
      shortName: json['shortName'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      percentChange: (json['percentChange'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'fullName': fullName,
      'shortName': shortName,
      'currentPrice': currentPrice,
      'change': change,
      'percentChange': percentChange,
      'currency': currency,
    };
  }
}
