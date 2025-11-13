// Chat input field widget
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class ChatInput extends StatelessWidget {
  final String placeholder;
  final VoidCallback? onAddPressed;

  const ChatInput({super.key, required this.placeholder, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.note_alt_outlined,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              placeholder,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDarkMode ? Colors.white54 : Colors.black45,
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onAddPressed,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
