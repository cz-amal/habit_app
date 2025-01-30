import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/Database.dart';

class HabitPop extends StatefulWidget {

  final String id;
  final String name;
  final String description;
  final bool type;
  final int? threshold;
  const HabitPop({super.key, required this.id,required this.name,required this.description,required this.type, this.threshold});

  @override
  State<HabitPop> createState() => _HabitPopState();
}

class _HabitPopState extends State<HabitPop> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.threshold);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 150),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.grey[900]),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Habit",
                style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueAccent),
              ),
              Text(widget.name, style: GoogleFonts.varelaRound(fontSize: 20)),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Description",
                style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueAccent),
              ),
              Text(
                widget.description,
                style: GoogleFonts.varelaRound(fontSize: 16),
              ),
              if (widget.threshold != null && widget.threshold! > 0) ...[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Threshold",
                  style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  widget.threshold.toString(),
                  style: GoogleFonts.varelaRound(fontSize: 16),
                ),
              ],
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green.shade600),
                    child: Text("ok"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
