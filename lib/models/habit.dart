import 'habit_status.dart';

class Habit {
  final String title;
  HabitStatus status;

  Habit({
    required this.title,
    this.status = HabitStatus.none,
  }) : assert(title.length > 2);

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      title: map['title'] ?? 'No title',
      status: HabitStatus.values[
      map['status'] ?? HabitStatus.none.index
      ],
    );
  }
}
