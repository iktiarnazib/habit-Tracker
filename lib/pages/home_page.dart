import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/components/my_habit_tile.dart';
import 'package:habittracker/components/my_heat_map.dart';
import 'package:habittracker/database/app_database.dart';
import 'package:habittracker/repositories/habit_repository.dart';
import 'package:habittracker/util/habit_util.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController textController = TextEditingController();
  TextEditingController updateTextController = TextEditingController();
  String errorText = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(habitNotifierProvider.notifier).initFirstLaunchDate(),
    );
  }

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
                  if (errorText.isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(errorText, style: TextStyle(color: Colors.red)),
                      ],
                    ),
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
                    //error text reset
                    errorText = '';
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
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Color.fromARGB(255, 46, 125, 50)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //on Completed Changed setting value for listTiles
  void onCompletedChanged(bool? value, Habit habit) {
    if (value != null) {
      ref
          .read(habitNotifierProvider.notifier)
          .updateCompletionStatus(habit, value);
    }
  }

  //Edit Database
  void onEditTap(int id, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            updateTextController.text = name;
            return AlertDialog(
              title: const Text('Edit Your Habit'),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: updateTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hint: Text('Update your habit'),
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
                    if (updateTextController.text.isNotEmpty) {
                      //get the new habit name
                      final updatedHabit = updateTextController.text;
                      //save it to database
                      ref
                          .read(habitNotifierProvider.notifier)
                          .updateHabitName(id, updatedHabit);
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

  //delete from Database
  void onDeleteTap(int id, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text("Do you want to delete \"$name\" habit?"),
              actions: [
                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop the page
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                //save button
                MaterialButton(
                  onPressed: () {
                    //delete text
                    ref.read(habitNotifierProvider.notifier).deleteHabit(id);
                    //pop the page
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
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
        title: Text('Habit Tracker', style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'settingsPage');
            },
            icon: Icon(Icons.settings),
          ),
        ],
        centerTitle: true,
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FloatingActionButton(
          onPressed: createNewHabit,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: Icon(Icons.add, color: Colors.green),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 15),
          //HEAT MAP
          _buildHeatMap(),
          //space
          SizedBox(height: 10),
          //title text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30),
            child: Text(
              'Habits',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 35,
                fontFamily: "DMSerifTexts",
                fontStyle: FontStyle.normal,
              ),
            ),
          ),

          //HABIT LIST
          _buildHabitList(),
        ],
      ),
    );
  }

  //Habits list
  Widget _buildHabitList() {
    //habit database current stored habits
    final habitsAsync = ref.watch(habitNotifierProvider);

    return habitsAsync.when(
      data: (habitList) {
        if (habitList.isEmpty) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Text(
                'Please add a habit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habitList.length,
          itemBuilder: (BuildContext context, int index) {
            //check individual habits
            final habit = habitList[index];

            //checking if the habit is completed today
            bool isCompletedToday = isTheHabitCompletedToday(
              habit.completedDays,
            );
            return MyHabitTile(
              habit: habit.name,
              isCompleted: isCompletedToday,
              onChanged: (value) => onCompletedChanged(value, habit),
              onEditTap: () => onEditTap(habit.id, habit.name),
              onDeleteTap: () => onDeleteTap(habit.id, habit.name),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text("Error: $error"));
      },
      loading: () =>
          Center(child: const CircularProgressIndicator(color: Colors.blue)),
    );
  }

  Widget _buildHeatMap() {
    //all habits
    final currentHabits = ref.watch(habitNotifierProvider);

    //first Launched
    final firstLaunched = ref
        .watch(habitNotifierProvider.notifier)
        .getFirstLaunchDate();

    return currentHabits.when(
      data: (data) {
        return FutureBuilder(
          future: firstLaunched,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: MonthlyHeatMap(
                  datasets: prepHeatMapDataset(data),
                  month: DateTime.now(),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text("Error: $error"));
      },
      loading: () => Center(child: const CircularProgressIndicator()),
    );
  }
}

//Habit Tracker app done.
