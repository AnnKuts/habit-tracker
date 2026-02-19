import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerSheet extends StatefulWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;

  const ColorPickerSheet({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<ColorPickerSheet> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Select App Color",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor,
                  enableAlpha: false,
                  displayThumbColor: true,
                  onColorChanged: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onColorChanged(selectedColor);
                  Navigator.pop(context);
                },
                child: const Text("Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
