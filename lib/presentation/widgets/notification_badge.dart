
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../blocs/notification/notification_event.dart';
import '../blocs/notification/notification_state.dart';
import '../routes/app_router.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        int unreadCount = 0;
        
        if (state is NotificationsLoaded) {
          unreadCount = state.unreadCount;
        } else if (state is NotificationInitial) {
          // Fetch notifications if not already loaded
          context.read<NotificationBloc>().add(FetchNotifications());
        }
        
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.notificationsRoute);
              },
              iconSize: 28,
            ),
            if (unreadCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
