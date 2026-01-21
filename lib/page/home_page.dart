import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_item.dart';
import '../components/fab_add_item.dart';
import '../components/new_habit_box.dart';

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

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return EnterNewHabitBox();
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
          );
        },
      ),
    );
  }
}
