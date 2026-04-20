import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/components/my_drawer.dart';
import 'package:habittracker/providers/database_provider.dart';
import 'package:habittracker/repositories/habit_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController textController = TextEditingController();
  String errorText = '';
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Add a habit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hint: Text('Add a new habit'),
                    ),
                  ),
                  Text(errorText, style: TextStyle(color: Colors.red)),
                ],
              ),
              actions: [
                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop the page
                    Navigator.pop(context);
                    //clear the text
                    textController.clear();
                  },
                  child: const Text('Cancel'),
                ),
                //save button
                MaterialButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      //get the new habit name
                      final newHabit = textController.text;
                      //save it to database
                      ref
                          .read(habitNotifierProvider.notifier)
                          .addHabit(newHabit);
                      //pop the page
                      Navigator.pop(context);
                      //clear text
                      textController.clear();
                      errorText = '';
                    } else {
                      errorText = 'Please enter a Habit';
                      setState(() {});
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'settingsPage');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      drawer: const MyDrawer(),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  Widget? _buildHabitList() {
    //habit database current stored habits
    final habitsAsync = ref.watch(habitNotifierProvider);

    return habitsAsync.when(
      data: (habitList) {
        return ListView.builder(
          itemCount: habitList.length,
          itemBuilder: (BuildContext context, int index) {
            final habit = habitList[index];

            return ListTile(title: Text(habit.name));
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text("Error: $error"));
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
