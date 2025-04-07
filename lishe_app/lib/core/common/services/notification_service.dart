import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    // Create notification channels for Android
    const androidChannel = AndroidNotificationChannel(
      'meal_reminders',
      'Meal Reminders',
      description: 'Notifications for scheduled meals',
      importance: Importance.max,
    );

    const androidChannel2 = AndroidNotificationChannel(
      'meal_tracking',
      'Meal Tracking',
      description: 'Reminders to track if meals were eaten',
      importance: Importance.max,
    );

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    
    // Initialize the plugin
    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // Create notification channels
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
      await androidPlugin.createNotificationChannel(androidChannel2);
    }

    debugPrint('Notification service initialized successfully');
  }

  Future<void> scheduleMealReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Convert both current time and scheduled time to local timezone
    final now = tz.TZDateTime.now(tz.local);
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Ensure scheduled time is at least 1 second in the future
    if (tzScheduledTime.isBefore(now.add(const Duration(seconds: 1)))) {
      // If the scheduled time is in the past or too close to now, adjust it to 1 second in the future
      final adjustedTime = now.add(const Duration(seconds: 1));
      debugPrint('Adjusted scheduled time from ${tzScheduledTime.toString()} to ${adjustedTime.toString()}');
      
      final androidDetails = AndroidNotificationDetails(
        'meal_reminders',
        'Meal Reminders',
        channelDescription: 'Notifications for scheduled meals',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        enableLights: true,
        ledColor: const Color(0xFF4CAF50),
        ledOnMs: 1000,
        ledOffMs: 500,
      );

      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          adjustedTime,
          NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        throw Exception('Failed to schedule notification: $e');
      }
    } else {
      final androidDetails = AndroidNotificationDetails(
        'meal_reminders',
        'Meal Reminders',
        channelDescription: 'Notifications for scheduled meals',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        enableLights: true,
        ledColor: const Color(0xFF4CAF50),
        ledOnMs: 1000,
        ledOffMs: 500,
      );

      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tzScheduledTime,
          NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        throw Exception('Failed to schedule notification: $e');
      }
    }
  }

  Future<void> scheduleDailyMealReminders({
    required List<Map<String, dynamic>> meals,
  }) async {
    // Cancel existing notifications
    await _plugin.cancelAll();

    // Schedule new notifications for each meal
    for (var meal in meals) {
      try {
        final scheduledTime = DateTime.parse(meal['scheduledTime']);
        await scheduleMealReminder(
          id: meal['id'],
          title: 'Time to eat: ${meal['name']}',
          body: 'Don\'t forget to log your meal after eating!',
          scheduledTime: scheduledTime,
        );
        
        // Schedule tracking reminder
        await scheduleMealTrackingReminder(
          id: meal['id'],
          mealName: meal['name'],
          scheduledTime: scheduledTime,
        );
      } catch (e) {
        debugPrint('Failed to schedule meal reminder: $e');
        // Continue with other meals even if one fails
      }
    }
  }

  Future<void> scheduleMealTrackingReminder({
    required int id,
    required String mealName,
    required DateTime scheduledTime,
  }) async {
    // Convert both current time and scheduled time to local timezone
    final now = tz.TZDateTime.now(tz.local);
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    
    // Schedule a reminder 30 minutes after the meal time to track if eaten
    final trackingTime = tzScheduledTime.add(const Duration(minutes: 30));
    
    // Ensure tracking time is at least 1 second in the future
    if (trackingTime.isBefore(now.add(const Duration(seconds: 1)))) {
      // If the tracking time is in the past or too close to now, adjust it to 1 second in the future
      final adjustedTime = now.add(const Duration(seconds: 1));
      debugPrint('Adjusted tracking time from ${trackingTime.toString()} to ${adjustedTime.toString()}');

      final androidDetails = AndroidNotificationDetails(
        'meal_tracking',
        'Meal Tracking',
        channelDescription: 'Reminders to track if meals were eaten',
        importance: Importance.max,
        priority: Priority.high,
      );

      try {
        await _plugin.zonedSchedule(
          id + 1000, // Use different ID range for tracking reminders
          'Did you eat your $mealName?',
          'Please log your meal to track your nutrition progress',
          adjustedTime,
          NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (e) {
        throw Exception('Failed to schedule tracking notification: $e');
      }
    } else {
      final androidDetails = AndroidNotificationDetails(
        'meal_tracking',
        'Meal Tracking',
        channelDescription: 'Reminders to track if meals were eaten',
        importance: Importance.max,
        priority: Priority.high,
      );

      try {
        await _plugin.zonedSchedule(
          id + 1000, // Use different ID range for tracking reminders
          'Did you eat your $mealName?',
          'Please log your meal to track your nutrition progress',
          trackingTime,
          NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (e) {
        throw Exception('Failed to schedule tracking notification: $e');
      }
    }
  }

  Future<void> cancelMealReminder(int id) async {
    try {
      await _plugin.cancel(id);
      await _plugin.cancel(id + 1000); // Also cancel the tracking reminder
    } catch (e) {
      throw Exception('Failed to cancel notification: $e');
    }
  }

  Future<void> cancelAllMealReminders() async {
    await _plugin.cancelAll();
  }
}