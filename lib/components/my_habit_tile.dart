import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String habit;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  const MyHabitTile({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          //toggle isCompleted
          onChanged!(!isCompleted);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isCompleted
              ? Colors.green
              : Theme.of(context).colorScheme.secondary,
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: EdgeInsets.all(15),
        child: ListTile(
          leading: Checkbox(
            value: isCompleted,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
          title: Text(
            habit,
            style: TextStyle(color: isCompleted ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
