import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_item.dart';
import '../components/fab_add_item.dart';
import '../components/my_alert_box.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List todaysHabitList = [
    // [habitName, habitCompleted]
    ['Morning run', false],
    ['Read a book', false],
    ['Meditation', false],
    ['Practice coding', false],
  ];
  bool habitCompleted = false;

  // сheckbox tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      habitCompleted = value!;
      todaysHabitList[index][1] = value;
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
    setState(() {
      todaysHabitList.add([_newHabitNameController.text, false]);
      _newHabitNameController.clear();
      Navigator.of(context).pop();
    });
  }
  //cancel new habit

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  // open habit settings for editing
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit after editing
  void saveExistingHabit(int index) {
    setState(() {
      todaysHabitList[index][0] = _newHabitNameController.text;
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
            habitName: todaysHabitList[index][0],
            habitCompleted: todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped: (context) => openHabitSettings(index),
            deleteTapped: (context) => deleteHabit(index),
          );
        },
      ),
    );
  }
}
