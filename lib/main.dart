
import 'package:flutter/material.dart';
import 'package:habit_app/pages/home_page.dart';
import 'package:habit_app/pages/today_page.dart';
import 'package:habit_app/service/notification_service.dart';
import 'package:habit_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'components/black_screen.dart';
import 'model/Database.dart';
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   // await Firebase.initializeApp();




  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Sql()),
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
            home: BlackScreen(),
            theme: ThemeData.dark()
      );
  }
}
