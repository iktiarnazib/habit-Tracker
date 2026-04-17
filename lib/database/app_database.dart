import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../models/habit.dart';
import '../models/app_settings.dart';

// This is where the actual code generation happens
part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // This creates the database file on the device
    return driftDatabase(name: 'my_habit_database');
  }
}
