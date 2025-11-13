// Settings (You) page with light theme
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../webview/webview_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.you, style: AppTextStyles.h2),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Setting section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.setting,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Language
          _SettingTile(
            icon: Icons.language,
            title: l10n.language,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  settings.languageCode == 'th' ? l10n.thai : l10n.english,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ],
            ),
            onTap: () {
              _showLanguageDialog(context, ref, l10n);
            },
          ),

          // Dark Theme
          _SettingTile(
            icon: Icons.dark_mode,
            title: l10n.darkTheme,
            trailing: Switch(
              value: settings.isDarkTheme,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setTheme(value);
              },
              activeThumbColor: AppColors.primaryBlue,
            ),
          ),

          // Order Entry
          _SettingTile(
            icon: Icons.edit_document,
            title: l10n.orderEntry,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onTap: () {
              // Navigate to order entry settings
            },
          ),

          const SizedBox(height: 24),

          // Others section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.others,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // E-Service
          _SettingTile(
            icon: Icons.business_center,
            title: l10n.eService,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onTap: () {
              // Navigate to e-services
            },
          ),

          // Contact Us
          _SettingTile(
            icon: Icons.headset_mic,
            title: l10n.contactUs,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onTap: () {
              context.push('/support-chat');
            },
          ),

          // Privacy & Policy
          _SettingTile(
            icon: Icons.shield,
            title: l10n.privacyPolicy,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onTap: () {
              // Navigate to privacy policy
            },
          ),

          // Sign Out
          _SettingTile(
            icon: Icons.logout,
            title: l10n.logout,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onTap: () {
              _showLogoutDialog(context, ref, l10n);
            },
          ),

          const SizedBox(height: 24),

          // Testing section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.testing,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Register (Testing)
          _SettingTile(
            icon: Icons.app_registration,
            title: l10n.register,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onTap: () {
              Navigator.push(
                // open a new screen
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(
                    url: 'https://ndid.liberator.co.th/openaccount/authen',
                    title: l10n.register,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.english),
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.thai),
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage('th');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
