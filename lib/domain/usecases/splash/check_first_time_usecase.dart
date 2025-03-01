
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/splash_repository.dart';
import '../base/usecase.dart';

class CheckFirstTimeUseCase implements UseCase<bool, NoParams> {
  final SplashRepository repository;

  CheckFirstTimeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.checkFirstTime();
  }
}
