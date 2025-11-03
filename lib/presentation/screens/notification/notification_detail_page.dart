// Notification detail page showing full notification content
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/notification.dart';

class NotificationDetailPage extends StatelessWidget {
  final AppNotification notification;

  const NotificationDetailPage({super.key, required this.notification});

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notificationDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (notificationDate == today) {
      return 'Today ${Formatters.formatTime(timestamp)}';
    } else if (notificationDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${Formatters.formatTime(timestamp)}';
    } else {
      return Formatters.formatDate(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(notification.title, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            Text(
              _formatTimestamp(notification.timestamp),
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            // Full message content
            Text(notification.message, style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}
