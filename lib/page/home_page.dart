import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_item.dart';
import '../components/fab_add_item.dart';
import '../components/my_alert_box.dart';
import '../models/habit.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Habit> todaysHabitList = [
    Habit(id: '1', name: 'Morning run'),
    Habit(id: '2', name: 'Read a book'),
    Habit(id: '3', name: 'Meditation'),
    Habit(id: '4', name: 'Practice coding'),
  ];

  // сheckbox tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index].completed = value ?? false;
    });
  }

  // new habit created
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter habit name here...',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
        // return AlertDialog(
        //   title: const Text('Create New Habit'),
        //   content: TextField(
        //     autofocus: true,
        //     onSubmitted: (newHabitName) {
        //       setState(() {
        //         todaysHabitList.add([newHabitName, false]);
        //       });
        //       Navigator.of(context).pop();
        //     }
        //       ),
        // );
      },
    );
  }

  //save new habit
  void saveNewHabit() {
    final name = _newHabitNameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      todaysHabitList.add(
        Habit(id: DateTime.now().toIso8601String(), name: name),
      );
      _newHabitNameController.clear();
    });
    Navigator.of(context).pop();
  }
  //cancel new habit

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  // open habit settings for editing
  void openHabitSettings(int index) {
    _newHabitNameController.text = todaysHabitList[index].name;
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Edit habit name',
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit after editing
  void saveExistingHabit(int index) {
    setState(() {
      todaysHabitList[index].name = _newHabitNameController.text;
      _newHabitNameController.clear();
    });
    Navigator.pop(context);
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      todaysHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView.builder(
        itemCount: todaysHabitList.length,
        itemBuilder: (contex, index) {
          // [HabitItem(
          //   habitName: 'Morning run',
          //   habitCompleted: habitCompleted,
          //   onChanged: checkBoxTapped,
          // ),],
          // habit: _habit,
          // onToggle: _handleToggle,
          return HabitItem(
            habit: todaysHabitList[index],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped: (context) => openHabitSettings(index),
            deleteTapped: (context) => deleteHabit(index),
          );
        },
      ),
    );
  }
}
