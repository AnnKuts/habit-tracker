import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:habit_tracker/page/home_page.dart';
import 'package:habit_tracker/page/settings_page.dart';
import 'package:habit_tracker/page/navigation_page.dart';
import 'package:habit_tracker/models/settings_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('habits_box');

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Habit Tracker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settings.seedColor,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settings.seedColor,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // home: MyHomePage(title: 'Habit Tracker'),
          // home: SettingsPage(
          //   title: 'Settings',
          //   isDarkMode: isDarkMode,
          //   onThemeChanged: findTheme,
          //   appColor: seedColor,
          //   onColorChanged: changeColor,
          home: const MainNavigationPage(),
        );
      },
    );
  }
}
