
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/notification.dart' as entity;
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(FetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState();
            }
            return _buildNotificationsList(state.notifications);
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationsLoaded && state.unreadCount > 0) {
            return FloatingActionButton.extended(
              onPressed: () {
                context.read<NotificationBloc>().add(MarkAllNotificationsAsRead());
              },
              icon: const Icon(Icons.done_all),
              label: const Text('Mark all as read'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: SizeConfig.defaultPadding),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: SizeConfig.smallPadding),
          Text(
            'You\'ll be notified about workouts, meals, and progress updates',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<entity.Notification> notifications) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultPadding),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationItem(
          notification: notification,
          onTap: () => _handleNotificationTap(notification),
          onMarkAsRead: () => _markAsRead(notification.id),
        );
      },
    );
  }

  void _handleNotificationTap(entity.Notification notification) {
    // Mark as read when tapped
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }
    
    // Navigate based on notification type and relatedItemId
    if (notification.relatedItemId != null) {
      switch (notification.type) {
        case 'workout':
          // Navigate to workout details
          break;
        case 'nutrition':
          // Navigate to nutrition details
          break;
        case 'progress':
          // Navigate to progress screen
          break;
        default:
          // Default action
          break;
      }
    }
  }

  void _markAsRead(String id) {
    context.read<NotificationBloc>().add(MarkNotificationAsRead(id));
  }
}
