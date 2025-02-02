import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatefulWidget {
  final void Function(bool) onChanged;
  final String title;
  final IconData? icon_data;
  bool isSwitchedOn;

  SettingsTile({
    super.key,
    required this.onChanged,
    required this.title,
    required this.icon_data,
    required this.isSwitchedOn,
  });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  late bool _isSwitchedOn; // Make it mutable

  @override
  void initState() {
    super.initState();
    _isSwitchedOn = widget.isSwitchedOn; // Initialize with the value passed from the parent
  }
  @override
  void didUpdateWidget(SettingsTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state if the parent widget's value changes
    if (oldWidget.isSwitchedOn != widget.isSwitchedOn) {
      setState(() {
        _isSwitchedOn = widget.isSwitchedOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 70,
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
          children: [
            Icon(widget.icon_data, size: 30, color: Colors.white),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                widget.title,
                style: GoogleFonts.varelaRound(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            CupertinoSwitch(
              value: _isSwitchedOn, // Use the local state variable
              onChanged: (bool state){
               print(state);
                setState(() {
                  _isSwitchedOn = state; // Update the local state
                });
                 widget.onChanged(state); // Notify the parent widget
              },
            ),
          ],
        ),
      ),
    );
  }
}