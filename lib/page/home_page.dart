import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_item.dart';
import '../components/fab_add_item.dart';
import '../components/my_alert_box.dart';
import '../models/habit.dart';
import '../mixins/loggable.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Loggable {
  List<Habit> todaysHabitList = [
    Habit(id: '1', name: 'Morning run'),
    Habit(id: '2', name: 'Read a book'),
    Habit(id: '3', name: 'Meditation'),
    Habit(id: '4', name: 'Practice coding'),
  ];

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index].completed = value ?? false;
    });
  }

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
      },
    );
  }

  //save new habit
  void saveNewHabit() {
    final name = _newHabitNameController.text.trim();
    if (name.isEmpty) {
      logWarning('User tried to create habit with empty name');
      return;
    }
    log('Creating habit: $name');

    setState(() {
      todaysHabitList.add(
        Habit(id: DateTime.now().toIso8601String(), name: name),
      );
      _newHabitNameController.clear();
    });
    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

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

  void saveExistingHabit(int index) {
    setState(() {
      todaysHabitList[index].name = _newHabitNameController.text;
      _newHabitNameController.clear();
    });
    Navigator.pop(context);
  }

  void deleteHabit(int index) {
    log('Deleting habit with id: ${todaysHabitList[index].id}');
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
