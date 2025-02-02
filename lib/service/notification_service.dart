import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as t;
import 'package:flutter_timezone/flutter_timezone.dart';

class Notiservice {
  final  notificationplugin = FlutterLocalNotificationsPlugin();
   
    

  bool _isInitialized = false;
  bool get isInialized => _isInitialized;

  Future<void> initNotif() async {

      if(_isInitialized) return;
      t.initializeTimeZones();
      final String currentZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentZone));

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    notificationplugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  
    await notificationplugin.initialize(initSettings);
    
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'Daily notifications',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high));
  }

  Future<void> showNotif({int id = 0, String? title, String? body, String? payload}) async {
    print("notificatiion send");
    return notificationplugin.show(id, title, body, notificationDetails());
  }

  Future<void> schedule({int id = 1, required String? title,required String? body, required int hour, required int minute})async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled_time =
        tz.TZDateTime(tz.local, now.year, now.month,hour,minute);

      await notificationplugin.zonedSchedule(
        id,
        title,
        body,
        scheduled_time,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
        
      );
      print("notification scheduled");
  }
  Future<void> cancelNotif() async{
    await notificationplugin.cancelAll();
  }


}
