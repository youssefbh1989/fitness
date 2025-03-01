
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../base/usecase.dart';
import '../../entities/progress.dart';
import '../../repositories/progress_repository.dart';

class GetProgressHistoryUseCase implements UseCase<List<Progress>, String> {
  final ProgressRepository repository;

  GetProgressHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Progress>>> call(String params) async {
    return await repository.getProgressHistory(params);
  }
}
