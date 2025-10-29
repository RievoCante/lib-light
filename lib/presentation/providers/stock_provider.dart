// Stock and order book provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/stock.dart';
import '../../data/models/order_book.dart';
import '../../data/repositories/mock_data_repository.dart';

class StockState {
  final String? selectedSymbol;
  final Stock? selectedStock;
  final OrderBook? orderBook;
  final bool show10Bids;

  const StockState({
    this.selectedSymbol,
    this.selectedStock,
    this.orderBook,
    this.show10Bids = false,
  });

  StockState copyWith({
    String? selectedSymbol,
    Stock? selectedStock,
    OrderBook? orderBook,
    bool? show10Bids,
  }) {
    return StockState(
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedStock: selectedStock ?? this.selectedStock,
      orderBook: orderBook ?? this.orderBook,
      show10Bids: show10Bids ?? this.show10Bids,
    );
  }
}

class StockNotifier extends StateNotifier<StockState> {
  StockNotifier() : super(const StockState()) {
    // Load default stock 'A'
    selectStock('A');
  }

  void selectStock(String symbol) {
    final stock = MockDataRepository.getMockStock(symbol);
    final orderBook = MockDataRepository.getMockOrderBook();

    state = state.copyWith(
      selectedSymbol: symbol,
      selectedStock: stock,
      orderBook: orderBook,
    );
  }

  void toggleBidsView() {
    final newShow10Bids = !state.show10Bids;
    final orderBook = newShow10Bids
        ? MockDataRepository.getMockOrderBook10Levels()
        : MockDataRepository.getMockOrderBook();

    state = state.copyWith(show10Bids: newShow10Bids, orderBook: orderBook);
  }

  List<String> searchStocks(String query) {
    if (query.isEmpty) return MockDataRepository.getMockStockSymbols();

    return MockDataRepository.getMockStockSymbols()
        .where((symbol) => symbol.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

final stockProvider = StateNotifierProvider<StockNotifier, StockState>((ref) {
  return StockNotifier();
});
