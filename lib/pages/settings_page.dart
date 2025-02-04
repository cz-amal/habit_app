import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/settings_tile.dart';
import 'package:habit_app/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationEnabled = false; // Holds the notification switch state
  bool isFingerprintEnabled = false; // Holds the fingerprint switch state

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load saved preferences
  }

  // Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs.getBool('notifications_enabled') ?? false;
      isFingerprintEnabled = prefs.getBool('fingerprint_enabled') ?? false;
    });
  }

  // Save fingerprint switch state to SharedPreferences
  Future<void> _saveFingerprintState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fingerprint_enabled', value);
  }

  // Toggle notification switch and handle notifications
  Future<void> onNotificationChanged(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = state;
    });

    await prefs.setBool('notifications_enabled', state);

    if (state) {
      Notiservice().initNotif();
      Notiservice().schedule(
        title: "Hey, time to do some tasks!!",
        body: "Complete the task and stay consistent",
        hour: 10,
        minute: 10,
      );
    } else {
      Notiservice().cancelNotif();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.navigate_before, size: 30),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Habit Tracker",
                style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.bold, fontSize: 30,
                ),
              ),
            ),
            Center(
              child: Text(
                "Do it now",
                style: GoogleFonts.varelaRound(fontSize: 16, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),
            Text("Profile", style: GoogleFonts.varelaRound(fontSize: 30)),
            const SizedBox(height: 10),
            Container(
              width: 400,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 10, spreadRadius: 1),
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: Offset(2, 4)),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person, size: 35, color: Colors.white),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your name",
                          style: GoogleFonts.varelaRound(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "youremailid@gmail.com",
                          style: GoogleFonts.varelaRound(
                            fontSize: 15,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Settings", style: GoogleFonts.varelaRound(fontSize: 30)),
            const SizedBox(height: 15),
            SettingsTile(
              title: "Notifications",
              icon_data: Icons.notifications,
              onChanged: onNotificationChanged,
              isSwitchedOn: isNotificationEnabled,
            ),
            const SizedBox(height: 15),
            SettingsTile(
              title: "Fingerprint Lock",
              icon_data: Icons.fingerprint,
              onChanged: _saveFingerprintState,
              isSwitchedOn: isFingerprintEnabled,
            ),
          ],
        ),
      ),
    );
  }
}