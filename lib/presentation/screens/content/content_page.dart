// Content page with news feed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../localization/app_localizations.dart';
import '../../providers/news_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/market_header.dart';
import '../../widgets/common/notification_bell.dart';
import '../../widgets/common/profile_avatar.dart';

class ContentPage extends ConsumerStatefulWidget {
  const ContentPage({super.key});

  @override
  ConsumerState<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  int _selectedTab = 1; // Breaking is default
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final articles = ref.watch(newsProvider);
    final isThaiLanguage = ref.watch(settingsProvider).languageCode == 'th';

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
                    child: const MarketHeader(showLogo: true, title: 'Content'),
                  ),
                  const NotificationBell(),
                  const SizedBox(width: 16),
                  ProfileAvatar(onTap: () {}),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.search,
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab(l10n.popular, 0),
                  const SizedBox(width: 24),
                  _buildTab(l10n.breaking, 1),
                  const SizedBox(width: 24),
                  _buildTab(l10n.research, 2),
                ],
              ),
            ),

            const Divider(height: 1),

            // News feed
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.read(newsProvider.notifier).refresh();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return _buildArticleCard(article, isThaiLanguage);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected
                  ? AppColors.primaryBlue
                  : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(height: 2, width: 40, color: AppColors.primaryBlue)
          else
            const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildArticleCard(article, bool isThaiLanguage) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        // Navigate to article detail
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with emoji
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  article.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Timestamp
          Text(
            Formatters.formatTimeAgo(
              article.timestamp,
              isThaiLanguage: isThaiLanguage,
            ),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),

          const SizedBox(height: 8),

          // Preview text
          Text(
            article.preview,
            style: AppTextStyles.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Read more link
          Text(
            l10n.readMore,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
