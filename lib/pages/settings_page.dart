import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/light_mode.dart';
import 'package:habittracker/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //theme mode checker
    final darkThemeReader = ref.watch(themeProvider);

    //isDarkMode
    final darkModeOn = (darkThemeReader == darkMode);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondary,
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
            child: ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                hoverColor: Colors.green,
                value: darkModeOn,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//done
