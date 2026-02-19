import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/utils/time_converter.dart';
import 'package:habit_tracker/utils/heatmap_color_generator.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: HeatMap(
        startDate: createDataTimeObject(startDate),
        endDate: DateTime.now(),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: scheme.surfaceContainerHighest.withOpacity(0.3),
        textColor: scheme.onSurface,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 20,
        fontSize: 10,
        onClick: (date) {
          if (onDateTapped != null) {
            onDateTapped!(date);
          }
        },
        colorsets: HeatmapColorBuilder.fromColorScheme(scheme),
      ),
    );
  }
}
