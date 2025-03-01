
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  
  AuthRepositoryImpl({required this.sharedPreferences});
  
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Mock implementation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      if (email == 'demo@example.com' && password == 'password') {
        final user = User(
          id: '1',
          name: 'Demo User',
          email: email,
          photoUrl: null,
        );
        
        // Save to shared preferences
        await sharedPreferences.setString('user', jsonEncode(user.toJson()));
        await sharedPreferences.setBool('isLoggedIn', true);
        
        return Right(user);
      } else {
        return const Left(AuthFailure(message: 'Invalid email or password'));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> signup(String name, String email, String password) async {
    try {
      // Mock implementation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        photoUrl: null,
      );
      
      // Save to shared preferences
      await sharedPreferences.setString('user', jsonEncode(user.toJson()));
      await sharedPreferences.setBool('isLoggedIn', true);
      
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      // Mock implementation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: '2',
        name: 'Google User',
        email: 'google@example.com',
        photoUrl: 'https://ui-avatars.com/api/?name=Google+User',
      );
      
      // Save to shared preferences
      await sharedPreferences.setString('user', jsonEncode(user.toJson()));
      await sharedPreferences.setBool('isLoggedIn', true);
      
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> loginWithFacebook() async {
    try {
      // Mock implementation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: '3',
        name: 'Facebook User',
        email: 'facebook@example.com',
        photoUrl: 'https://ui-avatars.com/api/?name=Facebook+User',
      );
      
      // Save to shared preferences
      await sharedPreferences.setString('user', jsonEncode(user.toJson()));
      await sharedPreferences.setBool('isLoggedIn', true);
      
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> loginWithApple() async {
    try {
      // Mock implementation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: '4',
        name: 'Apple User',
        email: 'apple@example.com',
        photoUrl: 'https://ui-avatars.com/api/?name=Apple+User',
      );
      
      // Save to shared preferences
      await sharedPreferences.setString('user', jsonEncode(user.toJson()));
      await sharedPreferences.setBool('isLoggedIn', true);
      
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await sharedPreferences.remove('user');
      await sharedPreferences.setBool('isLoggedIn', false);
      return const Right(true);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userString = sharedPreferences.getString('user');
      if (userString != null) {
        return Right(User.fromJson(jsonDecode(userString)));
      }
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      return Right(sharedPreferences.getBool('isLoggedIn') ?? false);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitbody/core/error/failures.dart';
import 'package:fitbody/domain/entities/user.dart';
import 'package:fitbody/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // In a real app, this would call an API
      await Future.delayed(const Duration(seconds: 1));
      
      if (email == 'test@example.com' && password == 'password') {
        final user = User(
          id: '1',
          name: 'Test User',
          email: email,
          photoUrl: 'https://i.pravatar.cc/150?img=1',
          createdAt: DateTime.now(),
        );
        
        // Save user info to shared preferences
        sharedPreferences.setString('user_id', user.id);
        sharedPreferences.setString('user_name', user.name);
        sharedPreferences.setString('user_email', user.email);
        
        return Right(user);
      } else {
        return Left(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    try {
      // In a real app, this would call an API
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: '1',
        name: name,
        email: email,
        photoUrl: 'https://i.pravatar.cc/150?img=1',
        createdAt: DateTime.now(),
      );
      
      // Save user info to shared preferences
      sharedPreferences.setString('user_id', user.id);
      sharedPreferences.setString('user_name', user.name);
      sharedPreferences.setString('user_email', user.email);
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // Clear user info from shared preferences
      await sharedPreferences.remove('user_id');
      await sharedPreferences.remove('user_name');
      await sharedPreferences.remove('user_email');
      
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userId = sharedPreferences.getString('user_id');
      final userName = sharedPreferences.getString('user_name');
      final userEmail = sharedPreferences.getString('user_email');
      
      if (userId != null && userName != null && userEmail != null) {
        final user = User(
          id: userId,
          name: userName,
          email: userEmail,
          photoUrl: 'https://i.pravatar.cc/150?img=1',
        );
        
        return Right(user);
      } else {
        return const Right(null);
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
