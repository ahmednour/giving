import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/notification.dart' as app_notification;
import 'package:giving_bridge/services/notification_service.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';

class RevampedNotificationsScreen extends StatefulWidget {
  const RevampedNotificationsScreen({super.key});

  @override
  State<RevampedNotificationsScreen> createState() =>
      _RevampedNotificationsScreenState();
}

class _RevampedNotificationsScreenState
    extends State<RevampedNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationService>().getMyNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = context.watch<NotificationService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notificationService.unreadCount > 0)
            TextButton(
              onPressed: () async {
                await context.read<NotificationService>().markAllAsRead();
              },
              child: const Text('Mark All as Read'),
            ),
        ],
      ),
      body: notificationService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationService.notifications.isEmpty
              ? const Center(
                  child: Text('You have no new notifications.'),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      context.read<NotificationService>().getMyNotifications(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: notificationService.notifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          notificationService.notifications[index];
                      return _NotificationCard(notification: notification);
                    },
                  ),
                ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final app_notification.Notification notification;

  const _NotificationCard({required this.notification});

  IconData _getIconForNotification(String message) {
    if (message.contains('request')) {
      return Icons.card_giftcard_outlined;
    } else if (message.contains('approved')) {
      return Icons.check_circle_outline;
    } else if (message.contains('declined') || message.contains('rejected')) {
      return Icons.cancel_outlined;
    }
    return Icons.notifications_none;
  }

  Color _getColorForNotification(String message, BuildContext context) {
    if (message.contains('approved')) {
      return AppColors.success;
    } else if (message.contains('declined') || message.contains('rejected')) {
      return AppColors.error;
    }
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColorForNotification(notification.message, context);
    final icon = _getIconForNotification(notification.message);

    return Opacity(
      opacity: notification.isRead ? 0.6 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          title: Text(
            notification.message,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight:
                  notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            notification.createdAt != null
                ? '${notification.createdAt!.day}/${notification.createdAt!.month}/${notification.createdAt!.year}'
                : 'No date',
            style: theme.textTheme.bodySmall,
          ),
          onTap: () {
            if (!notification.isRead) {
              context.read<NotificationService>().markAsRead(notification.id);
            }
          },
        ),
      ),
    );
  }
}
