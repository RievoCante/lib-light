// Renovated Buy & Sell page - clean and beginner-friendly
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/stock_list_item.dart';
import '../../../data/repositories/mock_data_repository.dart';
import '../../widgets/common/market_header.dart';
import '../../widgets/common/profile_avatar.dart';
import '../../widgets/common/notification_bell.dart';
import '../../widgets/stock/stock_list_tile.dart';
import 'stock_detail_page.dart';
import 'stock_search_page.dart';

class BuySellPage extends ConsumerStatefulWidget {
  const BuySellPage({super.key});

  @override
  ConsumerState<BuySellPage> createState() => _BuySellPageState();
}

class _BuySellPageState extends ConsumerState<BuySellPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _marketTabs = ['Thai Stock', 'US Stock', 'Mutual Fund'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: MarketHeader(showLogo: false)),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _openSearch(),
            ),
            const NotificationBell(),
            const SizedBox(width: 8),
            ProfileAvatar(onTap: () {}),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _marketTabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStockList('thai'),
          _buildStockList('us'),
          _buildStockList('mutual_fund'),
        ],
      ),
    );
  }

  Widget _buildStockList(String marketType) {
    // Get stock list based on market type
    final stocks = _getStocksForMarket(marketType);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: stocks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return StockListTile(
          stock: stock,
          onTap: () => _navigateToStockDetail(stock, marketType),
        );
      },
    );
  }

  List<StockListItem> _getStocksForMarket(String marketType) {
    switch (marketType) {
      case 'thai':
        return MockDataRepository.getThaiStocksList();
      case 'us':
        // For now, use same data - can be replaced with actual US stocks
        return _getMockUSStocks();
      case 'mutual_fund':
        // For now, use same data - can be replaced with actual mutual funds
        return _getMockMutualFunds();
      default:
        return MockDataRepository.getThaiStocksList();
    }
  }

  List<StockListItem> _getMockUSStocks() {
    // Mock US stocks - can be replaced with real data
    return const [
      StockListItem(
        symbol: 'AAPL',
        fullName: 'Apple Inc.',
        shortName: 'Apple',
        currentPrice: 175.50,
        change: -2.15,
        percentChange: -1.21,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'TSLA',
        fullName: 'Tesla, Inc.',
        shortName: 'Tesla',
        currentPrice: 245.30,
        change: 5.80,
        percentChange: 2.42,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'NVDA',
        fullName: 'NVIDIA Corporation',
        shortName: 'NVIDIA',
        currentPrice: 485.20,
        change: -8.50,
        percentChange: -1.72,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'MSFT',
        fullName: 'Microsoft Corporation',
        shortName: 'Microsoft',
        currentPrice: 378.90,
        change: 3.20,
        percentChange: 0.85,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'GOOGL',
        fullName: 'Alphabet Inc.',
        shortName: 'Google',
        currentPrice: 142.85,
        change: -1.15,
        percentChange: -0.80,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'AMZN',
        fullName: 'Amazon.com, Inc.',
        shortName: 'Amazon',
        currentPrice: 178.60,
        change: 2.40,
        percentChange: 1.36,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'META',
        fullName: 'Meta Platforms, Inc.',
        shortName: 'Meta',
        currentPrice: 485.75,
        change: 8.25,
        percentChange: 1.73,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'NFLX',
        fullName: 'Netflix, Inc.',
        shortName: 'Netflix',
        currentPrice: 625.40,
        change: -10.60,
        percentChange: -1.67,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'AMD',
        fullName: 'Advanced Micro Devices, Inc.',
        shortName: 'AMD',
        currentPrice: 165.20,
        change: 4.80,
        percentChange: 2.99,
        currency: 'USD',
      ),
      StockListItem(
        symbol: 'INTC',
        fullName: 'Intel Corporation',
        shortName: 'Intel',
        currentPrice: 45.30,
        change: -0.70,
        percentChange: -1.52,
        currency: 'USD',
      ),
    ];
  }

  List<StockListItem> _getMockMutualFunds() {
    // Mock mutual funds - can be replaced with real data
    return const [
      StockListItem(
        symbol: 'KFEQUITY',
        fullName: 'K-FEEDER EQUITY',
        shortName: 'K-FEQ',
        currentPrice: 15.2548,
        change: 0.1250,
        percentChange: 0.83,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'SCBSET50',
        fullName: 'SCB SET 50 INDEX',
        shortName: 'SCB SET50',
        currentPrice: 22.8950,
        change: -0.2150,
        percentChange: -0.93,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'KTSE',
        fullName: 'K-TRADE STRATEGY',
        shortName: 'K-TSE',
        currentPrice: 18.5620,
        change: 0.3420,
        percentChange: 1.88,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'TMBGQG',
        fullName: 'TMB GLOBAL QUALITY GROWTH',
        shortName: 'TMB GQG',
        currentPrice: 12.3450,
        change: -0.1050,
        percentChange: -0.84,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'BBLAM-TGROWTH',
        fullName: 'BBL ASSET THAI GROWTH',
        shortName: 'BBL TGROWTH',
        currentPrice: 25.6780,
        change: 0.4280,
        percentChange: 1.70,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'KFGBOND',
        fullName: 'K-FEEDER GLOBAL BOND',
        shortName: 'K-FGB',
        currentPrice: 10.8920,
        change: -0.0320,
        percentChange: -0.29,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'SCBDIVIDEND',
        fullName: 'SCB DIVIDEND STOCK',
        shortName: 'SCB DIV',
        currentPrice: 14.5630,
        change: 0.1830,
        percentChange: 1.27,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'KTECHNO',
        fullName: 'K-TECHNOLOGY',
        shortName: 'K-TECH',
        currentPrice: 32.4210,
        change: -0.8790,
        percentChange: -2.64,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'TMBASIA',
        fullName: 'TMB ASIA OPPORTUNITY',
        shortName: 'TMB ASIA',
        currentPrice: 19.7850,
        change: 0.5650,
        percentChange: 2.94,
        currency: 'THB',
      ),
      StockListItem(
        symbol: 'BBLAM-INFRA',
        fullName: 'BBL INFRASTRUCTURE',
        shortName: 'BBL INFRA',
        currentPrice: 11.2340,
        change: -0.1560,
        percentChange: -1.37,
        currency: 'THB',
      ),
    ];
  }

  void _navigateToStockDetail(StockListItem stock, String marketType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StockDetailPage(stockItem: stock, marketType: marketType),
      ),
    );
  }

  void _openSearch() {
    final currentMarketType = [
      'thai',
      'us',
      'mutual_fund',
    ][_tabController.index];
    final stocks = _getStocksForMarket(currentMarketType);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StockSearchPage(allStocks: stocks, marketType: currentMarketType),
      ),
    );
  }
}
