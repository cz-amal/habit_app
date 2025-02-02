class Complete {
  final int? id;
  final int habitId;
  final String date;
  final bool isCompleted;
  final int current;

  Complete({
    this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    required this.current,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
      'current': current,
    };
  }

  factory Complete.fromMap(Map<String, dynamic> map) {
    return Complete(
      id: map['id'],
      habitId: map['habit_id'],
      date: map['date'],
      isCompleted: map['isCompleted'] == 1,
      current: map['current'],
    );
  }
}
