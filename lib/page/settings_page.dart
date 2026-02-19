import 'package:flutter/material.dart';
import 'package:habit_tracker/mixins/loggable.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ],
      ),
    );
  }
}