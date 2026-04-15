import 'package:flutter/material.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/light_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeData build() {
    return lightMode;
  }

  //read data
  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDark') ?? false;
    state = isDark ? darkMode : lightMode;
  }

  //change theme
  void toggleTheme() async {
    state = (state == darkMode) ? lightMode : darkMode;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', state == darkMode);
  }
}
