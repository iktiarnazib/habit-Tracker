import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/light_mode.dart';
import 'package:habittracker/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

void onSwitchPressed() async {}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    void onDarkModePressed() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (ref.read(themeProvider) == darkMode) {
        ref.read(themeProvider.notifier).state = lightMode;
        await prefs.setBool('isDark', false);
      } else {
        ref.read(themeProvider.notifier).state = darkMode;
        await prefs.setBool('isDark', true);
      }
    }

    final darkModeOn = (ref.watch(themeProvider) == darkMode);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: "DMSerifTexts",
            fontSize: 25,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: ListTile(
              title: const Text('Dark Mode', style: TextStyle(fontSize: 16)),
              trailing: Switch(
                value: darkModeOn,
                onChanged: (value) {
                  onDarkModePressed();
                },
                activeThumbColor: Theme.of(context)
                    .colorScheme
                    .inversePrimary, //When ON, inside the track little circle
                activeTrackColor: Theme.of(
                  context,
                ).colorScheme.secondary, //When ON switch inside Track
                inactiveThumbColor: Theme.of(context)
                    .colorScheme
                    .inversePrimary, //When OFF, inside the track little cirlce
                inactiveTrackColor: Theme.of(
                  context,
                ).colorScheme.secondary, //switch off inside Track.
              ),
            ),
          ),
        ],
      ),
    );
  }
}
