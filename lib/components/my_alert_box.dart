import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintStyle;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    this.hintStyle,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    //change it to another widget later
    return AlertDialog(
      backgroundColor: Colors.white,
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink.shade400),
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          child: Text('Save', style: TextStyle(color: Colors.white)),
          color: Colors.pink.shade200,
        ),
        MaterialButton(
          onPressed: onCancel,
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
          color: Colors.pink.shade200,
        ),
      ],

      // autofocus: true,
      // onSubmitted: (newHabitName) {
      //   Navigator.of(context).pop();
      // }
    );
  }
}
