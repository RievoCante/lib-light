// Notification state management provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification.dart';
import '../../data/repositories/mock_data_repository.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<AppNotification>>((ref) {
      return NotificationNotifier();
    });

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier() : super(MockDataRepository.getMockNotifications());

  // Mark notification as read
  void markAsRead(String notificationId) {
    state = [
      for (final notification in state)
        if (notification.id == notificationId)
          notification.copyWith(isRead: true)
        else
          notification,
    ];
  }

  // Mark all as read
  void markAllAsRead() {
    state = [
      for (final notification in state) notification.copyWith(isRead: true),
    ];
  }

  // Get unread count
  int get unreadCount => state.where((n) => !n.isRead).length;
}

// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((n) => !n.isRead).length;
});
