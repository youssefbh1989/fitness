
import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationOperationSuccess extends NotificationState {
  final String message;

  const NotificationOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
