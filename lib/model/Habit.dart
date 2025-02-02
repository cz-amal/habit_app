class Habit {
  final int? id;
  final String name;
  final String description;
  final bool isGood;
  final bool type;
  final int? threshold;
  final DateTime time;

  Habit({
    this.id,
    required this.name,
    required this.description,
    required this.isGood,
    required this.type,
    this.threshold,
    required this.time,
  });

  // Convert Habit to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isGood': isGood ? 1 : 0,
      'type': type ? 1 : 0,
      'threshold': threshold ?? 0,
      'time': time.toIso8601String(),
    };
  }

  // Convert SQLite Map to Habit
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isGood: map['isGood'] == 1,
      type: map['type'] == 1,
      threshold: map['threshold'],
      time: DateTime.parse(map['time']),
    );
  }
}
