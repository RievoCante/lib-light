// Portfolio page with holdings
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../localization/app_localizations.dart';
import '../../providers/portfolio_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/market_header.dart';
import '../../widgets/common/notification_bell.dart';
import '../../widgets/common/profile_avatar.dart';
import '../../widgets/common/tab_toggle.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/account_footer.dart';
import '../notification/notification_page.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage> {
  int _viewTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final portfolio = ref.watch(portfolioProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: const MarketHeader(
                      showLogo: true,
                      title: 'Portfolio',
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final unreadCount = ref.watch(
                        unreadNotificationCountProvider,
                      );
                      return NotificationBell(
                        hasNotifications: unreadCount > 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  ProfileAvatar(onTap: () {}),
                ],
              ),
            ),

            // Thai notice banner
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.thaiNotice,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // View tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabToggle(
                tabs: [l10n.portfolio, l10n.order, l10n.summary],
                selectedIndex: _viewTabIndex,
                onTabChanged: (index) {
                  setState(() {
                    _viewTabIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Portfolio filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.allPort, style: AppTextStyles.bodyMedium),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Portfolio table
            Expanded(
              child: portfolio.isEmpty
                  ? EmptyState(
                      message: l10n.emptyPortfolio,
                      actionText: l10n.startTrading,
                      onAction: () {},
                      icon: Icons.bar_chart_outlined,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Table headers
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            color: Theme.of(context).cardColor,
                            child: Row(
                              children: [
                                _buildHeader(l10n.symbol, flex: 2),
                                _buildHeader(l10n.inPort, flex: 2),
                                _buildHeader(l10n.avg, flex: 2),
                                _buildHeader(l10n.market, flex: 2),
                                _buildHeader(l10n.uplPercent, flex: 2),
                              ],
                            ),
                          ),

                          // Table rows
                          ...portfolio.map(
                            (position) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.border),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _buildCell(position.symbol, flex: 2),
                                  _buildCell(
                                    position.quantity.toString(),
                                    flex: 2,
                                  ),
                                  _buildCell(
                                    Formatters.formatNumber(
                                      position.averagePrice,
                                    ),
                                    flex: 2,
                                  ),
                                  _buildCell(
                                    Formatters.formatNumber(
                                      position.currentPrice,
                                    ),
                                    flex: 2,
                                  ),
                                  _buildCell(
                                    Formatters.formatPercentage(
                                      position.unrealizedPLPercent,
                                    ),
                                    flex: 2,
                                    color: position.isProfit
                                        ? AppColors.positive
                                        : AppColors.negative,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Total section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.total,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.share,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.shareAll,
                          style: const TextStyle(color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            const AccountFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyles.labelBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.unfold_more,
            color: AppColors.textSecondary,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(color: color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
