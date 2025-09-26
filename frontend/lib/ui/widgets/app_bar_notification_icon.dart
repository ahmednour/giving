import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/services/notification_service.dart';

class AppBarNotificationIcon extends StatelessWidget {
  const AppBarNotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = context.watch<NotificationService>();
    final unreadCount = notificationService.unreadCount;

    return IconButton(
      icon: Badge(
        label: Text(unreadCount.toString()),
        isLabelVisible: unreadCount > 0,
        child: const Icon(Icons.notifications_outlined),
      ),
      tooltip: 'Notifications',
      onPressed: () => context.go('/notifications'),
    );
  }
}
