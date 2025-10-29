// Stock detail page - reusable for all markets (Thai Stock, US Stock, Mutual Fund)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/stock.dart';
import '../../../data/models/stock_list_item.dart';
import '../../../data/repositories/mock_data_repository.dart';
import '../../widgets/stock/buy_sell_modal.dart';

class StockDetailPage extends ConsumerStatefulWidget {
  final StockListItem stockItem;
  final String marketType; // 'thai', 'us', or 'mutual_fund'

  const StockDetailPage({
    super.key,
    required this.stockItem,
    required this.marketType,
  });

  @override
  ConsumerState<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends ConsumerState<StockDetailPage> {
  String _selectedPeriod = '1D';
  bool _isIntroductionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final stock = MockDataRepository.getMockStock(widget.stockItem.symbol);
    final changeColor = stock.percentChange >= 0
        ? AppColors.positive
        : AppColors.negative;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.stockItem.symbol, style: AppTextStyles.h3),
            const SizedBox(width: 8),
            Text(
              '${Formatters.formatPrice(stock.currentPrice)} ',
              style: AppTextStyles.bodyMedium.copyWith(color: changeColor),
            ),
            Text(
              Formatters.formatPercentage(stock.percentChange),
              style: AppTextStyles.bodySmall.copyWith(color: changeColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price and Chart Section
            _buildPriceSection(stock, changeColor),

            // Holdings Section (if user owns this stock)
            _buildHoldingsSection(),

            const Divider(height: 32),

            // About Section
            _buildAboutSection(stock),

            const Divider(height: 32),

            // Resources Section
            _buildResourcesSection(),

            const Divider(height: 32),

            // Introduction Section
            _buildIntroductionSection(),

            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  Widget _buildPriceSection(Stock stock, Color changeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large Price Display
          Text(
            Formatters.formatPrice(stock.currentPrice),
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${stock.change >= 0 ? '+' : ''}${Formatters.formatPrice(stock.change)} (${Formatters.formatPercentage(stock.percentChange)})',
            style: TextStyle(
              fontSize: 16,
              color: changeColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // Simple Chart Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Center(
              child: Icon(
                Icons.show_chart,
                size: 48,
                color: changeColor.withValues(alpha: 0.3),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Time Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['1H', '1D', '1W', '1M', '1Y'].map((period) {
              final isSelected = period == _selectedPeriod;
              return GestureDetector(
                onTap: () => setState(() => _selectedPeriod = period),
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingsSection() {
    // Mock: Check if user has holdings (can be replaced with actual portfolio check)
    const hasHoldings = false;

    if (!hasHoldings) {
      return const SizedBox.shrink();
    }

    // This code will execute when hasHoldings is true
    // Note: There's one linter warning about "dead code" in the holdings section. this is expected and safe. It's placeholder code for when users actually own stocks, which will be implemented later.
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primaryBlue.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your balance', style: AppTextStyles.bodySmall),
              const SizedBox(height: 4),
              Text(
                '0.00026861 ${widget.stockItem.symbol}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('≈฿0.29589141', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Stock stock) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About ${widget.stockItem.symbol}', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildInfoRow('Market Cap', '฿151.90B'),
          _buildInfoRow('High (24h)', Formatters.formatPrice(stock.high)),
          _buildInfoRow('Low (24h)', Formatters.formatPrice(stock.low)),
          _buildInfoRow('Open', Formatters.formatPrice(stock.open)),
          _buildInfoRow(
            'Prev Close',
            Formatters.formatPrice(stock.previousClose),
          ),
          _buildInfoRow('Ceiling', Formatters.formatPrice(stock.ceiling)),
          _buildInfoRow('Floor', Formatters.formatPrice(stock.floor)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resources', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildResourceLink('🔗 Official Website', () {}),
        ],
      ),
    );
  }

  Widget _buildResourceLink(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection() {
    const fullText =
        'is a leading company in the Thai stock market. The company operates in various sectors including energy, petrochemicals, and retail. With a strong presence both domestically and internationally, the company has established itself as a key player in its industry. The company continues to focus on sustainable growth and innovation while maintaining its commitment to stakeholders and the community.';

    const shortText = 'is a leading company in the Thai stock market...';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Introduction', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Text(
            '${widget.stockItem.fullName} (${widget.stockItem.symbol}) ${_isIntroductionExpanded ? fullText : shortText}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _isIntroductionExpanded = !_isIntroductionExpanded;
              });
            },
            child: Text(
              _isIntroductionExpanded ? 'Less' : 'More',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showBuyModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Buy'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showSellModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Sell'),
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BuySellModal(stockItem: widget.stockItem, isBuying: true),
    );
  }

  void _showSellModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BuySellModal(stockItem: widget.stockItem, isBuying: false),
    );
  }
}
