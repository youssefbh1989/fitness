
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../repositories/notification_repository.dart';
import '../base/usecase.dart';

class MarkAsReadUseCase implements UseCase<Unit, MarkAsReadParams> {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MarkAsReadParams params) async {
    return await repository.markAsRead(params.id);
  }
}

class MarkAsReadParams extends Equatable {
  final String id;

  const MarkAsReadParams({required this.id});

  @override
  List<Object> get props => [id];
}
