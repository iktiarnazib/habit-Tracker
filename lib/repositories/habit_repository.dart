import 'package:habittracker/database/app_database.dart';
import 'package:habittracker/models/habit.dart';
import 'package:habittracker/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_repository.dart';

@riverpod
class HabitNotifier extends $_HabitNotifier {
  @override
  FutureOr<List<Habit>> build() async {
    final db = ref.watch(databaseProvider);
    //fetch all the habits at the start
    return db.select(db.habits).get;
  }

  //create habit
  Future<void> addHabit(String name) async {
    final db = ref.read(databaseProvider);
    await db
        .into(db.habits)
        .insert(HabitsCompanion.insert(name: name, CompletedDays: []));
    //refresh db
    ref.invalidateSelf();
  }

  //update habit
  Future<void> updateHabit(Habit habit) async {
    final db = ref.read(databaseProvider);
    await db.update(db.habits).replace(habit);
    ref.invalidateSelf();
  }

  //delete habit
  Future<void> deleteHabit(int id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.habits)..where((t) => t.id.equals(id))).go();
    //refresh databasae
    ref.invalidateSelf();
  }
}
