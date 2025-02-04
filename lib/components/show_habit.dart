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
  late Future<List<Map<String, dynamic>>> _habitFuture;

  @override
  void initState() {
    super.initState();
    _habitFuture = Provider.of<Sql>(context, listen: false)
        .getFilteredHabits(widget.gridtype ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _habitFuture,
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Text(
                  "No habits found.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          List<Map<String, dynamic>> filteredHabits = snapshot.data!;

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

              return FutureBuilder<Map<String,dynamic>>(
                future: Provider.of<Sql>(context, listen: false)
                    .isHabitDoneToday(data['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Show loading indicator
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            "Error: ${snapshot.error}")); // Show error message
                  }

                  Map<String,dynamic> info = snapshot.data!;  // Default to false if null

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: HabitGrid(
                      title: data['name'],
                      id: data['id'].toString(),
                      type: data['type'] == 1,
                      current: info['current'],
                      threshold: data['threshold'],
                      done: info['isCompleted'],
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

  // Future<List<bool>> _getHabitDoneStatus(List<Map<String, dynamic>> habits) async {
  //   Sql db = Provider.of<Sql>(context, listen: false);
  //   return Future.wait(habits.map((habit) => db.isHabitDoneToday(habit['id'])));
  // }
}
