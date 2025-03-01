
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  // This is mock data - in a real app, this would come from an API or local database
  final List<Notification> _notifications = [
    Notification(
      id: '1',
      title: 'New Workout Available',
      message: 'Check out the new HIIT workout we added just for you!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'workout',
      relatedItemId: 'workout_123',
    ),
    Notification(
      id: '2',
      title: 'Weekly Progress Update',
      message: 'Congratulations! You completed 4 workouts this week.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: 'progress',
      relatedItemId: 'progress_summary',
    ),
    Notification(
      id: '3',
      title: 'Meal Plan Reminder',
      message: 'Don\'t forget to prepare your meals for tomorrow.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: 'nutrition',
      relatedItemId: 'nutrition_plan_456',
    ),
  ];

  @override
  Future<Either<Failure, List<Notification>>> getNotifications() async {
    try {
      // Sort by timestamp (newest first) and read status (unread first)
      final sortedNotifications = List<Notification>.from(_notifications)
        ..sort((a, b) {
          // First sort by read status
          if (a.isRead != b.isRead) {
            return a.isRead ? 1 : -1; // Unread first
          }
          // Then sort by timestamp
          return b.timestamp.compareTo(a.timestamp); // Newest first
        });
      return Right(sortedNotifications);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Notification>> getNotificationById(String id) async {
    try {
      final notification = _notifications.firstWhere(
        (notification) => notification.id == id,
      );
      return Right(notification);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    try {
      final index = _notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    try {
      _notifications.removeWhere((notification) => notification.id == id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllNotifications() async {
    try {
      _notifications.clear();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
