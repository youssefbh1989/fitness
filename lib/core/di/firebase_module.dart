
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/notification_service.dart';

class FirebaseModule {
  static final FirebaseModule _instance = FirebaseModule._internal();
  factory FirebaseModule() => _instance;
  FirebaseModule._internal();
  
  FirebaseAnalytics? _analytics;
  FirebaseAnalytics get analytics => _analytics!;
  
  FirebaseAuth? _auth;
  FirebaseAuth get auth => _auth!;
  
  FirebaseMessaging? _messaging;
  FirebaseMessaging get messaging => _messaging!;
  
  FirebaseCrashlytics? _crashlytics;
  FirebaseCrashlytics get crashlytics => _crashlytics!;
  
  FirebaseRemoteConfig? _remoteConfig;
  FirebaseRemoteConfig get remoteConfig => _remoteConfig!;

  Future<void> initialize() async {
    try {
      // Initialize Firebase Core
      await Firebase.initializeApp();
      
      // Initialize services
      _analytics = FirebaseAnalytics.instance;
      _auth = FirebaseAuth.instance;
      _messaging = FirebaseMessaging.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _remoteConfig = FirebaseRemoteConfig.instance;
      
      // Configure Crashlytics
      await _configureCrashlytics();
      
      // Configure Messaging
      await _configureMessaging();
      
      // Configure Remote Config
      await _configureRemoteConfig();
      
      // Log initialization success
      await _analytics!.logEvent(name: 'firebase_initialized');
    } catch (e, stackTrace) {
      debugPrint('Error initializing Firebase: $e');
      if (kReleaseMode) {
        // In release mode, report to crashlytics if available
        await FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
    }
  }
  
  Future<void> _configureCrashlytics() async {
    // Enable collection of crash reports
    await _crashlytics!.setCrashlyticsCollectionEnabled(kReleaseMode);
    
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        // In release mode, report to crashlytics
        FirebaseCrashlytics.instance.recordFlutterError(details);
      } else {
        // In debug mode, print to console
        FlutterError.dumpErrorToConsole(details);
      }
    };
  }
  
  Future<void> _configureMessaging() async {
    // Request permission for notifications
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    
    debugPrint('Firebase Messaging Authorization status: ${settings.authorizationStatus}');
    
    // Configure FCM message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification!.title}');
        
        // Show local notification
        NotificationService().showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? 'New Notification',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });
    
    // Get FCM token for this device
    String? token = await _messaging!.getToken();
    debugPrint('FCM Token: $token');
    
    // Save the token to user settings or send to your server
    
    // Handle token refresh
    _messaging!.onTokenRefresh.listen((String token) {
      debugPrint('FCM Token refreshed: $token');
      // Update token in your server
    });
  }

  Future<void> _configureRemoteConfig() async {
    // Set default parameter values
    await _remoteConfig!.setDefaults({
      'welcome_message': 'Welcome to FitBody!',
      'enable_premium_features': false,
      'version_update_required': false,
      'maintenance_mode': false,
      'feature_flags': {
        'enable_social_sharing': true,
        'enable_achievements': true,
        'enable_nutrition_tracking': true,
        'enable_challenges': true,
      },
    });
    
    // Configure fetch settings
    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    
    // Fetch and activate remote config
    await _remoteConfig!.fetchAndActivate();
  }
  
  // Example of getting a remote config value
  String getWelcomeMessage() {
    return _remoteConfig!.getString('welcome_message');
  }
  
  // Example of getting a boolean remote config value
  bool isPremiumFeaturesEnabled() {
    return _remoteConfig!.getBool('enable_premium_features');
  }
  
  // Example of getting a map of feature flags
  Map<String, dynamic> getFeatureFlags() {
    return _remoteConfig!.getValue('feature_flags').asMap();
  }
  
  // Check if a specific feature is enabled
  bool isFeatureEnabled(String featureName) {
    final features = getFeatureFlags();
    return features[featureName] ?? false;
  }
}
