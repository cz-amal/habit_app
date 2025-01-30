import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String name;
  final String description;
  final bool isGood; // "good" or "bad"
  final bool type;
  final int? threshold;
  final DateTime time;
  final Map<String, List<dynamic>> completedDates; // Date -> Completion Status

  Habit({
    required this.name,
    required this.description,
    required this.isGood,
    required this.type,
    this.threshold,
    required this.time,
    required this.completedDates,
  });

  // Convert a Firestore document into a Habit object
  factory Habit.fromFirestore(Map<String, dynamic> data) {
    return Habit(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      isGood: data['isGood'] ?? false, // Default to false if not provided
      type: data['type'] ?? false, // Default to false if not provided
      threshold: data['threshold'] ?? 0, // Default to 0 if not provided
      time: (data['time'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      completedDates: (data['completed_dates'] ?? {}).map<String, List<dynamic>>(
            (key, value) => MapEntry(key, List<dynamic>.from(value)),
      ),
    );
  }

  // Convert Habit to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isGood': isGood,
      'type': type,
      'threshold': threshold,
      'time': Timestamp.fromDate(time), // Convert DateTime to Firestore Timestamp
      'completed_dates': completedDates.map<String, dynamic>(
            (key, value) => MapEntry(key, value),
      ),
    };
  }
}