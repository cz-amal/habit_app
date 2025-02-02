import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/habit_tile.dart';
import 'package:habit_app/pages/add_habit.dart';
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
    return Consumer<Sql>(
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
                    FutureBuilder<List<Map<String, dynamic>>>(
                        future: db.getmyHabits(),
                        builder: (context, snapshot) {
                          List<Map<String, dynamic>> habits = snapshot.data ?? [];
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            // Display alternative widget when no habits exist
                            return NoHabitTile();
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: habits.isNotEmpty
                                  ? habits.length
                                  : 1, // Show one item when empty
                              itemBuilder: (context, index) {
                                if (habits.isNotEmpty) {
                                  // Display habits when the list is not empty
                                  final habit = habits[index];
                                  print(habit);
                                  String habitText = habit['name'];
                                  String description = habit['description'];
                                  bool isGood = habit['isGood'] == 1;
                                  String docId = habit['id'].toString();
                                  bool type = habit['type'] == 1;
                                  int? threshold = habit['threshold'];
                                  DateTime time = DateTime.parse(habit['time']);
                                  return HabitTile(
                                      habitText: habitText,
                                      description: description,
                                      isGood: isGood,
                                      id: docId,
                                      type: type,
                                      threshold: threshold,
                                      time: time);
                                }
                              },
                            );
                          }
                        })
                  ],
                ),
              ),
            )));
  }
}
