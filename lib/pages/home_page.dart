import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittracker/components/my_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a habit'),
          content: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hint: Text('Add a new habit'),
            ),
          ),
          actions: [
            //cancel button
            MaterialButton(onPressed: () {}, child: Text('Cancel')),
            //save button
            MaterialButton(onPressed: () {}, child: Text('Save')),
          ],
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
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: Icon(Icons.add),
      ),
    );
  }
}
