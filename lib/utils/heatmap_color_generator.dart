import 'package:flutter/material.dart';

class HeatmapColorBuilder {
  static Map<int, Color> fromColorScheme(ColorScheme scheme, {int steps = 10}) {
    if (steps < 2) {
      return {1: scheme.primary};
    }

    final colors = <int, Color>{};

    final baseSurface = scheme.surface;
    final containerAccent = scheme.primaryContainer;
    final primaryAccent = scheme.primary;

    for (int i = 0; i < steps; i++) {
      final progress = i / (steps - 1);

      final color = progress < 0.5
          ? Color.lerp(baseSurface, containerAccent, progress * 2)
          : Color.lerp(containerAccent, primaryAccent, (progress - 0.5) * 2);

      colors[i + 1] = color!;
    }

    return colors;
  }
}
