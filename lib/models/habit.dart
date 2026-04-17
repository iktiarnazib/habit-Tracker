import 'package:drift/drift.dart';

class Habits extends Table {
  // habit id - primary key with auto-increment
  IntColumn get id => integer().autoIncrement()();

  // habit name
  TextColumn get name => text()();

  // completed days
  // Note: Drift doesn't store List<DateTime> directly.
  // We use a TypeConverter to store it as a JSON string or a separate table.
  TextColumn get completedDays => text().map(const DateTimeListConverter())();
}

// Type Converter for List<DateTime>
class DateTimeListConverter extends TypeConverter<List<DateTime>, String> {
  const DateTimeListConverter();

  @override
  List<DateTime> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> decoded = List.from(
      Uri.decodeComponent(fromDb).split(','),
    );
    return decoded.map((e) => DateTime.parse(e)).toList();
  }

  @override
  String toSql(List<DateTime> value) {
    return value.map((e) => e.toIso8601String()).join(',');
  }
}
