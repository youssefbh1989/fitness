
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
