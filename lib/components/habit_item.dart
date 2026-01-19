import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_status.dart';

class HabitItem extends StatelessWidget {
  // final Habit habit;
  // final VoidCallback onToggle;
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;

  const HabitItem({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    // required this.habit,
    // required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
        children: [
          Checkbox(
            value: habitCompleted,
            onChanged: onChanged,
          ),
           Text(habitName),
        ],
      ),

      ),
    );
  }
}
