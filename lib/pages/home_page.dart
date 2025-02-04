import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_app/components/nav_bar.dart';
import 'package:habit_app/pages/category_page.dart';
import 'package:habit_app/pages/habits_page.dart';
import 'package:habit_app/pages/settings_page.dart';
import 'package:habit_app/pages/today_page.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../components/black_screen.dart';
import '../model/Database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String getDate() {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy').format(today);
    return formattedDate;
  }

  final List<Widget> pages = [
    TodayPage(),
    HabitsPage(),
    CategoryPage(),
  ];

  int _current_index = 0;
  void changePage(int index) {
    setState(() {
      _current_index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final db = context.read<Sql>();
    // db.clearDatabase();
    bool isPresent = await db.isDate(DateTime.now());
    if (!isPresent) {
      await db.addColor(DateTime.now());
    }
    db.calculateColorValueForDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[_current_index],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[900],
          ),
          child: Text(
            getDate(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
        color: Colors.black,
        child: NavPage(fn: changePage),
      ),
      drawer: SettingsPage(),
    );
  }
}