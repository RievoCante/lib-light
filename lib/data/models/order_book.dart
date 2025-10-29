// Order book model for bid/ask data
import 'package:equatable/equatable.dart';

class OrderBookEntry extends Equatable {
  final int volume;
  final double price;

  const OrderBookEntry({required this.volume, required this.price});

  Map<String, dynamic> toJson() {
    return {'volume': volume, 'price': price};
  }

  factory OrderBookEntry.fromJson(Map<String, dynamic> json) {
    return OrderBookEntry(
      volume: json['volume'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [volume, price];
}

class OrderBook extends Equatable {
  final List<OrderBookEntry> bids;
  final List<OrderBookEntry> offers;

  const OrderBook({required this.bids, required this.offers});

  OrderBook copyWith({
    List<OrderBookEntry>? bids,
    List<OrderBookEntry>? offers,
  }) {
    return OrderBook(bids: bids ?? this.bids, offers: offers ?? this.offers);
  }

  Map<String, dynamic> toJson() {
    return {
      'bids': bids.map((e) => e.toJson()).toList(),
      'offers': offers.map((e) => e.toJson()).toList(),
    };
  }

  factory OrderBook.fromJson(Map<String, dynamic> json) {
    return OrderBook(
      bids: (json['bids'] as List)
          .map((e) => OrderBookEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List)
          .map((e) => OrderBookEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [bids, offers];
}
