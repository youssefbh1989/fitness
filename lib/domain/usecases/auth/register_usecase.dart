
import 'package:dartz/dartz.dart';
import 'package:fitbody/core/error/failures.dart';
import 'package:fitbody/domain/entities/user.dart';
import 'package:fitbody/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(String name, String email, String password) {
    return repository.register(name, email, password);
  }
}
