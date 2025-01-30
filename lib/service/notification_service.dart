import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initializeNotifications() async {
    tz.initializeTimeZones(); // Initialize the timezone database

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Use your app's launcher icon

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Create a notification channel for Android
  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_notification_channel', // Channel ID
      'Daily Notifications', // Channel name
      description: 'Channel for daily notifications', // Add description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Schedule daily notifications
  Future<void> scheduleDailyNotifications() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'daily_notification_channel', // Same as Channel ID
      'Daily Notifications', // Same as Channel name
      channelDescription: 'Channel for daily notifications', // Add description
      importance: Importance.max,
      priority: Priority.high, // Use Priority.high
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule notification for 10 AM
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Good Morning!', // Title
      'Time to start your day!', // Body
      _nextInstanceOfTime(10, 0), // Time (10:00 AM)
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Use this
    );

    // Schedule notification for 7 PM
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Notification ID
      'Good Evening!', // Title
      'Time to relax!', // Body
      _nextInstanceOfTime(2, 39), // Time (7:00 PM)
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Use this
    );
  }

  // Helper function to calculate the next instance of a given time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}