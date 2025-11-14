// Privacy policy display page
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: November 14, 2025',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            
            // Information Collection Section
            _buildSection(
              context,
              'Information Collection',
              'We collect information that you provide directly to us, including when you create an account, make transactions, or communicate with us. This may include your name, email address, phone number, identification documents, and financial information.',
            ),
            
            // How We Use Your Information
            _buildSection(
              context,
              'How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, respond to your comments and questions, and protect against fraudulent or illegal activity.',
            ),
            
            // Data Security
            _buildSection(
              context,
              'Data Security',
              'We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the Internet is 100% secure.',
            ),
            
            // Information Sharing
            _buildSection(
              context,
              'Information Sharing',
              'We do not share your personal information with third parties except as described in this policy. We may share information with service providers who perform services on our behalf, or when required by law.',
            ),
            
            // Your Rights
            _buildSection(
              context,
              'Your Rights',
              'You have the right to access, correct, or delete your personal information. You may also object to or restrict certain processing of your data. To exercise these rights, please contact us using the information below.',
            ),
            
            // Contact Us
            _buildSection(
              context,
              'Contact Us',
              'If you have questions or concerns about this Privacy Policy or our data practices, please contact us at:\n\nEmail: support@liberator.co.th\nPhone: +66 (0) 2-123-4567\nAddress: Bangkok, Thailand',
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

