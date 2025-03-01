
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signup(String name, String email, String password);
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, User>> loginWithFacebook();
  Future<Either<Failure, User>> loginWithApple();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
}
