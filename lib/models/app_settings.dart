import 'package:drift/drift.dart';

class AppSettings extends Table {
  // id - primary key with auto-increment
  IntColumn get id => integer().autoIncrement()();

  // first launch date
  // Drift handles DateTime directly, but since it's nullable in Isar,
  // we use .nullable() here.
  DateTimeColumn get firstLaunchDate => dateTime().nullable()();
}
