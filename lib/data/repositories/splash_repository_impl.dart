
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SharedPreferences sharedPreferences;

  SplashRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, bool>> checkFirstTime() async {
    try {
      bool isFirstTime = !sharedPreferences.containsKey('first_time') || 
                          sharedPreferences.getBool('first_time') ?? true;
      
      if (isFirstTime) {
        await sharedPreferences.setBool('first_time', false);
      }
      
      return Right(isFirstTime);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthenticated() async {
    try {
      final token = sharedPreferences.getString('auth_token');
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
