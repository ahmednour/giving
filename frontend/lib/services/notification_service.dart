import 'package:flutter/foundation.dart';
import 'package:giving_bridge/models/notification.dart';
import 'package:giving_bridge/services/api_service.dart';

class NotificationService with ChangeNotifier {
  final ApiService _apiService;

  List<Notification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;

  NotificationService(this._apiService);

  // Getters
  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  // Get all notifications for the current user
  Future<void> getMyNotifications() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.getList<Notification>(
        '/notifications',
        Notification.fromJson,
        'notifications',
      );

      if (response.isSuccess) {
        _notifications = response.data ?? [];
        _updateUnreadCount();
      } else {
        _setError(response.error ?? 'Failed to load notifications');
      }
    } catch (e) {
      _setError('Failed to load notifications: $e');
    }

    _setLoading(false);
  }

  // Mark a specific notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      final response =
          await _apiService.put('/notifications/$notificationId/read', {});
      if (response.isSuccess) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = Notification(
            id: _notifications[index].id,
            userId: _notifications[index].userId,
            message: _notifications[index].message,
            isRead: true, // Mark as read
            createdAt: _notifications[index].createdAt,
          );
          _updateUnreadCount();
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiService.put('/notifications', {});
      if (response.isSuccess) {
        _notifications = _notifications
            .map((n) => Notification(
                  id: n.id,
                  userId: n.userId,
                  message: n.message,
                  isRead: true, // Mark all as read
                  createdAt: n.createdAt,
                ))
            .toList();
        _updateUnreadCount();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
