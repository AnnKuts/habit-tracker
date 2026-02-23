import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:habit_tracker/api/groq_api.dart';
import 'package:habit_tracker/data/habit_local_storage.dart';
import 'package:habit_tracker/models/habit.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  String? _result;
  bool _loading = false;

  Future<String> _buildPrompt() async {
    final storage = HabitLocalStorage();
    final List<Habit> habits = storage.getHabits();
    final int streak = storage.calculateStreak();
    final int bestStreak = storage.getBestStreak();
    final int totalCompletedDays = storage.getTotalCompletedDays();

    storage.loadHeatMap();
    final Map<DateTime, int> heatmap = storage.heatMapDataSet;

    final buffer = StringBuffer();

    // example of prompt:
    // You are a professional productivity coach.
    //
    // Current habit status:
    // - Morning run: completed
    //     - Meditation: not completed
    //
    // Statistics:
    // Current streak: 4 days
    // Best streak: 9 days
    // Total productive days: 18
    //
    // Heatmap activity:
    // Activity levels by day:
    // - 2025-02-01: activity score 7
    // - 2025-02-02: activity score 4
    // - 2025-02-03: activity score 2
    //
    // Please analyze and provide:
    // 1. Patterns of lower activity.
    // 2. Which habits lack consistency.
    // 3. What the user should focus on improving.
    // 4. 3 concrete productivity recommendations.
    //
    // Use markdown formatting with headings.

    buffer.writeln('You are a professional productivity coach.\n');
    buffer.writeln('Current habit status:');
    if (habits.isEmpty) {
      buffer.writeln('No habits found.');
    } else {
      for (final habit in habits) {
        buffer.writeln(
          "- ${habit.name}: ${habit.completed ? "completed" : "not completed"}",
        );
      }
    }

    buffer.writeln('\nStatistics:');
    buffer.writeln('Current streak: $streak days');
    buffer.writeln('Best streak: $bestStreak days');
    buffer.writeln('Total productive days: $totalCompletedDays');

    buffer.writeln('\nHeatmap activity:');
    if (heatmap.isEmpty) {
      buffer.writeln('No heatmap data available.');
    } else {
      buffer.writeln('Activity levels by day:');
      final heatmapList = heatmap.entries.toList();
      for (var entry in heatmapList.take(21)) {
        buffer.writeln(
          '- ${entry.key.toString().split(' ')[0]}: activity score ${entry.value}',
        );
      }
      if (heatmapList.length > 21) {
        buffer.writeln('...and ${heatmapList.length - 21} more days.');
      }
    }

    buffer.writeln('\nPlease analyze and provide:');
    buffer.writeln('1. Patterns of lower activity.');
    buffer.writeln('2. Which habits lack consistency.');
    buffer.writeln('3. What the user should focus on improving.');
    buffer.writeln('4. 3 concrete productivity recommendations.');
    buffer.writeln('\nUse markdown formatting with headings.');

    return buffer.toString();
  }

  Future<void> _analyzeHabits() async {
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final prompt = await _buildPrompt();
      final aiResponse = await GroqApi.fetchAIResponse(prompt);

      setState(() {
        _result = aiResponse;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('AI Habit Analysis'),
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get personalised insights on your habits\nand how to boost your productivity',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _analyzeHabits,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Analyse My Habits'),
                ),
                const SizedBox(height: 32),
                if (_result != null)
                  Container(
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: MarkdownBody(
                      data: _result!,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyLarge,
                        h1: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        h2: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        listBullet: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
