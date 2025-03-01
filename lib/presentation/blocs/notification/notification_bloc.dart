
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/usecases/base/usecase.dart';
import '../../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../../domain/usecases/notification/mark_as_read_usecase.dart';
import '../../../domain/usecases/notification/mark_all_as_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final MarkAsReadUseCase markAsRead;
  final MarkAllAsReadUseCase markAllAsRead;

  NotificationBloc({
    required this.getNotifications,
    required this.markAsRead,
    required this.markAllAsRead,
  }) : super(NotificationInitial()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getNotifications(NoParams());
    emit(_mapNotificationsToState(result));
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await markAsRead(MarkAsReadParams(id: event.id));
    
    result.fold(
      (failure) => emit(NotificationError(_mapFailureToMessage(failure))),
      (_) async {
        final notificationsResult = await getNotifications(NoParams());
        emit(_mapNotificationsToState(notificationsResult));
      },
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await markAllAsRead(NoParams());
    
    result.fold(
      (failure) => emit(NotificationError(_mapFailureToMessage(failure))),
      (_) async {
        final notificationsResult = await getNotifications(NoParams());
        emit(_mapNotificationsToState(notificationsResult));
      },
    );
  }

  NotificationState _mapNotificationsToState(
    Either<Failure, List<Notification>> result,
  ) {
    return result.fold(
      (failure) => NotificationError(_mapFailureToMessage(failure)),
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        return NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Customize based on your failure types
    return 'Failed to fetch notifications';
  }
}
