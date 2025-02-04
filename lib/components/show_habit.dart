import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Database.dart';
import 'habit_grid.dart';

class ShowHabit extends StatefulWidget {
  final bool gridtype;
  const ShowHabit({super.key, required this.gridtype});

  @override
  State<ShowHabit> createState() => _ShowHabitState();
}

class _ShowHabitState extends State<ShowHabit> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<Sql>(context, listen: true)
            .getFilteredHabits(widget.gridtype ? 1 : 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 100),
                child: Text(
                  "No habits found.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          List<Map<String, dynamic>> filteredHabits = snapshot.data!;

          return FutureBuilder<List<bool>>(
            future: Future.wait(filteredHabits.map((habit) async {
              return await Provider.of<Sql>(context, listen: false)
                  .isHabitDoneToday(habit['id']);
            }).toList()),
            builder: (context, doneSnapshot) {
              if (!doneSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<bool> doneList = doneSnapshot.data!;

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards in each row
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: filteredHabits.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = filteredHabits[index];

                  String docId = data['id'].toString();
                  String habitText = data['name'];
                  bool type = data['type'] == 1;
                  int current = data['current'] ?? 0;
                  int? threshold = data['threshold'];

                  bool done = doneList[index]; // Assign the checked status

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: HabitGrid(
                      title: habitText,
                      id: docId,
                      type: type,
                      current: current,
                      threshold: threshold,
                      done: done,
                      isGood: widget.gridtype,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
