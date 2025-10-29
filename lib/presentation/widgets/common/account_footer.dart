// Account footer widget showing trading account info
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../localization/app_localizations.dart';
import '../../providers/auth_provider.dart';

class AccountFooter extends ConsumerWidget {
  const AccountFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${l10n.tradingAccount} ',
                    style: AppTextStyles.bodySmall,
                  ),
                  const Icon(
                    Icons.arrow_drop_up,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                ],
              ),
              Text(
                user?.accountNumber ?? '70426672(C)',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.lineAvailable, style: AppTextStyles.bodySmall),
              const Text('0.00', style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(l10n.cashBalance, style: AppTextStyles.bodySmall),
                  const Icon(
                    Icons.arrow_drop_up,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                ],
              ),
              const Text('0.00', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
