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

  @override
  void initState() {
    super.initState();
    habitStorage = HabitLocalStorage();
    todaysHabitList = habitStorage.getHabits();
    habitStorage.loadHeatMap();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index].completed = value ?? false;
    });
    habitStorage.updateDatabase(
      todaysHabitList.map((h) => h.toList()).toList(),
    );
  }

  final _newHabitNameController = TextEditingController();

  @override
  void dispose() {
    _newHabitNameController.dispose();
    super.dispose();
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
    log('Creating habit: $name');

    setState(() {
      todaysHabitList.add(Habit(name: name));
      _newHabitNameController.clear();
    });

    habitStorage.saveHabits(todaysHabitList);
    habitStorage.updateDatabase(
      todaysHabitList.map((h) => h.toList()).toList(),
    );
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
    setState(() {
      todaysHabitList[index].name = _newHabitNameController.text;
      _newHabitNameController.clear();
      _newHabitNameController.clear();
    });
    habitStorage.saveHabits(todaysHabitList);
    habitStorage.updateDatabase(
      todaysHabitList.map((h) => h.toList()).toList(),
    );
    Navigator.pop(context);
  }

  void deleteHabit(int index) {
    log('Deleting habit with id: ${todaysHabitList[index].id}');
    setState(() {
      todaysHabitList.removeAt(index);
    });
    habitStorage.saveHabits(todaysHabitList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          MonthlySummary(
            datasets: habitStorage.heatMapDataSet,
            startDate: habitStorage.getStartDate(),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todaysHabitList.length,
            itemBuilder: (contex, index) {
              return HabitItem(
                habit: todaysHabitList[index],
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
