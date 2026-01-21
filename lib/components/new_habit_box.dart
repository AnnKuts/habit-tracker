import 'package:flutter/material.dart';

class EnterNewHabitBox extends StatelessWidget {
  const EnterNewHabitBox({super.key});

  @override
  Widget build(BuildContext context) {
    //change it to another widget later
    return AlertDialog(
      title: const Text('Enter new habit'),
      content: TextField(),
      actions: [
        MaterialButton(
          onPressed: () {},
          child: Text('Save', style: TextStyle(color: Colors.white)),
          color: Colors.pink.shade200,
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
