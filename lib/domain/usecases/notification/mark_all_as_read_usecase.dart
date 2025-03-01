
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/notification_repository.dart';
import '../base/usecase.dart';

class MarkAllAsReadUseCase implements UseCase<Unit, NoParams> {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.markAllAsRead();
  }
}
