// Portfolio position model
import 'package:equatable/equatable.dart';

class PortfolioPosition extends Equatable {
  final String symbol;
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final double unrealizedPL;
  final double unrealizedPLPercent;

  const PortfolioPosition({
    required this.symbol,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.unrealizedPL,
    required this.unrealizedPLPercent,
  });

  bool get isProfit => unrealizedPL >= 0;

  double get marketValue => quantity * currentPrice;
  double get costBasis => quantity * averagePrice;

  PortfolioPosition copyWith({
    String? symbol,
    int? quantity,
    double? averagePrice,
    double? currentPrice,
    double? unrealizedPL,
    double? unrealizedPLPercent,
  }) {
    return PortfolioPosition(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      averagePrice: averagePrice ?? this.averagePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      unrealizedPL: unrealizedPL ?? this.unrealizedPL,
      unrealizedPLPercent: unrealizedPLPercent ?? this.unrealizedPLPercent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'currentPrice': currentPrice,
      'unrealizedPL': unrealizedPL,
      'unrealizedPLPercent': unrealizedPLPercent,
    };
  }

  factory PortfolioPosition.fromJson(Map<String, dynamic> json) {
    return PortfolioPosition(
      symbol: json['symbol'] as String,
      quantity: json['quantity'] as int,
      averagePrice: (json['averagePrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      unrealizedPL: (json['unrealizedPL'] as num).toDouble(),
      unrealizedPLPercent: (json['unrealizedPLPercent'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    symbol,
    quantity,
    averagePrice,
    currentPrice,
    unrealizedPL,
    unrealizedPLPercent,
  ];
}
