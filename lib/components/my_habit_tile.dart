import 'package:flutter/material.dart';
import 'package:habittracker/components/my_pop_up_settings.dart';
import 'package:popover/popover.dart';

class MyHabitTile extends StatelessWidget {
  final String habit;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;
  const MyHabitTile({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onChanged,
    required this.onEditTap,
    required this.onDeleteTap,
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
          trailing: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  showPopover(
                    height: 100,
                    width: 100,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    context: context,
                    bodyBuilder: (context) {
                      return MyPopUpSettings(
                        onEditTap: onEditTap,
                        onDeleteTap: onDeleteTap,
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.more_vert,
                  color: isCompleted ? Colors.white : Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
