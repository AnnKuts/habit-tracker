import 'package:flutter/material.dart';
import '../utils/time_converter.dart';

class HomePageWidgets {
  static Widget buildSelectedDateCard({
    required DateTime date,
    required VoidCallback onResetToToday,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatDateDisplay(date),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: onResetToToday,
            icon: const Icon(Icons.today, size: 18),
            label: const Text('Today'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[200],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
