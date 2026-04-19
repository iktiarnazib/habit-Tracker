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

  //add habit
  Future<void> addHabit(String name) async {
    final db = ref.read(databaseProvider);
    await db
        .into(db.habits)
        .insert(HabitsCompanion.insert(name: name, completedDays: []));
    ref.invalidateSelf();
  }

  // update completion status
  Future<void> updateCompletionStatus(Habit habit, bool isCompleted) async {
    final db = ref.read(databaseProvider);

    final updatedDays = List<DateTime>.from(habit.completedDays);

    if (isCompleted && !updatedDays.contains(DateTime.now())) {
      // add today's date (date only, no time)
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      updatedDays.add(today);
    } else if (!isCompleted) {
      // remove today if unchecked
      updatedDays.removeWhere(
        (d) =>
            d.year == DateTime.now().year &&
            d.month == DateTime.now().month &&
            d.day == DateTime.now().day,
      );
    }

    final updatedHabit = habit.copyWith(completedDays: updatedDays);
    await db.update(db.habits).replace(updatedHabit);
    ref.invalidateSelf();
  }

  // UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final db = ref.read(databaseProvider);

    // find the specific habit
    final habit = await (db.select(
      db.habits,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    // update habit name
    if (habit != null) {
      final updatedHabit = habit.copyWith(name: newName);

      // save updated habit back to the db
      await db.update(db.habits).replace(updatedHabit);
      ref.invalidateSelf();
    }
  }

  //delete Habit
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
