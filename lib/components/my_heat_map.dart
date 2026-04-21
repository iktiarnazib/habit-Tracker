import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/theme_provider.dart';

class MonthlyHeatMap extends ConsumerWidget {
  final DateTime month;
  final Map<DateTime, int> datasets;

  const MonthlyHeatMap({
    super.key,
    required this.month,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeProvider);
    final mode = darkMode == themeMode;

    // First day of month
    final firstDay = DateTime(month.year, month.month, 1);

    // Total days in month
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // What weekday the month starts on (0 = Sunday)
    final startWeekday = firstDay.weekday % 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month title
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "${month.year}-${month.month}-${month.day}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + startWeekday,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            // Empty cells before month starts
            if (index < startWeekday) {
              return const SizedBox();
            }

            final day = index - startWeekday + 1;
            final date = DateTime(month.year, month.month, day);

            final normalizedDate = DateTime(date.year, date.month, date.day);

            final value = datasets[normalizedDate] ?? 0;

            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getColor(value, context),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "$day",
                  style: TextStyle(color: mode ? Colors.white : Colors.black),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getColor(int value, BuildContext context) {
    if (value == 0) {
      return Theme.of(context).colorScheme.primary;
    } else if (value == 1) {
      return Colors.green.shade200;
    } else if (value == 2) {
      return Colors.green.shade300;
    } else if (value == 3) {
      return Colors.green.shade400;
    } else if (value == 4) {
      return Colors.green.shade500;
    } else if (value == 5) {
      return Colors.green.shade600;
    } else {
      return Colors.green.shade700;
    }
  }
}
