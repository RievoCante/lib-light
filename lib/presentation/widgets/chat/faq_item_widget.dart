// FAQ item widget that sends question as message
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/support_message.dart';

class FaqItemWidget extends StatelessWidget {
  final FaqItem faqItem;
  final VoidCallback onTap;

  const FaqItemWidget({super.key, required this.faqItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2B3139) : const Color(0xFF3C4146),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  faqItem.question,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
              Icon(Icons.send, color: Colors.white70, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
