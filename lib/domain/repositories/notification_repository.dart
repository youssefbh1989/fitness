
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotifications();
  Future<Either<Failure, Notification>> getNotificationById(String id);
  Future<Either<Failure, Unit>> markAsRead(String id);
  Future<Either<Failure, Unit>> markAllAsRead();
  Future<Either<Failure, Unit>> deleteNotification(String id);
  Future<Either<Failure, Unit>> deleteAllNotifications();
}
