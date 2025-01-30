import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatefulWidget {
  void Function(bool)? onChanged;
  final String title;
  final IconData? icon_data;
  SettingsTile({super.key,required this.onChanged,required this.title,required this.icon_data});

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 70,
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
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon_data, size: 30, color: Colors.white),
            ),
            SizedBox(width: 15), // Adjust spacing
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: GoogleFonts.varelaRound(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CupertinoSwitch(
                value: true,
                onChanged: widget.onChanged,
              ),
            ),
          ],
        ),

      ),
    );
  }
}
