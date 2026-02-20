import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:habit_tracker/components/color_picker_sheet.dart';
import 'package:habit_tracker/models/settings_model.dart';

class SettingsPage extends StatelessWidget {
  final String title;

  const SettingsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    final appColor = settings.seedColor;

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
            value: settings.isDarkMode,
            onChanged: (value) {
              Provider.of<SettingsModel>(
                context,
                listen: false,
              ).setDarkMode(value);
            },
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
                  builder: (sheetContext) {
                    return FractionallySizedBox(
                      heightFactor: 0.75,
                      child: ColorPickerSheet(
                        currentColor: appColor,
                        onColorChanged: (color) {
                          Provider.of<SettingsModel>(
                            context,
                            listen: false,
                          ).setSeedColor(color);
                        },
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
