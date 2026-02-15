import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/utils/time_converter.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final String startDate;
  final Function(DateTime)? onDateTapped;
  final DateTime? selectedDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
    this.onDateTapped,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          HeatMap(
        startDate: createDataTimeObject(startDate),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.black,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        onClick: (date) {
          if (onDateTapped != null) {
            onDateTapped!(date);
          }
        },
        colorsets: const {
          1: Color(0xFFFFEBEE),
          2: Color(0xFFFFCDD2),
          3: Color(0xFFEF9A9A),
          4: Color(0xFFE57373),
          5: Color(0xFFEF5350),
          6: Color(0xFFE91E63),
          7: Color(0xFFD81B60),
          8: Color(0xFFC2185B),
          9: Color(0xFFAD1457),
          10: Color(0xFF880E4F),
        },
      ),
    ]
      ),
    );
  }
}
