import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _seedColor = Colors.pinkAccent;

  bool get isDarkMode => _isDarkMode;
  Color get seedColor => _seedColor;

  void setDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
  }

  void setSeedColor(Color color) {
    if (_seedColor.value == color.value) return;
    _seedColor = color;
    notifyListeners();
  }
}
