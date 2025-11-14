// Privacy policy display page with markdown support
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Future<String> _loadPrivacyPolicy(BuildContext context) async {
    // Get current language code
    final languageCode = Localizations.localeOf(context).languageCode;
    final filename = 'assets/privacy_policy_$languageCode.md';

    try {
      // Try to load language-specific file
      return await rootBundle.loadString(filename);
    } catch (e) {
      // Fallback to English if language file doesn't exist
      return await rootBundle.loadString('assets/privacy_policy_en.md');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<String>(
        future: _loadPrivacyPolicy(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading privacy policy: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No privacy policy found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return Markdown(
            data: snapshot.data!,
            padding: const EdgeInsets.all(16),
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  h1: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  h2: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  h3: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  p: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.6),
                  listBullet: Theme.of(context).textTheme.bodyMedium,
                  blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  strong: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
          );
        },
      ),
    );
  }
}
