import 'package:flutter/material.dart' hide Notification;
import '../../domain/entities/notification.dart';
import '../../domain/usecases/notification_usecases.dart';

enum NotificationState { initial, loading, loaded, error }

class NotificationViewModel extends ChangeNotifier {
  final GetMyNotificationsUseCase getMyNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;

  NotificationViewModel({
    required this.getMyNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
  });

  NotificationState _state = NotificationState.initial;
  NotificationState get state => _state;

  List<Notification> _notifications = [];
  List<Notification> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotifications({int page = 1}) async {
    if (page == 1) {
      _state = NotificationState.loading;
      notifyListeners();
    }

    final result = await getMyNotificationsUseCase(page: page);
    result.fold(
      (failure) {
        _state = NotificationState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (newNotifications) {
        if (page == 1) {
          _notifications = newNotifications;
        } else {
          _notifications.addAll(newNotifications);
        }
        _state = NotificationState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> loadUnreadCount() async {
    final result = await getUnreadCountUseCase();
    result.fold(
      (failure) => null, // Ignore failures for background count checks
      (count) {
        if (_unreadCount != count) {
          _unreadCount = count;
          notifyListeners();
        }
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    // Optimistic update
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      if (_unreadCount > 0) _unreadCount--;
      notifyListeners();

      final result = await markAsReadUseCase(notificationId);
      result.fold(
        (failure) {
          // Revert on failure
          _notifications[index] = _notifications[index].copyWith(isRead: false);
          _unreadCount++;
          notifyListeners();
        },
        (_) => null,
      );
    }
  }

  Future<void> markAllAsRead() async {
    // Optimistic update
    final updatedNotifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    final previousCount = _unreadCount;
    final previousNotifications = _notifications;

    _notifications = updatedNotifications;
    _unreadCount = 0;
    notifyListeners();

    final result = await markAllAsReadUseCase();
    result.fold(
      (failure) {
        // Revert on failure
        _notifications = previousNotifications;
        _unreadCount = previousCount;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) => null,
    );
  }
}
