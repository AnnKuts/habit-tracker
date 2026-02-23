import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _seedColor = Colors.pinkAccent;

  bool get isDarkMode => _isDarkMode;
  Color get seedColor => _seedColor;

  SettingsModel() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    final savedColor =
        prefs.getInt('seedColor') ?? Colors.pinkAccent.toARGB32();

    _seedColor = Color(savedColor);

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);

    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    if (_seedColor.toARGB32() == color.toARGB32()) return;

    _seedColor = color;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seedColor', color.toARGB32());

    notifyListeners();
  }
}
