import 'package:flutter/material.dart';
import 'package:habit_tracker/widgets/habit_item.dart';
import '../widgets/fab_add_item.dart';
import '../widgets/my_alert_box.dart';
import '../models/habit.dart';
import '../mixins/loggable.dart';
import '../data/habit_local_storage.dart';
import '../components/month_summary.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Loggable {
  late final HabitLocalStorage habitStorage;
  late List<Habit> todaysHabitList;
  DateTime? selectedDate;
  List<Habit> selectedDateHabits = [];

  @override
  void initState() {
    super.initState();
    habitStorage = HabitLocalStorage();
    todaysHabitList = habitStorage.getHabits();
    habitStorage.loadHeatMap();
  }

  void checkBoxTapped(bool? value, int index) {
    if (selectedDate != null) {
      setState(() {
        selectedDateHabits[index].completed = value ?? false;
      });
      habitStorage.saveHabitsForDate(selectedDate!, selectedDateHabits);
    } else {
      setState(() {
        todaysHabitList[index].completed = value ?? false;
      });
      habitStorage.updateDatabase(
        todaysHabitList.map((h) => h.toList()).toList(),
      );
    }
  }

  final _newHabitNameController = TextEditingController();

  @override
  void dispose() {
    _newHabitNameController.dispose();
    super.dispose();
  }

  void onDateTapped(DateTime date) {
    log('Date tapped: $date');
    setState(() {
      selectedDate = date;
      selectedDateHabits = habitStorage.getHabitsForDate(date);
    });
  }

  void resetToToday() {
    setState(() {
      selectedDate = null;
      selectedDateHabits = [];
    });
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter habit name here...',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void saveNewHabit() {
    final name = _newHabitNameController.text.trim();
    if (name.isEmpty) {
      logWarning('User tried to create habit with empty name');
      return;
    }
    
    final currentHabits = selectedDate != null ? selectedDateHabits : todaysHabitList;
    final existingNames = currentHabits
        .map((h) => h.name.toLowerCase())
        .toSet();

    if (existingNames.contains(name.toLowerCase())) {
      logWarning('Habit with this name already exists');
      return;
    }

    log('Creating habit: $name');

    setState(() {
      final newHabit = Habit(name: name);
      if (selectedDate != null) {
        selectedDateHabits.add(newHabit);
      } else {
        todaysHabitList.add(newHabit);
      }
      _newHabitNameController.clear();
    });

    if (selectedDate != null) {
      habitStorage.saveHabitsForDate(selectedDate!, selectedDateHabits);
    } else {
      habitStorage.saveHabits(todaysHabitList);
      habitStorage.updateDatabase(
        todaysHabitList.map((h) => h.toList()).toList(),
      );
    }
    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    _newHabitNameController.text = todaysHabitList[index].name;
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Edit habit name',
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    final newName = _newHabitNameController.text.trim();
    if (newName.isEmpty) {
      logWarning('User tried to save habit with empty name');
      return;
    }

    setState(() {
      if (selectedDate != null) {
        selectedDateHabits[index].name = newName;
      } else {
        todaysHabitList[index].name = newName;
      }
      _newHabitNameController.clear();
    });

    if (selectedDate != null) {
      habitStorage.saveHabitsForDate(selectedDate!, selectedDateHabits);
    } else {
      habitStorage.saveHabits(todaysHabitList);
      habitStorage.updateDatabase(
        todaysHabitList.map((h) => h.toList()).toList(),
      );
    }
    Navigator.pop(context);
  }

  void deleteHabit(int index) {
    if (selectedDate != null) {
      log('Deleting habit with id: ${selectedDateHabits[index].id}');
      setState(() {
        selectedDateHabits.removeAt(index);
      });
      habitStorage.saveHabitsForDate(selectedDate!, selectedDateHabits);
    } else {
      log('Deleting habit with id: ${todaysHabitList[index].id}');
      setState(() {
        todaysHabitList.removeAt(index);
      });
      habitStorage.saveHabits(todaysHabitList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayHabits = selectedDate != null ? selectedDateHabits : todaysHabitList;
    
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          MonthlySummary(
            datasets: habitStorage.heatMapDataSet,
            startDate: habitStorage.getStartDate(),
            onDateTapped: onDateTapped,
            selectedDate: selectedDate,
          ),

          if (selectedDate != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //chosen date
                      Text(
                        '${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: resetToToday,
                    icon: const Icon(Icons.today, size: 18),
                    label: const Text('Today'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayHabits.length,
            itemBuilder: (contex, index) {
              return HabitItem(
                habit: displayHabits[index],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
