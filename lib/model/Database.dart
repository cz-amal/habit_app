import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Habit.dart';

class Database with ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference colorRef = FirebaseFirestore.instance.collection('dataset');
  Color? color = null;
  int? threshold = null;
  int? get getThreshold => threshold;
  Color? get habitStatus => color;
  List<Map<String, dynamic>> habits = []; // Local habit list
  Map<String, dynamic> ahabit = {}; // Single habit map
  bool isChecked = false;
  bool isGreater = false;
  Map<String, dynamic> get Ahabit => ahabit;
  List<Map<String, dynamic>> get MyHabits => habits;
  Map<DateTime, int> dataset = {};
  Map<DateTime, int> get myDataset => dataset;
  Map<DateTime,int> globalDataset = {};
  Map<DateTime, int> get myGlobaldataset => globalDataset;


  Future<void> getDatasetFromFirestore() async {
    try {
      // Fetch all documents from the Firestore collection
      QuerySnapshot snapshot = await colorRef.get();

      for (var doc in snapshot.docs) {
        String dateString = doc.id; // Document ID is the date string (e.g., "2025-01-27")
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Ensure the document contains a 'color' value
        if (data.containsKey('color')) {
          int colorValue = data['color'];

          // Parse the date string into a DateTime object
          DateTime date = DateTime.parse(dateString);

          // Add to the dataset map
          globalDataset[date] = colorValue;
        }
      }

      print("Dataset fetched successfully: $globalDataset");
      notifyListeners();
    } catch (e) {
      print("Error fetching dataset: $e");
    }
  }




  Future<void> addDataset(Map<DateTime, int> data) async {
    // Extract the first key-value pair from the map

    print("Dataset data is $data");
    int colorNum = data.values.first; // The color value
    DateTime date = data.keys.first;  // The date key

    // Format the date into a string (e.g., "2025-01-27")
    String newDateKey =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      // Add the dataset to the database
      await colorRef.doc(newDateKey).set({'color': colorNum});

      print("Color dataset added successfully for $newDateKey");
    } catch (e) {
      // Handle errors
      print("Error adding color dataset: $e");
    }
  }


  /// Add a new habit to Firestore and the local list
  Future<void> addHabit(Habit habit) async {
    try {
      // Add to Firestore and get the document reference
      DocumentReference document = await users.add(habit.toMap());

      // Add to local list
      Map<String, dynamic> temp = {
        'id': document.id, // Include Firestore ID
        ...habit.toMap(),
      };
      habits.add(temp);

      notifyListeners(); // Notify listeners about the change
    } catch (e) {
      print("Error adding habit: $e");
    }
  }

  /// Delete a habit by ID from Firestore and the local list
  Future<void> deleteHabit(String id) async {
    try {
      habits.removeWhere((x) => x['id'] == id);
      await users.doc(id).delete(); // Delete from Firestore
      // Remove from local list
      notifyListeners();
    } catch (e) {
      print("Failed to delete habit: $e");
    }
  }

  /// Update a habit in Firestore and the local list
  Future<void> updateHabit(String id, Map<String, dynamic> habit) async {
    try {
      // Ensure habit map is not empty
      if (habit.isEmpty) {
        print("No data to update.");
        return;
      }
      int index = habits.indexWhere((x) => x['id'] == id);
      if (index != -1) {
        // Update only provided fields while preserving others
        habits[index] = {
          ...habits[index], // Retain existing fields
          ...habit, // Overwrite with updated fields
        };
      }
      // Update Firestore document with merge option
      await users.doc(id).set(habit, SetOptions(merge: true));
      notifyListeners();
      // Find the local habit by its ID
    } catch (e) {
      // Log the error for debugging
      print("Error updating habit: $e");
    }
  }

  /// Update a specific date's completion status for a habit
  Future<void> updateChecked(
      String id, DateTime newDate, bool? isCompleted, int? current) async {
    try {
      String newDateKey =
          "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
      int index = habits.indexWhere((x) => x['id'] == id);
      if (index != -1) {
        habits[index] = {
          ...habits[index], // Retain existing data first
          'id': id, // Ensure the ID is explicitly updated
          // 'current': current, // Ensure the 'current' field is updated
          'completed_dates': {
            ...(habits[index]['completed_dates'] ??
                {}), // Retain existing dates
            newDateKey: [
              isCompleted,
              current
            ], // Add or update the new date entry
          },
        };
        notifyListeners();
      }

      // Update the `completedDates` field in Firestore
      await users.doc(id).update({
        'completed_dates.$newDateKey': [isCompleted, current],
        // 'current':current,
      });

      // Update locally
    } catch (e) {
      print("Error updating checked status: $e");
    }
  }

  /// Retrieve a single habit by ID from the local list
  void getAhabit(String id) {
    try {
      ahabit = habits.firstWhere((x) => x['id'] == id, orElse: () => {});
      notifyListeners();
    } catch (e) {
      print("Error fetching habit: $e");
    }
  }

  /// Get filtered habits based on type
  Future<List<Map<String, dynamic>>> getFilteredHabits(gridType) async {
    return await habits.where((x) => x['isGood'] == gridType).toList();
  }

  /// Retrieve all habits from Firestore and update the local list
  Future<void> getmyHabits() async {
    try {
      QuerySnapshot snapshot = await users.get();

      // Convert Firestore documents into a list of maps
      habits = await snapshot.docs.map((doc) {
        print("inside getmyhabtis");
        print(doc.data() as Map<String, dynamic>);
        return {
          'id': doc.id,
          // Ensure the document ID is always included
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching habits: $e");
    }
  }

  Future<void> calculateColorValueForDate(DateTime newDate) async {
    int totalGoodHabits = 0;
    int totalBadHabits = 0;
    int goodHabitsDone = 0;
    int badHabitsDone = 0;

    // Maps a value `i` to a range of 1 to 7, based on the total `n`
    int mapToRange(int i, int n) {
      if (i < -n || i > n) return -1; // Out of range
      double segmentLength = (2 * n) / 7;
      return ((i + n) / segmentLength).ceil().clamp(1, 7);
    }

    print("Inside color calculation");

    // Fetch habits if not already loaded
    if (habits.isEmpty) {
      await getmyHabits();
    }

    String formattedDate =
        "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";

    for (var habit in habits) {
      if (!habit.containsKey('completed_dates') || !habit['completed_dates'].containsKey(formattedDate)) {
        continue; // Skip if the habit doesn't have data for the given date
      }

      bool? isCompleted = habit['completed_dates'][formattedDate][0];

      if (habit['isGood']) {
        totalGoodHabits++;
        if (isCompleted == true) goodHabitsDone++;
      } else {
        totalBadHabits++;
        if (isCompleted == true) badHabitsDone++;
      }
    }

    // Calculate habit statistics
    int goodHabitsNotDone = totalGoodHabits - goodHabitsDone;
    int badHabitsNotDone = totalBadHabits - badHabitsDone;

    print(
        "Good Done: $goodHabitsDone, Good Not Done: $goodHabitsNotDone, Bad Done: $badHabitsDone, Bad Not Done: $badHabitsNotDone");

    int netScore = goodHabitsDone - goodHabitsNotDone - badHabitsDone + badHabitsNotDone;
    print("Net Score: $netScore");

    int totalTasks = totalGoodHabits + totalBadHabits;

    // Handle edge case: No habits defined for this date
    if (totalTasks == 0) {
      dataset = {newDate: 4}; // Neutral value
    } else {
      dataset = {newDate: mapToRange(netScore, totalTasks)};
    }
    addDataset(dataset);
    getDatasetFromFirestore();
    notifyListeners();
    print("Color calculation notified");
  }






}
