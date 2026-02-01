class Habit {
  final String id;
  String name;
  bool completed;

  Habit({required this.id, required String name, this.completed = false})
    : assert(name.trim().isNotEmpty, 'Habit name cannot be empty'),
      name = name.trim();

  factory Habit.fromList(List<dynamic> data) {
    return Habit(
      id: DateTime.now().toIso8601String(),
      name: data[0] as String,
      completed: data[1] as bool,
    );
  }
}
