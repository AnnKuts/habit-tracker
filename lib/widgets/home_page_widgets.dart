import 'package:flutter/material.dart';
import '../utils/time_converter.dart';

class HomePageWidgets {
  static Widget buildSelectedDateCard({
    required BuildContext context,
    required DateTime date,
    required VoidCallback onResetToToday,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 1,
        color: scheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDateDisplay(date),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              FilledButton.icon(
                onPressed: onResetToToday,
                icon: const Icon(Icons.today, size: 18),
                label: const Text('Today'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
