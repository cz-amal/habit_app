import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/settings_tile.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void onChanged(bool? state){
    print("state changed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.navigate_before,size: 30,)),
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
                          fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Do it now",
                      style: GoogleFonts.varelaRound(fontSize: 16, color: Colors.blueAccent),
                    ),
                  ),
            const SizedBox(height: 20,),
            Text("Profile",style: GoogleFonts.varelaRound(fontSize: 30),),
            const SizedBox(height: 10,),
        Container(
          width: 400,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[900], // Subtle transparency effect
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),

                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "AMAL C Z",
                      style: GoogleFonts.varelaRound(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "amaladhil020@gmail.com",
                      style: GoogleFonts.varelaRound(
                        fontSize: 15,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.logout,size: 30,)))
              ],
            ),
          ),
        ),
            const SizedBox(height: 20,),
            Text("Settings",style: GoogleFonts.varelaRound(fontSize: 30),),
            const SizedBox(height: 10,),
            SettingsTile(title: "dark mode",icon_data:Icons.dark_mode,onChanged:onChanged),
            const SizedBox(height: 15,),
            SettingsTile(title: "notifications",icon_data:Icons.notifications,onChanged:onChanged),
            const SizedBox(height: 15,),
            SettingsTile(title: "app lock",icon_data:Icons.fingerprint,onChanged:onChanged),

        ],
        ),
      )
    );
  }
}
