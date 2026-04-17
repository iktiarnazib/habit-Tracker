import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
