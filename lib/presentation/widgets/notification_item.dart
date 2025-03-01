
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/utils/size_config.dart';
import '../../domain/entities/notification.dart' as entity;

class NotificationItem extends StatelessWidget {
  final entity.Notification notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Define icon based on notification type
    IconData getIconData() {
      switch (notification.type) {
        case 'workout':
          return Icons.fitness_center;
        case 'nutrition':
          return Icons.restaurant;
        case 'progress':
          return Icons.trending_up;
        default:
          return Icons.notifications;
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.smallPadding,
        horizontal: SizeConfig.defaultPadding,
      ),
      color: notification.isRead 
          ? theme.cardTheme.color 
          : theme.colorScheme.primary.withOpacity(0.1),
      elevation: notification.isRead ? 1 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: Icon(
                  getIconData(),
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: SizeConfig.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: notification.isRead 
                                  ? FontWeight.w500 
                                  : FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: onMarkAsRead,
                            tooltip: 'Mark as read',
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.smallPadding),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: SizeConfig.smallPadding),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a').format(notification.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
