import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_item.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool habitCompleted = false;

  void checkBoxTapped(bool? value) {
    setState(() {
  habitCompleted = value!;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          HabitItem(
            habitName: 'Morning run',
            habitCompleted: habitCompleted,
            onChanged: checkBoxTapped,
          ),
          // habit: _habit,
          // onToggle: _handleToggle,
        ],
      ),
    );
  }
}