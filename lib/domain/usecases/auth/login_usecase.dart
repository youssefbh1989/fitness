
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
  
  Future<Either<Failure, User>> withGoogle() {
    return repository.loginWithGoogle();
  }
  
  Future<Either<Failure, User>> withFacebook() {
    return repository.loginWithFacebook();
  }
  
  Future<Either<Failure, User>> withApple() {
    return repository.loginWithApple();
  }
}
