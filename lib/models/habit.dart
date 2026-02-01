import 'package:uuid/uuid.dart';

class Habit {
  static const _uuid = Uuid();

  final String id;
  String name;
  bool completed;

  Habit({String? id, required String name, this.completed = false})
    : id = id ?? _uuid.v4(),
      assert(name.trim().isNotEmpty, 'Habit name cannot be empty'),
      name = name.trim();

  factory Habit.fromList(List<dynamic> data) {
    return Habit(
      id: data[0] as String,
      name: data[1] as String,
      completed: data[2] as bool,
    );
  }
  List<dynamic> toList() => [id, name, completed];
}
