import '../models/habit.dart';

class HabitValidator {
  static bool isValidName(String name) {
    return name.trim().isNotEmpty;
  }

  static bool nameExists(String name, List<Habit> existingHabits) {
    final lowerName = name.toLowerCase();
    return existingHabits.any((habit) => habit.name.toLowerCase() == lowerName);
  }

  static String normalizeName(String name) {
    return name.trim();
  }
}
