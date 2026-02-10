import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/utils/time_converter.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: HeatMap(
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
        colorsets: const {
          1: Color(0xFFFCE4EC),
          2: Color(0xFFF8BBD0),
          3: Color(0xFFF48FB1),
          4: Color(0xFFEC407A),
          5: Color(0xFFD81B60),
        },
      ),
    );
  }
}
