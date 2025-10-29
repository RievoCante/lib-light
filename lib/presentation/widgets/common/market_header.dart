// Reusable market header widget displaying SET index
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/market_data_provider.dart';

class MarketHeader extends ConsumerWidget {
  final bool showLogo;
  final String? title;

  const MarketHeader({super.key, this.showLogo = false, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketData = ref.watch(marketDataProvider);

    return Row(
      children: [
        if (showLogo) ...[
          // Liberator logo (simplified as colored box for now)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.bar_chart, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (title != null) ...[
          Text(title!, style: AppTextStyles.h3),
          const Spacer(),
        ] else
          const Spacer(),

        // SET Index display
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${marketData.index} ${Formatters.formatNumber(marketData.value)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: marketData.isPositive
                        ? AppColors.positive
                        : AppColors.negative,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatPriceChange(marketData.change),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: marketData.isPositive
                        ? AppColors.positive
                        : AppColors.negative,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(marketData.marketCap, style: AppTextStyles.bodySmall),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.statusGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
