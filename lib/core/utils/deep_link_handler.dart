
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class DeepLinkHandler {
  static const MethodChannel _channel = MethodChannel('app.fitbody/deep_links');
  static final StreamController<String> _deepLinkStreamController = StreamController.broadcast();
  
  // Stream that emits deep link URLs
  static Stream<String> get deepLinkStream => _deepLinkStreamController.stream;
  
  // Initialize deep link handling
  static Future<void> init() async {
    // Set up method call handler
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'handleDeepLink':
          final String? link = call.arguments as String?;
          if (link != null && link.isNotEmpty) {
            _deepLinkStreamController.add(link);
          }
          break;
      }
    });
    
    // Check for initial link
    try {
      final String? initialLink = await _channel.invokeMethod('getInitialLink');
      if (initialLink != null && initialLink.isNotEmpty) {
        _deepLinkStreamController.add(initialLink);
      }
    } catch (e) {
      print('Error getting initial deep link: $e');
    }
  }
  
  // Parse deep link URL into route
  static String parseDeepLink(String url) {
    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return '/';
    }
    
    // Handle app scheme links: fitbody://open/workout/123
    if (uri.scheme == 'fitbody' && uri.host == 'open') {
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.isEmpty) {
        return '/';
      }
      
      // Handle different paths
      switch (pathSegments[0]) {
        case 'workout':
          if (pathSegments.length > 1) {
            return '/workout/detail?id=${pathSegments[1]}';
          }
          return '/workout/library';
          
        case 'exercise':
          if (pathSegments.length > 1) {
            return '/exercise/detail?id=${pathSegments[1]}';
          }
          return '/exercise/library';
          
        case 'nutrition':
          if (pathSegments.length > 1) {
            return '/nutrition/detail?id=${pathSegments[1]}';
          }
          return '/nutrition/meal-planning';
          
        case 'challenge':
          if (pathSegments.length > 1) {
            return '/challenge/detail?id=${pathSegments[1]}';
          }
          return '/challenges';
          
        case 'profile':
          return '/profile';
          
        case 'settings':
          return '/settings';
          
        case 'subscription':
          return '/subscription';
          
        default:
          return '/';
      }
    }
    
    // Handle web links: https://fitbody.app/open/workout/123
    if ((uri.scheme == 'http' || uri.scheme == 'https') && 
        uri.host == 'fitbody.app' && 
        uri.pathSegments.isNotEmpty && 
        uri.pathSegments[0] == 'open') {
      
      final remainingSegments = uri.pathSegments.sublist(1);
      
      if (remainingSegments.isEmpty) {
        return '/';
      }
      
      // Handle different paths - same logic as above
      switch (remainingSegments[0]) {
        case 'workout':
          if (remainingSegments.length > 1) {
            return '/workout/detail?id=${remainingSegments[1]}';
          }
          return '/workout/library';
          
        case 'exercise':
          if (remainingSegments.length > 1) {
            return '/exercise/detail?id=${remainingSegments[1]}';
          }
          return '/exercise/library';
          
        case 'nutrition':
          if (remainingSegments.length > 1) {
            return '/nutrition/detail?id=${remainingSegments[1]}';
          }
          return '/nutrition/meal-planning';
          
        case 'challenge':
          if (remainingSegments.length > 1) {
            return '/challenge/detail?id=${remainingSegments[1]}';
          }
          return '/challenges';
          
        case 'profile':
          return '/profile';
          
        case 'settings':
          return '/settings';
          
        case 'subscription':
          return '/subscription';
          
        default:
          return '/';
      }
    }
    
    return '/';
  }
  
  // Dispose resources
  static void dispose() {
    _deepLinkStreamController.close();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeepLinkHandler {
  static const MethodChannel _channel = MethodChannel('fitbody.app/deeplink');
  
  final NavigatorState navigator;
  
  DeepLinkHandler({required this.navigator});
  
  Future<void> init() async {
    try {
      // Listen for dynamic links from native platform
      _channel.setMethodCallHandler(_handleMethodCall);
      
      // Get initial link if app was opened via a deep link
      final initialLink = await _getInitialLink();
      if (initialLink != null && initialLink.isNotEmpty) {
        _handleLink(initialLink);
      }
    } catch (e) {
      print('Error initializing deep links: $e');
    }
  }
  
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'deepLinkReceived':
        final String link = call.arguments;
        return _handleLink(link);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }
  
  Future<String?> _getInitialLink() async {
    try {
      final initialLink = await _channel.invokeMethod<String>('getInitialLink');
      return initialLink;
    } catch (e) {
      print('Error getting initial link: $e');
      return null;
    }
  }
  
  Future<void> _handleLink(String link) async {
    try {
      print('Handling deep link: $link');
      
      // Parse the link
      Uri uri = Uri.parse(link);
      
      // Extract path and query parameters
      final path = uri.path;
      final args = uri.queryParameters;
      
      // Determine the route to navigate to
      if (path.startsWith('/workout/')) {
        final workoutId = path.split('/').last;
        navigator.pushNamed('/workout_detail', arguments: {'id': workoutId});
      } else if (path == '/meal_planning') {
        navigator.pushNamed('/meal_planning');
      } else if (path == '/challenges') {
        navigator.pushNamed('/challenges');
      } else if (path == '/settings') {
        navigator.pushNamed('/settings');
      } else if (path == '/profile') {
        navigator.pushNamed('/profile');
      } else {
        // Fallback to home if no specific route matches
        navigator.pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      print('Error handling deep link: $e');
    }
  }
}
