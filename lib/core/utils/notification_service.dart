
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:io';
import 'dart:async';

enum NotificationImportance {
  low,
  normal,
  high,
}

class NotificationPayload {
  final String id;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  NotificationPayload({
    required this.id,
    this.title,
    this.body,
    this.data,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<NotificationPayload> _notificationStreamController =
      StreamController<NotificationPayload>.broadcast();

  Stream<NotificationPayload> get notificationStream => _notificationStreamController.stream;

  Future<void> init() async {
    tz_data.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');
        
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
        );
        
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Check if app was launched from notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp &&
        notificationAppLaunchDetails.notificationResponse != null) {
      _handleNotificationResponse(notificationAppLaunchDetails.notificationResponse!);
    }
    
    // Request permissions
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  Future<void> _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      _notificationStreamController.add(
        NotificationPayload(
          id: id.toString(),
          title: title,
          body: body,
          data: {'payload': payload},
        ),
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    _handleNotificationResponse(response);
  }
  
  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      // Handle the payload
      _notificationStreamController.add(
        NotificationPayload(
          id: response.id.toString(),
          data: {'payload': response.payload},
        ),
      );
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'default_channel',
    String channelName = 'Default Channel',
    String channelDescription = 'Default notification channel',
    NotificationImportance importance = NotificationImportance.normal,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: _getAndroidImportance(importance),
      priority: _getAndroidPriority(importance),
      icon: '@drawable/notification_icon',
    );
    
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'scheduled_channel',
    String channelName = 'Scheduled Notifications',
    String channelDescription = 'Channel for scheduled notifications',
    NotificationImportance importance = NotificationImportance.high,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: _getAndroidImportance(importance),
      priority: _getAndroidPriority(importance),
      icon: '@drawable/notification_icon',
    );
    
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Schedule daily notification at specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
    String channelId = 'daily_channel',
    String channelName = 'Daily Notifications',
    String channelDescription = 'Channel for daily notifications',
    NotificationImportance importance = NotificationImportance.normal,
  }) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    // If the time has already passed today, schedule for tomorrow
    final effectiveDate = scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
    
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: _getAndroidImportance(importance),
      priority: _getAndroidPriority(importance),
      icon: '@drawable/notification_icon',
    );
    
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(effectiveDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Schedule weekly notification
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<int> days, // 1-7 (Monday-Sunday)
    String? payload,
    String channelId = 'weekly_channel',
    String channelName = 'Weekly Notifications',
    String channelDescription = 'Channel for weekly notifications',
    NotificationImportance importance = NotificationImportance.normal,
  }) async {
    for (int day in days) {
      if (day < 1 || day > 7) {
        continue; // Skip invalid days
      }
      
      final now = DateTime.now();
      int currentDay = (now.weekday == 7) ? 1 : now.weekday + 1;
      int daysToAdd = (day - currentDay) % 7;
      
      if (daysToAdd == 0 &&
          now.hour > time.hour ||
          (now.hour == time.hour && now.minute >= time.minute)) {
        daysToAdd = 7;
      }
      
      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ).add(Duration(days: daysToAdd));
      
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: _getAndroidImportance(importance),
        priority: _getAndroidPriority(importance),
        icon: '@drawable/notification_icon',
      );
      
      DarwinNotificationDetails iOSPlatformChannelSpecifics =
          const DarwinNotificationDetails();
      
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id + day, // Use day as part of ID to allow multiple days
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  // Schedule workout reminder
  Future<void> scheduleWorkoutReminder({
    required int id,
    required String workoutName,
    required DateTime scheduledDate,
    Duration reminderBefore = const Duration(minutes: 30),
  }) async {
    final reminderDate = scheduledDate.subtract(reminderBefore);
    
    await scheduleNotification(
      id: id,
      title: 'Workout Reminder',
      body: 'Your $workoutName workout starts in ${reminderBefore.inMinutes} minutes!',
      scheduledDate: reminderDate,
      channelId: 'workout_reminder',
      channelName: 'Workout Reminders',
      channelDescription: 'Reminders for upcoming workouts',
      importance: NotificationImportance.high,
      payload: '{"type":"workout_reminder","id":"$id","workout_name":"$workoutName"}',
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Helper methods to convert importance enum
  Importance _getAndroidImportance(NotificationImportance importance) {
    switch (importance) {
      case NotificationImportance.low:
        return Importance.low;
      case NotificationImportance.normal:
        return Importance.defaultImportance;
      case NotificationImportance.high:
        return Importance.high;
      default:
        return Importance.defaultImportance;
    }
  }

  Priority _getAndroidPriority(NotificationImportance importance) {
    switch (importance) {
      case NotificationImportance.low:
        return Priority.low;
      case NotificationImportance.normal:
        return Priority.defaultPriority;
      case NotificationImportance.high:
        return Priority.high;
      default:
        return Priority.defaultPriority;
    }
  }
  
  void dispose() {
    _notificationStreamController.close();
  }
}
