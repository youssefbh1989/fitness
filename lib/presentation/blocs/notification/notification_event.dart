
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;

  const MarkNotificationAsRead(this.id);

  @override
  List<Object> get props => [id];
}

class MarkAllNotificationsAsRead extends NotificationEvent {}

class DeleteNotification extends NotificationEvent {
  final String id;

  const DeleteNotification(this.id);

  @override
  List<Object> get props => [id];
}

class ClearAllNotifications extends NotificationEvent {}
