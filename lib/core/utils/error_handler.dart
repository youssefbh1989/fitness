
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Custom exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

// Global error handler
class ErrorHandler {
  static ErrorHandler? _instance;
  final StreamController<AppError> _errorStreamController = StreamController<AppError>.broadcast();
  
  // Singleton pattern
  factory ErrorHandler() {
    _instance ??= ErrorHandler._internal();
    return _instance!;
  }
  
  ErrorHandler._internal();
  
  Stream<AppError> get errorStream => _errorStreamController.stream;
  
  void handleError(dynamic error, {StackTrace? stackTrace, String? context}) {
    final appError = _convertToAppError(error, stackTrace: stackTrace, context: context);
    _errorStreamController.add(appError);
    
    // Log error
    _logError(appError);
  }
  
  AppError _convertToAppError(dynamic error, {StackTrace? stackTrace, String? context}) {
    if (error is NetworkException) {
      return AppError(
        type: ErrorType.network,
        message: error.message,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is ServerException) {
      return AppError(
        type: ErrorType.server,
        message: error.message,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is CacheException) {
      return AppError(
        type: ErrorType.cache,
        message: error.message,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is ValidationException) {
      return AppError(
        type: ErrorType.validation,
        message: error.message,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is AuthException) {
      return AppError(
        type: ErrorType.auth,
        message: error.message,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is SocketException || error is TimeoutException) {
      return AppError(
        type: ErrorType.network,
        message: 'Network connection error',
        stackTrace: stackTrace,
        context: context,
      );
    } else {
      return AppError(
        type: ErrorType.unknown,
        message: error.toString(),
        stackTrace: stackTrace,
        context: context,
      );
    }
  }
  
  void _logError(AppError error) {
    // Log to console in debug mode
    print('ERROR: ${error.type} - ${error.message}');
    if (error.stackTrace != null) {
      print(error.stackTrace);
    }
    if (error.context != null) {
      print('Context: ${error.context}');
    }
    
    // In a real app, we'd also log to an analytics or error reporting service
  }
  
  // Check if device is online
  static Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Show error dialog
  static void showErrorDialog(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void dispose() {
    _errorStreamController.close();
  }
}

// Error types
enum ErrorType {
  network,
  server,
  cache,
  validation,
  auth,
  unknown,
}

// App error model
class AppError {
  final ErrorType type;
  final String message;
  final StackTrace? stackTrace;
  final String? context;
  
  AppError({
    required this.type,
    required this.message,
    this.stackTrace,
    this.context,
  });
  
  String get friendlyMessage {
    switch (type) {
      case ErrorType.network:
        return 'Network error. Please check your internet connection.';
      case ErrorType.server:
        return 'Server error. Please try again later.';
      case ErrorType.cache:
        return 'Error loading saved data.';
      case ErrorType.validation:
        return message;
      case ErrorType.auth:
        return 'Authentication error. Please log in again.';
      case ErrorType.unknown:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
