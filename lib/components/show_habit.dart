import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/no_habit_tile.dart';
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
        future: Provider.of<Database>(context, listen: true)
            .getFilteredHabits(widget.gridtype),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // }

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
                  "No habits found",
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
              print(data);

              String docId = data['id'] ?? "";
              String habitText = data['name'];
              bool type = data['type'];
              DateTime date = DateTime.now();
              String today =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
              int? current = 0;

              if (!data['completed_dates'].containsKey(today)) {
                 Provider.of<Database>(context, listen: false)
                    .updateHabit(docId, {
                  'completed_dates': {
                    today: [false, 0]
                  }
                }).then((_){
                   current = data['completed_dates'][today][1] ?? 0;
                 })
                 ;
              }
              else{
                current = data['completed_dates'][today][1] ?? 0;
              }
              int? threshold = data['threshold'] ?? 0;
              print(threshold);
              bool done = data['completed_dates'][today][0] ?? false;
              print(done);

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
      ),
    );
  }
}
