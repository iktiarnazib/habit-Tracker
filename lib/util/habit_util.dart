//given a habit list of completed days
//is the habit completed today check

import 'package:habittracker/database/app_database.dart';
import 'package:habittracker/models/habit.dart';

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
  Map<DateTime, int> dataSet = {};
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
