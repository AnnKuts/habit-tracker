import 'package:flutter/foundation.dart';

mixin Loggable {
  void log(String message) {
    debugPrint('[LOG] $message');
  }

  void logWarning(String message) {
    debugPrint('[WARNING] $message');
  }

  void logError(String message) {
    debugPrint('[ERROR] $message');
  }
}
