// Portfolio provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/portfolio.dart';
import '../../data/repositories/mock_data_repository.dart';

final portfolioProvider =
    StateNotifierProvider<PortfolioNotifier, List<PortfolioPosition>>((ref) {
      return PortfolioNotifier();
    });

class PortfolioNotifier extends StateNotifier<List<PortfolioPosition>> {
  PortfolioNotifier() : super(MockDataRepository.getMockPortfolio());

  void loadPortfolio({bool withData = false}) {
    state = MockDataRepository.getMockPortfolio(withData: withData);
  }

  void sortBy(String field, {bool ascending = true}) {
    final sorted = List<PortfolioPosition>.from(state);

    sorted.sort((a, b) {
      int comparison;

      switch (field) {
        case 'symbol':
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        case 'averagePrice':
          comparison = a.averagePrice.compareTo(b.averagePrice);
          break;
        case 'currentPrice':
          comparison = a.currentPrice.compareTo(b.currentPrice);
          break;
        case 'unrealizedPLPercent':
          comparison = a.unrealizedPLPercent.compareTo(b.unrealizedPLPercent);
          break;
        default:
          comparison = 0;
      }

      return ascending ? comparison : -comparison;
    });

    state = sorted;
  }

  double get totalMarketValue {
    return state.fold(0.0, (sum, position) => sum + position.marketValue);
  }

  double get totalUnrealizedPL {
    return state.fold(
      0.0,
      (sum, position) => sum + (position.unrealizedPL * position.quantity),
    );
  }
}
