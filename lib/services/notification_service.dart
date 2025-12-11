import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification_model.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications';
  static const String _unreadCountKey = 'unread_count';

  // Get all notifications
  static Future<List<NotificationItem>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString(_notificationsKey);
      
      if (notificationsJson == null) {
        return _getDefaultNotifications();
      }
      
      final List<dynamic> decoded = json.decode(notificationsJson);
      return decoded.map((item) => NotificationItem.fromJson(item)).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return _getDefaultNotifications();
    }
  }

  // Get unread notifications
  static Future<List<NotificationItem>> getUnreadNotifications() async {
    final notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).toList();
  }

  // Get unread count
  static Future<int> getUnreadCount() async {
    final unread = await getUnreadNotifications();
    return unread.length;
  }

  // Add new notification
  static Future<void> addNotification(NotificationItem notification) async {
    try {
      final notifications = await getNotifications();
      notifications.insert(0, notification); // Add to beginning
      
      // Keep only last 50 notifications
      if (notifications.length > 50) {
        notifications.removeRange(50, notifications.length);
      }
      
      await _saveNotifications(notifications);
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  // Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);
      
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all as read
  static Future<void> markAllAsRead() async {
    try {
      final notifications = await getNotifications();
      final updatedNotifications = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      await _saveNotifications(updatedNotifications);
    } catch (e) {
      print('Error marking all as read: $e');
    }
  }

  // Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      final notifications = await getNotifications();
      notifications.removeWhere((n) => n.id == notificationId);
      await _saveNotifications(notifications);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Clear all notifications
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
      await prefs.remove(_unreadCountKey);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  // Save notifications to storage
  static Future<void> _saveNotifications(List<NotificationItem> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_notificationsKey, json.encode(jsonList));
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  // Generate default notifications for demo
  static List<NotificationItem> _getDefaultNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: '1',
        title: 'Selamat Datang di Infoin! 🎉',
        message: 'Terima kasih telah bergabung. Dapatkan berita terbaru setiap hari!',
        type: 'system',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Berita Trending',
        message: 'Ada 5 berita trending hari ini yang mungkin Anda suka',
        type: 'news',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Komunitas Aktif',
        message: '10 berita baru telah dibagikan oleh komunitas',
        type: 'community',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  // Create notification for new community post
  static Future<void> notifyNewCommunityPost(String title, String author) async {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Berita Komunitas Baru',
      message: '$author membagikan: $title',
      type: 'community',
      timestamp: DateTime.now(),
    );
    await addNotification(notification);
  }

  // Create notification for trending news
  static Future<void> notifyTrendingNews(String title) async {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '🔥 Berita Trending',
      message: title,
      type: 'news',
      timestamp: DateTime.now(),
    );
    await addNotification(notification);
  }
}
