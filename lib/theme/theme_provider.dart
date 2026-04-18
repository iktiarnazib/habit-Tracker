import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:habittracker/theme/light_mode.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  return lightMode;
});
