// Order book widget displaying bids and offers
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../localization/app_localizations.dart';
import '../../providers/stock_provider.dart';

class OrderBookWidget extends ConsumerWidget {
  const OrderBookWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stockState = ref.watch(stockProvider);
    final orderBook = stockState.orderBook;
    final show10Bids = stockState.show10Bids;

    if (orderBook == null) {
      return const SizedBox.shrink();
    }

    final displayBids = show10Bids
        ? orderBook.bids
        : orderBook.bids.take(5).toList();
    final displayOffers = show10Bids
        ? orderBook.offers
        : orderBook.offers.take(5).toList();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          // Tab selector
          Row(
            children: [
              _TabButton(
                text: l10n.bids5,
                isSelected: !show10Bids,
                onTap: () {
                  if (show10Bids) {
                    ref.read(stockProvider.notifier).toggleBidsView();
                  }
                },
              ),
              const SizedBox(width: 8),
              _TabButton(
                text: l10n.bids10,
                isSelected: show10Bids,
                onTap: () {
                  if (!show10Bids) {
                    ref.read(stockProvider.notifier).toggleBidsView();
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Headers
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  l10n.volume,
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l10n.bid,
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l10n.offer,
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l10n.volume,
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const Divider(height: 16),

          // Order book rows
          ...List.generate(displayBids.length, (index) {
            final bid = displayBids[index];
            final offer = index < displayOffers.length
                ? displayOffers[index]
                : null;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      Formatters.formatNumber(
                        bid.volume.toDouble(),
                        decimalPlaces: 0,
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.volumeYellow,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Formatters.formatNumber(bid.price),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.bidRed,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: offer != null
                        ? Text(
                            Formatters.formatNumber(offer.price),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.offerGreen,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 2,
                    child: offer != null
                        ? Text(
                            Formatters.formatNumber(
                              offer.volume.toDouble(),
                              decimalPlaces: 0,
                            ),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.volumeYellow,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
