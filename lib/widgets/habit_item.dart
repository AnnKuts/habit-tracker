import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitItem({
    super.key,
    required this.habit,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.45,
          children: [
            //settings option
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  color: scheme.secondaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => settingsTapped?.call(context),
                    child: Center(
                      child: Icon(
                        Icons.settings,
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //delete option
            Expanded(
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(12),
                color: scheme.errorContainer,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => deleteTapped?.call(context),
                  child: Center(
                    child: Icon(Icons.delete, color: scheme.onErrorContainer),
                  ),
                ),
              ),
            ),
          ],
        ),

        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Checkbox(value: habit.completed, onChanged: onChanged),
              Expanded(
                child: Text(
                  habit.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
