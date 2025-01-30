
import 'dart:math';

class Habit {
  final String name;
  final bool isGood; // true for good habits, false for bad habits
  final Map<DateTime, bool> completionData; // Date as key, value as true/false
  final DateTime creationDate; // The date when the habit was created

  Habit({
    required this.name,
    required this.isGood,
    required this.completionData,
    required this.creationDate,
  });
}

int calculateColorValueForDate(
    List<Habit> habits, DateTime date) {
  int totalGoodHabits = 0;
  int totalBadHabits = 0;
  int goodHabitsDone = 0;
  int badHabitsAvoided = 0;

  for (var habit in habits) {
    // Ignore habits created after the given date
    if (habit.creationDate.isAfter(date)) {
      continue;
    }

    // Check if the habit has completion data for the given date
    bool? isCompleted = habit.completionData[date];
    if (habit.isGood) {
      totalGoodHabits++;
      if (isCompleted == true) {
        goodHabitsDone++;
      }
    } else {
      totalBadHabits++;
      if (isCompleted != true) {
        badHabitsAvoided++;
      }
    }
  }

  // Calculate the total tasks done (good habits done + bad habits avoided)
  int tasksDone = goodHabitsDone + badHabitsAvoided;
  int totalTasks = totalGoodHabits + totalBadHabits;

  // Handle edge cases: No habits on this day
  if (totalTasks == 0) {
    return 4; // Neutral value when no habits are defined
  }

  // Calculate the tasks done ratio
  double tasksDoneRatio = tasksDone / totalTasks;

  // Apply the sigmoid mapping formula
  double sigmoid = 1 / (1 + exp(-10 * (tasksDoneRatio - 0.5)));
  int colorValue = (7 - 6 * sigmoid).round();

  return colorValue.clamp(1, 7); // Ensure value is between 1 and 7
}

void main() {
  // Example habits
  List<Habit> habits = [
    Habit(
      name: "Exercise",
      isGood: true,
      creationDate: DateTime(2025, 1, 20),
      completionData: {
        DateTime(2025, 1, 22): true,
        DateTime(2025, 1, 21): false,
      },
    ),
    Habit(
      name: "Junk Food",
      isGood: false,
      creationDate: DateTime(2025, 1, 19),
      completionData: {
        DateTime(2025, 1, 22): false,
        DateTime(2025, 1, 21): true,
      },
    ),
    Habit(
      name: "Read Book",
      isGood: true,
      creationDate: DateTime(2025, 1, 23), // Created after the given date
      completionData: {
        DateTime(2025, 1, 23): true,
      },
    ),
  ];

  DateTime date = DateTime(2025, 1, 22);
  int colorValue = calculateColorValueForDate(habits, date);

  print("Color Value for $date: $colorValue");
}
