import 'package:flutter/material.dart';
import 'package:habit_tracker/widgets/habit_item.dart';
import '../widgets/fab_add_item.dart';
import '../widgets/my_alert_box.dart';
import '../models/habit.dart';
import '../mixins/loggable.dart';
import '../data/habit_local_storage.dart';
import '../components/month_summary.dart';
import '../utils/habit_validator.dart';
import '../utils/time_converter.dart';
import '../widgets/home_page_widgets.dart';
import '../widgets/streak_card.dart';
import '../page/settings_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Color appColor;
  final Function(Color) onColorChanged;

  const MyHomePage({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.appColor,
    required this.onColorChanged,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Loggable {
  late final HabitLocalStorage habitStorage;
  late List<Habit> todaysHabitList;
  DateTime? selectedDate;
  List<Habit> selectedDateHabits = [];
  final _newHabitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    habitStorage = HabitLocalStorage();
    todaysHabitList = habitStorage.getHabits();
    habitStorage.loadHeatMap();
  }

  @override
  void dispose() {
    _newHabitNameController.dispose();
    super.dispose();
  }

  List<Habit> get currentHabits =>
      selectedDate != null ? selectedDateHabits : todaysHabitList;
  bool get isViewingToday => selectedDate == null;

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      currentHabits[index].completed = value ?? false;
    });
    _saveCurrentHabits();
  }

  void createNewHabit() {
    _showHabitDialog(
      onSave: _saveNewHabit,
      hintText: 'Enter habit name here...',
    );
  }

  void editHabit(int index) {
    _newHabitNameController.text = currentHabits[index].name;
    _showHabitDialog(
      onSave: () => _updateHabit(index),
      hintText: 'Edit habit name',
    );
  }

  void deleteHabit(int index) {
    log('Deleting habit with id: ${currentHabits[index].id}');
    setState(() {
      currentHabits.removeAt(index);
    });
    _saveCurrentHabits();
  }

  void _saveNewHabit() {
    final name = HabitValidator.normalizeName(_newHabitNameController.text);
    if (!HabitValidator.isValidName(name)) {
      logWarning('User tried to create habit with empty name');
      return;
    }
    if (HabitValidator.nameExists(name, currentHabits)) {
      logWarning('Habit with this name already exists');
      return;
    }

    log('Creating habit: $name');
    setState(() {
      currentHabits.add(Habit(name: name));
    });

    _saveCurrentHabits();
    _closeDialog();
  }

  void _updateHabit(int index) {
    final newName = HabitValidator.normalizeName(_newHabitNameController.text);

    if (!HabitValidator.isValidName(newName)) {
      logWarning('User tried to save habit with empty name');
      return;
    }

    setState(() {
      currentHabits[index].name = newName;
    });

    _saveCurrentHabits();
    _closeDialog();
  }

  void _saveCurrentHabits() {
    if (isViewingToday) {
      habitStorage.updateDatabase(
        todaysHabitList.map((h) => h.toList()).toList(),
      );
    } else {
      habitStorage.saveHabitsForDate(selectedDate!, selectedDateHabits);
    }
  }

  void _showHabitDialog({
    required VoidCallback onSave,
    required String hintText,
  }) {
    showDialog(
      context: context,
      builder: (context) => MyAlertBox(
        controller: _newHabitNameController,
        hintText: hintText,
        onSave: onSave,
        onCancel: _closeDialog,
      ),
    );
  }

  void _closeDialog() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void onDateTapped(DateTime date) {
    final normalizedDate = normalizeDate(date);
    log('Date tapped: $normalizedDate');

    setState(() {
      selectedDate = normalizedDate;
      selectedDateHabits = habitStorage.getHabitsForDate(normalizedDate);
    });
  }

  void resetToToday() {
    setState(() {
      selectedDate = getToday();
      selectedDateHabits = todaysHabitList;
    });
  }

  int _calculateItemCount() {
    final habitCount = currentHabits.length;
    final hasSelectedDate = selectedDate != null;
    return habitCount + (hasSelectedDate ? 3 : 2);
  }

  Widget _buildListItem(int index) {
    if (index == 0) {
      return StreakCard(streakDays: habitStorage.calculateStreak());
    }

    if (index == 1) {
      return _buildCalendar();
    }

    if (index == 2 && selectedDate != null) {
      return HomePageWidgets.buildSelectedDateCard(
        context: context,
        date: selectedDate!,
        onResetToToday: resetToToday,
      );
    }

    final habitIndex = selectedDate != null ? index - 3 : index - 2;
    if (habitIndex >= 0 && habitIndex < currentHabits.length) {
      return _buildHabitItem(habitIndex);
    }

    return const SizedBox.shrink();
  }

  Widget _buildCalendar() {
    return MonthlySummary(
      datasets: habitStorage.heatMapDataSet,
      startDate: habitStorage.getStartDate(),
      onDateTapped: onDateTapped,
      selectedDate: selectedDate,
    );
  }

  Widget _buildHabitItem(int index) {
    return HabitItem(
      habit: currentHabits[index],
      onChanged: (value) => checkBoxTapped(value, index),
      settingsTapped: (context) => editHabit(index),
      deleteTapped: (context) => deleteHabit(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      drawer: Drawer(
        backgroundColor: scheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: scheme.onSurfaceVariant),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      title: 'Settings',
                      isDarkMode: widget.isDarkMode,
                      onThemeChanged: widget.onThemeChanged,
                      appColor: widget.appColor,
                      onColorChanged: widget.onColorChanged,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView.builder(
        itemCount: _calculateItemCount(),
        itemBuilder: (context, index) => _buildListItem(index),
      ),
    );
  }
}