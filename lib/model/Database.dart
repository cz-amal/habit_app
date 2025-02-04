//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:habit_app/model/color.dart';

import 'Habit.dart';
//
// class Database with ChangeNotifier {
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   CollectionReference colorRef = FirebaseFirestore.instance.collection('dataset');
//   Color? color = null;
//   int? threshold = null;
//   int? get getThreshold => threshold;
//   Color? get habitStatus => color;
//   List<Map<String, dynamic>> habits = []; // Local habit list
//   Map<String, dynamic> ahabit = {}; // Single habit map
//   bool isChecked = false;
//   bool isGreater = false;
//   Map<String, dynamic> get Ahabit => ahabit;
//   List<Map<String, dynamic>> get MyHabits => habits;
//   Map<DateTime, int> dataset = {};
//   Map<DateTime, int> get myDataset => dataset;
//   Map<DateTime,int> globalDataset = {};
//   Map<DateTime, int> get myGlobaldataset => globalDataset;
//
//
//   Future<void> getDatasetFromFirestore() async {
//     try {
//       // Fetch all documents from the Firestore collection
//       QuerySnapshot snapshot = await colorRef.get();
//
//       for (var doc in snapshot.docs) {
//         String dateString = doc.id; // Document ID is the date string (e.g., "2025-01-27")
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//         // Ensure the document contains a 'color' value
//         if (data.containsKey('color')) {
//           int colorValue = data['color'];
//
//           // Parse the date string into a DateTime object
//           DateTime date = DateTime.parse(dateString);
//
//           // Add to the dataset map
//           globalDataset[date] = colorValue;
//         }
//       }
//
//       print("Dataset fetched successfully: $globalDataset");
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching datasets: $e");
//     }
//   }
//
//
//
//
//
//
//
//
//   Future<void> addDataset(Map<DateTime, int> data) async {
//     // Extract the first key-value pair from the map
//
//     print("Dataset data is $data");
//     int colorNum = data.values.first; // The color value
//     DateTime date = data.keys.first;  // The date key
//
//     // Format the date into a string (e.g., "2025-01-27")
//     String newDateKey =
//         "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//
//     try {
//       // Add the dataset to the database
//       await colorRef.doc(newDateKey).set({'color': colorNum});
//
//       print("Color dataset added successfully for $newDateKey");
//     } catch (e) {
//       // Handle errors
//       print("Error adding color dataset: $e");
//     }
//   }
//
//
//   /// Add a new habit to Firestore and the local list
//   Future<void> addHabit(Habit habit) async {
//     try {
//       // Add to Firestore and get the document reference
//       DocumentReference document = await users.add(habit.toMap());
//
//       // Add to local list
//       Map<String, dynamic> temp = {
//         'id': document.id, // Include Firestore ID
//         ...habit.toMap(),
//       };
//       habits.add(temp);
//
//       notifyListeners(); // Notify listeners about the change
//     } catch (e) {
//       print("Error adding habit: $e");
//     }
//   }
//
//   /// Delete a habit by ID from Firestore and the local list
//   Future<void> deleteHabit(String id) async {
//     try {
//       habits.removeWhere((x) => x['id'] == id);
//       await users.doc(id).delete(); // Delete from Firestore
//       // Remove from local list
//       notifyListeners();
//     } catch (e) {
//       print("Failed to delete habit: $e");
//     }
//   }
//
//   /// Update a habit in Firestore and the local list
//   Future<void> updateHabit(String id, Map<String, dynamic> habit) async {
//     try {
//       // Ensure habit map is not empty
//       if (habit.isEmpty) {
//         print("No data to update.");
//         return;
//       }
//       int index = habits.indexWhere((x) => x['id'] == id);
//       if (index != -1) {
//         // Update only provided fields while preserving others
//         habits[index] = {
//           ...habits[index], // Retain existing fields
//           ...habit, // Overwrite with updated fields
//         };
//       }
//       // Update Firestore document with merge option
//       await users.doc(id).set(habit, SetOptions(merge: true));
//       notifyListeners();
//       // Find the local habit by its ID
//     } catch (e) {
//       // Log the error for debugging
//       print("Error updating habit: $e");
//     }
//   }
//
//   /// Update a specific date's completion status for a habit
//   Future<void> updateChecked(
//       String id, DateTime newDate, bool? isCompleted, int? current) async {
//     try {
//       String newDateKey =
//           "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
//       int index = habits.indexWhere((x) => x['id'] == id);
//       if (index != -1) {
//         habits[index] = {
//           ...habits[index], // Retain existing data first
//           'id': id, // Ensure the ID is explicitly updated
//           // 'current': current, // Ensure the 'current' field is updated
//           'completed_dates': {
//             ...(habits[index]['completed_dates'] ??
//                 {}), // Retain existing dates
//             newDateKey: [
//               isCompleted,
//               current
//             ], // Add or update the new date entry
//           },
//         };
//         notifyListeners();
//       }
//
//       // Update the `completedDates` field in Firestore
//       await users.doc(id).update({
//         'completed_dates.$newDateKey': [isCompleted, current],
//         // 'current':current,
//       });
//
//       // Update locally
//     } catch (e) {
//       print("Error updating checked status: $e");
//     }
//   }
//
//   /// Retrieve a single habit by ID from the local list
//   void getAhabit(String id) {
//     try {
//       ahabit = habits.firstWhere((x) => x['id'] == id, orElse: () => {});
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching habit: $e");
//     }
//   }
//
//   /// Get filtered habits based on type
//   Future<List<Map<String, dynamic>>> getFilteredHabits(gridType) async {
//     return await habits.where((x) => x['isGood'] == gridType).toList();
//   }
//
//   /// Retrieve all habits from Firestore and update the local list
//   Future<void> getmyHabits() async {
//     try {
//       QuerySnapshot snapshot = await users.get();
//
//       // Convert Firestore documents into a list of maps
//       habits = await snapshot.docs.map((doc) {
//         print("inside getmyhabtis");
//         print(doc.data() as Map<String, dynamic>);
//         return {
//           'id': doc.id,
//           // Ensure the document ID is always included
//           ...doc.data() as Map<String, dynamic>,
//         };
//       }).toList();
//
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching habits: $e");
//     }
//   }
//
//   Future<void> calculateColorValueForDate(DateTime newDate) async {
//     int totalGoodHabits = 0;
//     int totalBadHabits = 0;
//     int goodHabitsDone = 0;
//     int badHabitsDone = 0;
//
//     // Maps a value `i` to a range of 1 to 7, based on the total `n`
//     int mapToRange(int i, int n) {
//       if (i < -n || i > n) return -1; // Out of range
//       double segmentLength = (2 * n) / 7;
//       return ((i + n) / segmentLength).ceil().clamp(1, 7);
//     }
//
//     print("Inside color calculation");
//
//     // Fetch habits if not already loaded
//     if (habits.isEmpty) {
//       await getmyHabits();
//     }
//
//     String formattedDate =
//         "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
//
//     for (var habit in habits) {
//       if (!habit.containsKey('completed_dates') || !habit['completed_dates'].containsKey(formattedDate)) {
//         continue; // Skip if the habit doesn't have data for the given date
//       }
//
//       bool? isCompleted = habit['completed_dates'][formattedDate][0];
//
//       if (habit['isGood']) {
//         totalGoodHabits++;
//         if (isCompleted == true) goodHabitsDone++;
//       } else {
//         totalBadHabits++;
//         if (isCompleted == true) badHabitsDone++;
//       }
//     }
//
//     // Calculate habit statistics
//     int goodHabitsNotDone = totalGoodHabits - goodHabitsDone;
//     int badHabitsNotDone = totalBadHabits - badHabitsDone;
//
//     print(
//         "Good Done: $goodHabitsDone, Good Not Done: $goodHabitsNotDone, Bad Done: $badHabitsDone, Bad Not Done: $badHabitsNotDone");
//
//     int netScore = goodHabitsDone - goodHabitsNotDone - badHabitsDone + badHabitsNotDone;
//     print("Net Score: $netScore");
//
//     int totalTasks = totalGoodHabits + totalBadHabits;
//
//     // Handle edge case: No habits defined for this date
//     if (totalTasks == 0) {
//       dataset = {newDate: 4}; // Neutral value
//     } else {
//       dataset = {newDate: mapToRange(netScore, totalTasks)};
//     }
//     addDataset(dataset);
//     getDatasetFromFirestore();
//     notifyListeners();
//     print("Color calculation notified");
//   }
//
// }

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'complete.dart';

class Sql with ChangeNotifier {
  static final Sql _instance = Sql._internal();
  factory Sql() => _instance;
  static Database? _database;
  Sql._internal();


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Map<DateTime,int> dataset = {};

  Map<DateTime,int> get mydataset => dataset;



  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habit_tracker.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            isGood INTEGER NOT NULL,
            type INTEGER NOT NULL,
            threshold INTEGER DEFAULT NULL,
            time TEXT NOT NULL
            )
         """);

      await db.execute('''
          CREATE TABLE complete (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            current INTEGER NOT NULL,
            FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
          )
        ''');
      await db.execute('''
          CREATE TABLE color_values (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            color INTEGER NOT NULL
          )
        ''');
    });
  }
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('habits');
    await db.delete('complete');
    await db.delete('color_values');
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    int habit_id = await db.insert('habits', habit.toMap());
    DateTime newDates = DateTime.now();
    String formattedDate = "${newDates.year}-${newDates.month.toString().padLeft(2, '0')}-${newDates.day.toString().padLeft(2, '0')}";
    Complete newDate = Complete(
      habitId: habit_id,  // Use the generated habitId
      date: formattedDate,
      isCompleted: false,
      current: 0,
    );
    int complete_id = await db.insert('complete', newDate.toMap());
    notifyListeners();
    print("habit added through sqflite");
  }

  Future<List<Map<String, dynamic>>> getmyHabits() async {
    final db = await database;  // Open the database
    List<Map<String, dynamic>> results = await db.query('habits');  // Query the 'habits' table
    return results;  // Return the list of maps directly
  }

  Future<List<Map<String, dynamic>>> getaHabits(int habit_id) async {
    final db = await database;  // Open the database
    List<Map<String, dynamic>> results = await db.query('habits',where: "id = ?",whereArgs: [habit_id]);
    // Query the 'habits' table
    return results;  // Return the list of maps directly
  }
  Future<List<Map<String, dynamic>>> getFilteredHabits(int isGood) async {
    final db = await database;  // Open the database
    List<Map<String, dynamic>> results = await db.query('habits',where: "isGood = ?",whereArgs: [isGood]);
    // Query the 'habits' table
    return results;  // Return the list of maps directly
  }

  Future<bool> isDate(DateTime date) async {
    final db = await database;

    // Convert DateTime to a string format (ISO 8601 or any format that matches the DB)
    String dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // Query the color_values table to check if the date is present
    List<Map<String, dynamic>> results = await db.query(
      'color_values',
      where: 'date = ?',
      whereArgs: [dateString],
    );

    // If the results are not empty, the date exists in the table
    return results.isNotEmpty;
  }


  Future<void> checkAndInsertTodayEntries() async {
    final db = await database;
    DateTime today = DateTime.now(); // Get today's date (YYYY-MM-DD)
    String dateString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Fetch all habit IDs
    List<Map<String, dynamic>> habits = await db.query('habits', columns: ['id']);

    for (var habit in habits) {
      int habitId = habit['id'];

      // Check if today's date exists for this habit
      List<Map<String, dynamic>> existingEntries = await db.query(
        'complete',
        where: 'habit_id = ? AND date = ?',
        whereArgs: [habitId, dateString],
      );

      // If no entry exists for today, insert a new entry with isCompleted = false
      if (existingEntries.isEmpty) {
        Complete newdate = Complete(
            habitId: habitId,
            date: dateString,
            isCompleted: false,
            current: 0
        );
        await db.insert('complete',newdate.toMap());
      }
    }
  }





  Future<bool> isHabitDoneToday(int habitId) async {
    final db = await database;

    // Format today's date as YYYY-MM-DD
    String todayDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    // Query the `complete` table to check if today's entry exists with isCompleted = 1
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM complete WHERE habit_id = ? AND date = ? AND isCompleted = 1',
        [habitId, todayDate]
    );

    return result.isNotEmpty; // If result is not empty, habit is completed today
  }






  Future<void> addColor(DateTime date) async{
    DateTime today = DateTime.now(); // Get today's date (YYYY-MM-DD)
    String dateString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    ColorValue newcolor = ColorValue(date: dateString, color: 0);
    final db = await database;
    db.insert('color_values',newcolor.toMap());
    print("new date added by sqflite");

  }

  Future<void> deleteHabit(int habit_id) async{
    final db = await database;
    await db.delete('habits', where: 'id = ?', whereArgs: [habit_id]);
    await db.delete('complete', where: 'habit_id = ?',whereArgs: [habit_id]);
    print("habit deleted through sqflite");
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit,int habit_id) async {
    final db = await database;
    await db.update('habits', habit.toMap(), where: 'id = ?', whereArgs: [habit_id]);
    print("habit updated through sqflite");
    notifyListeners();
  }


  Future<void> updateChecked(int habitId, DateTime newDate, bool isCompleted, int current) async {
    final db = await database;
    String newDateKey = "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
    // Check if an entry for this habit on the given date exists
    print(habitId);
    List<Map<String, dynamic>> existingEntries = await db.rawQuery(
        'SELECT * FROM complete WHERE habit_id = ? AND date = ?',
        [habitId, newDateKey]
    );


    if (existingEntries.isNotEmpty) {
      // If the entry exists, update it
      print("updating habit table");
      await db.rawUpdate(
          'UPDATE complete SET isCompleted = ?, current = ? WHERE habit_id = ? AND date = ?',
          [isCompleted ? 1 : 0, current, habitId, newDateKey]
      );

    } else {
      // If the entry doesn't exist, insert a new entry
      await db.insert(
        'complete',
        {
          'habit_id': habitId,
          'date': newDateKey,
          'isCompleted': isCompleted ? 1 : 0,
          'current': current,
        },
      );
    }
  }


  Future<void> getDatasetForDate(DateTime date) async {
    final db = await database;

    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM color_values WHERE date = ?',
        [formattedDate]
    );

    if (result.isNotEmpty) {
      int colorValue = result.first['color'];
      String today = result.first['date'];
      dataset =  {DateTime.parse(today): colorValue};
    } else {
      dataset =  {}; // Return empty map if no entry found
    }
  }







  Future<void> calculateColorValueForDate(DateTime newDate) async {
    int totalGoodHabits = 0;
    int totalBadHabits = 0;
    int goodHabitsDone = 0;
    int badHabitsDone = 0;

    int mapToRange(int i, int n) {
      if (i < -n || i > n) return -1;
      double segmentLength = (2 * n) / 7;
      return ((i + n) / segmentLength).ceil().clamp(1, 7);
    }

    print("Inside color calculation");

    String formattedDate =
        "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";

    final db = await database;

    // Fetch all habits from the SQLite database
    List<Map<String, dynamic>> habits = await db.query('habits');

    for (var habit in habits) {
      int habitId = habit['id'];
      bool isGood = habit['isGood'] == 1; // SQLite stores booleans as 0/1

      // Fetch completion data for the given date
      List<Map<String, dynamic>> completionData = await db.rawQuery(
          'SELECT isCompleted FROM complete WHERE habit_id = ? AND date = ?',
          [habitId, formattedDate]
      );

      if (completionData.isEmpty) continue;

      bool isCompleted = completionData.first['isCompleted'] == 1;

      if (isGood) {
        totalGoodHabits++;
        if (isCompleted) goodHabitsDone++;
      } else {
        totalBadHabits++;
        if (isCompleted) badHabitsDone++;
      }
    }

    int goodHabitsNotDone = totalGoodHabits - goodHabitsDone;
    int badHabitsNotDone = totalBadHabits - badHabitsDone;

    print("Good Done: $goodHabitsDone, Good Not Done: $goodHabitsNotDone, Bad Done: $badHabitsDone, Bad Not Done: $badHabitsNotDone");

    int netScore = goodHabitsDone - goodHabitsNotDone - badHabitsDone + badHabitsNotDone;
    print("Net Score: $netScore");

    int totalTasks = totalGoodHabits + totalBadHabits;

    int colorValue = (totalTasks == 0) ? 4 : mapToRange(netScore, totalTasks);

    // Store the color value in SQLite
    await db.rawUpdate(
        'UPDATE color_values SET color = ? WHERE date = ?',
        [colorValue, formattedDate]
    );
    getDatasetForDate(DateTime.now());
    notifyListeners();
    print("Color calculation completed and stored in SQLite");
  }







}









