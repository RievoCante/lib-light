// Account page displaying user information
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/profile_avatar.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  String _formatAuthProvider(String? provider) {
    switch (provider) {
      case 'google':
        return 'Google';
      case 'email':
        return 'Email';
      case 'phone':
        return 'Phone';
      default:
        return provider ?? 'N/A';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: authState.when(
        data: (userData) {
          if (userData == null) {
            return const Center(child: Text('No user data available'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),

                // Profile Section
                const ProfileAvatar(size: 80),
                const SizedBox(height: 16),
                if (userData.displayName != null &&
                    userData.displayName!.isNotEmpty)
                  Text(userData.displayName!, style: AppTextStyles.h2)
                else
                  Text(
                    'No name',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textGrey),
                  ),
                const SizedBox(height: 8),
                if (userData.email != null && userData.email!.isNotEmpty)
                  Text(
                    userData.email!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                const SizedBox(height: 32),

                // Account Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Details',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(label: 'User ID', value: userData.uid),
                      if (userData.accountNumber != null &&
                          userData.accountNumber!.isNotEmpty)
                        _InfoRow(
                          label: 'Account Number',
                          value: userData.accountNumber!,
                        ),
                      _InfoRow(
                        label: 'Auth Provider',
                        value: _formatAuthProvider(userData.authProvider),
                      ),
                    ],
                  ),
                ),

                // Contact Info Section
                if (userData.phoneNumber != null &&
                    userData.phoneNumber!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Info',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Phone Number',
                          value: userData.phoneNumber!,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error loading account information: $error',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
