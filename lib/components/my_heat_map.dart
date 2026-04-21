import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/theme_provider.dart';

class MyHeatMap extends ConsumerWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;
  const MyHeatMap({super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //theme riverpod
    final themeMode = ref.read(themeProvider);

    final mode = darkMode == themeMode;

    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.primary,
      textColor: mode ? Colors.white : Colors.black,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 40,
      colorsets: {
        1: Colors.green.shade200,
        2: Colors.green.shade300,
        3: Colors.green.shade400,
        4: Colors.green.shade500,
        5: Colors.green.shade600,
        6: Colors.green.shade700,
      },
    );
  }
}
