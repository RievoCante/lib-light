// Market data model for SET index and market information
import 'package:equatable/equatable.dart';

class MarketData extends Equatable {
  final String index;
  final double value;
  final double change;
  final double percentChange;
  final String marketCap;
  final String status;

  const MarketData({
    required this.index,
    required this.value,
    required this.change,
    required this.percentChange,
    required this.marketCap,
    required this.status,
  });

  bool get isPositive => change >= 0;

  MarketData copyWith({
    String? index,
    double? value,
    double? change,
    double? percentChange,
    String? marketCap,
    String? status,
  }) {
    return MarketData(
      index: index ?? this.index,
      value: value ?? this.value,
      change: change ?? this.change,
      percentChange: percentChange ?? this.percentChange,
      marketCap: marketCap ?? this.marketCap,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'value': value,
      'change': change,
      'percentChange': percentChange,
      'marketCap': marketCap,
      'status': status,
    };
  }

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      index: json['index'] as String,
      value: (json['value'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      percentChange: (json['percentChange'] as num).toDouble(),
      marketCap: json['marketCap'] as String,
      status: json['status'] as String,
    );
  }

  @override
  List<Object?> get props => [
    index,
    value,
    change,
    percentChange,
    marketCap,
    status,
  ];
}
