import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    //change it to another widget later
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Enter new habit'),
      content: TextField(
        decoration: InputDecoration(
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
