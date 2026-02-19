import 'package:flutter/material.dart';
import 'package:habit_tracker/page/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/page/settings_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('habits_box');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  Color seedColor = Colors.pink.shade200;

  void findTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void changeColor(Color color) {
    setState(() {
      seedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // home: MyHomePage(title: 'Habit Tracker'),
      home: SettingsPage(
        title: 'Settings',
        isDarkMode: isDarkMode,
        onThemeChanged: findTheme,
        appColor: seedColor,
        onColorChanged: changeColor,
      ),
    );
  }
}
