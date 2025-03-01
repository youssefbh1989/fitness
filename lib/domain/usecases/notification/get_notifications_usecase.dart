
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';
import '../base/usecase.dart';

class GetNotificationsUseCase implements UseCase<List<Notification>, NoParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Notification>>> call(NoParams params) async {
    return await repository.getNotifications();
  }
}
