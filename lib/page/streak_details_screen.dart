import 'package:flutter/material.dart';
import '../widgets/animated_streak_fire.dart';

class StreakDetailsScreen extends StatelessWidget {
  final int streakDays;

  const StreakDetailsScreen({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Streak Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: Hero(
                    tag: 'streak_fire_gold',
                    createRectTween: (begin, end) {
                      return MaterialRectArcTween(begin: begin, end: end);
                    },
                    child: const AnimatedStreakFire(),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  '$streakDays Day Streak',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _buildMotivationText(streakDays),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 56),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Keep Going',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildMotivationText(int days) {
    if (days < 3) {
      return 'Great start! Consistency begins with small steps.';
    } else if (days < 7) {
      return 'You are building momentum. Keep going!';
    } else if (days < 14) {
      return 'Impressive discipline. You are on fire!';
    } else {
      return 'This is elite consistency. Keep the flame alive!';
    }
  }
}
