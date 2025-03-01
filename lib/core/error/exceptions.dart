
class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class AuthenticationException implements Exception {
  final String message;
  
  AuthenticationException([this.message = 'Authentication failed']);
}
