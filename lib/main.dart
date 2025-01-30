import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/components/test.dart';
import 'package:habit_app/pages/home_page.dart';
import 'package:habit_app/provider/date_color.dart';
import 'package:habit_app/service/notification_service.dart';
import 'package:habit_app/theme/theme_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'model/Database.dart';
import 'model/Habit.dart';
Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestExactAlarmPermission();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }


  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initializeNotifications();
  await notificationService.createNotificationChannel();
  await notificationService.scheduleDailyNotifications();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Database()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: const MyApp(),

      )
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. this is c
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
            theme: ThemeData.dark()
      );
  }
}
