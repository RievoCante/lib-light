// Notification bell icon widget
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NotificationBell extends StatelessWidget {
  final VoidCallback? onTap;
  final bool hasNotifications;

  const NotificationBell({
    super.key,
    this.onTap,
    this.hasNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          if (hasNotifications)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.negative,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
