import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import '../models/habit.dart';
// import '../models/habit_status.dart';

class HabitItem extends StatelessWidget {
  // final Habit habit;
  // final VoidCallback onToggle;
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitItem({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
    // required this.habit,
    // required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            //settings option
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(12),
            ),
            //delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        // startActionPane: ,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(value: habitCompleted, onChanged: onChanged),
              Text(habitName),
            ],
          ),
        ),
      ),
    );
  }
}
