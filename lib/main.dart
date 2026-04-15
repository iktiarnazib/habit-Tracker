import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/pages/home_page.dart';
import 'package:habittracker/pages/settings_page.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/light_mode.dart';
import 'package:habittracker/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDark') ?? false;
  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => isDarkMode ? darkMode : lightMode),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      home: HomePage(),
      routes: {'settingsPage': (context) => SettingsPage()},
    );
  }
}
