
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required String message}) : super(message: message);
}
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {
  const ServerFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class AuthenticationFailure extends Failure {
  final String message;
  
  const AuthenticationFailure([this.message = 'Authentication failed']);
  
  @override
  List<Object?> get props => [message];
}
