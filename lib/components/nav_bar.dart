import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class NavPage extends StatelessWidget {
  final void Function(int)? fn;
  const NavPage({super.key, required this.fn});

  @override
  Widget build(BuildContext context) {
    return GNav(
      onTabChange: (index) => fn!(index),
      padding: EdgeInsets.all(12),
      tabBorderRadius: 12,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        rippleColor: Colors.grey[600]!,
        hoverColor: Colors.grey[600]!,
        gap: 8,
        activeColor: Colors.blue[700],
        iconSize: 24,
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey[800]!,
        color: Colors.blue[200],
        tabs: [

      GButton(
        icon: Icons.today,

      ),
      GButton(
        icon: Icons.list,

      ),
      GButton(
        icon: Icons.bar_chart,

      ),
    ]);
  }
}
