//given a habit list of completed days
//is the habit completed today check

import 'package:habittracker/database/app_database.dart';

bool isTheHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

//prepare heat map dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataSet = {
    //pre-build apps.
    DateTime(2026, 4, 1): 4,
    DateTime(2026, 4, 2): 6,
    DateTime(2026, 4, 4): 2,
    DateTime(2026, 4, 5): 4,
    DateTime(2026, 4, 6): 6,
    DateTime(2026, 4, 8): 2,
    DateTime(2026, 4, 9): 4,
    DateTime(2026, 4, 11): 4,
    DateTime(2026, 4, 13): 6,
    DateTime(2026, 4, 14): 2,
    DateTime(2026, 4, 13): 4,
    DateTime(2026, 4, 15): 4,
    DateTime(2026, 4, 16): 2,
    DateTime(2026, 4, 18): 4,
    DateTime(2026, 4, 19): 4,
    DateTime(2026, 4, 20): 2,
  };
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      //normalize date to avoid mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      //if date already exists in the dataset, increment its count
      if (dataSet.containsKey(normalizedDate)) {
        dataSet[normalizedDate] = dataSet[normalizedDate]! + 1;
      } else {
        //otherwise initialize with the count of 1
        dataSet[normalizedDate] = 1;
      }
    }
  }
  return dataSet;
}
