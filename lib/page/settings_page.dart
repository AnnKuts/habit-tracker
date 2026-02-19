import 'package:flutter/material.dart';
import 'package:habit_tracker/components/color_picker_sheet.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Color appColor;
  final Function(Color) onColorChanged;

  const SettingsPage({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.appColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(appColor);
    final scheme = Theme.of(context).colorScheme;

    final textColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),

          const SizedBox(height: 12),

          ListTile(
            title: const Text('App Color'),
            trailing: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: appColor,
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.75,
                      child: ColorPickerSheet(
                        currentColor: appColor,
                        onColorChanged: onColorChanged,
                      ),
                    );
                  },
                );
              },
              child: const Text('Change'),
            ),
          ),
        ],
      ),
    );
  }
}
