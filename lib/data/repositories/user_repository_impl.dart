
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferences sharedPreferences;
  
  UserRepositoryImpl({required this.sharedPreferences});
  
  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final userString = sharedPreferences.getString('user');
      if (userString != null) {
        return Right(User.fromJson(jsonDecode(userString)));
      }
      return const Left(CacheFailure(message: 'User profile not found'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> updateUserProfile(User user) async {
    try {
      await sharedPreferences.setString('user', jsonEncode(user.toJson()));
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateUserPassword(String currentPassword, String newPassword) async {
    try {
      // Mock implementation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      if (currentPassword == 'password') {
        // In a real app, we would update the password in a backend service
        return const Right(true);
      } else {
        return const Left(AuthFailure(message: 'Current password is incorrect'));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
