import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoHabitTile extends StatefulWidget {
  const NoHabitTile({super.key});

  @override
  State<NoHabitTile> createState() => _NoHabitTileState();
}

class _NoHabitTileState extends State<NoHabitTile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(12),

          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
          ),
          Image.asset(
            "lib/assets/images/ribbon.png",
            height: 200,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "No habits are added",
            style: GoogleFonts.varelaRound(fontSize: 25,fontWeight: FontWeight.bold,color:Colors.white),
          ),
          Text(
            "start your journey now",
            style: GoogleFonts.varelaRound(fontSize: 18),
          )
        ],
      )),
    );
  }
}
