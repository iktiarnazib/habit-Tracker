import 'package:drift/drift.dart';
import 'dart:convert';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  // Looks like List<DateTime> in Dart ✅
  TextColumn get completedDays => text()
      .map(const DateTimeListConverter())
      .withDefault(const Constant('[]'))();
}


class DateTimeListConverter
    extends TypeConverter<List<DateTime>, String> {
  const DateTimeListConverter();

  @override
  List<DateTime> fromSql(String fromDb) {
    final List data = jsonDecode(fromDb);
    return data.map((e) => DateTime.parse(e)).toList();
  }

  @override
  String toSql(List<DateTime> value) {
    return jsonEncode(
      value.map((e) => e.toIso8601String()).toList(),
    );
  }
}