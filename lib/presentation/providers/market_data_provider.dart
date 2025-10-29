// Market data provider for SET index
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/market_data.dart';
import '../../data/repositories/mock_data_repository.dart';

final marketDataProvider =
    StateNotifierProvider<MarketDataNotifier, MarketData>((ref) {
      return MarketDataNotifier();
    });

class MarketDataNotifier extends StateNotifier<MarketData> {
  MarketDataNotifier() : super(MockDataRepository.getMockMarketData());

  void refresh() {
    // Simulate refresh with slightly different values
    state = MockDataRepository.getMockMarketData();
  }
}
