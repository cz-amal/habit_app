import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/habit_tile.dart';
import 'package:habit_app/components/text_tile.dart';
import 'package:habit_app/pages/add_habit.dart';
import 'package:habit_app/pages/category_page.dart';
import 'package:provider/provider.dart';

import '../components/no_habit_tile.dart';
import '../model/Database.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Database>(
        builder: (context, db, child) => Scaffold(
            backgroundColor: Colors.black,
            floatingActionButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: EdgeInsets.all(8),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHabit()),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.blueAccent,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TextTile(text: "Habits"),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Habits",
                          style: GoogleFonts.varelaRound(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: db.MyHabits.isNotEmpty ? db.MyHabits.length : 1, // Show one item when empty
                itemBuilder: (context, index) {
                  if (db.MyHabits.isNotEmpty) {
                    // Display habits when the list is not empty
                    final habit = db.MyHabits[index];
                    print(habit);
                    String habitText = habit['name'];
                    String description = habit['description'];
                    bool isGood = habit['isGood'];
                    String docId = habit['id'];
                    bool type = habit['type'];
                    int? threshold = habit['threshold'];
                    DateTime time = habit['time'].toDate();
                    return HabitTile(
                      habitText: habitText,
                      description: description,
                      isGood: isGood,
                      id: docId,
                      type: type,
                      threshold: threshold,
                      time:time
                    );
                  } else {
                    // Display an alternative widget when the list is empty
                    return NoHabitTile();
                  }
                },
              )

              ],
                ),
              ),
            )));
  }
}
