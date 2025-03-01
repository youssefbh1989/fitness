
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../base/usecase.dart';
import '../../entities/progress.dart';
import '../../repositories/progress_repository.dart';

class AddProgressEntryUseCase implements UseCase<Progress, Progress> {
  final ProgressRepository repository;

  AddProgressEntryUseCase(this.repository);

  @override
  Future<Either<Failure, Progress>> call(Progress params) async {
    return await repository.addProgressEntry(params);
  }
}
