import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/database/app_database.dart';
import 'package:habittracker/providers/database_provider.dart';

// No @riverpod annotation, no part directive, no code gen needed
class HabitNotifier extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() async {
    final db = ref.watch(databaseProvider);
    return db.select(db.habits).get();
  }

  Future<void> addHabit(String name) async {
    final db = ref.read(databaseProvider);
    await db
        .into(db.habits)
        .insert(HabitsCompanion.insert(name: name, completedDays: []));
    ref.invalidateSelf();
  }

  Future<void> updateHabit(Habit habit) async {
    final db = ref.read(databaseProvider);
    await db.update(db.habits).replace(habit);
    ref.invalidateSelf();
  }

  Future<void> deleteHabit(int id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.habits)..where((t) => t.id.equals(id))).go();
    ref.invalidateSelf();
  }
}

// Manual provider declaration
final habitNotifierProvider = AsyncNotifierProvider<HabitNotifier, List<Habit>>(
  () => HabitNotifier(),
);
