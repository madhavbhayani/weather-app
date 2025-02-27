import 'package:flutter/material.dart';

class WeatherUtils {
  static List<Color> getBackgroundGradient(String condition, TimeOfDay time) {
    if (time.hour >= 18 || time.hour < 6) {
      // Night gradients
      switch (condition.toLowerCase()) {
        case 'clear':
          return [const Color(0xFF1A237E), const Color(0xFF000000)];
        case 'clouds':
          return [const Color(0xFF37474F), const Color(0xFF263238)];
        case 'rain':
          return [const Color(0xFF1A237E), const Color(0xFF000000)];
        default:
          return [const Color(0xFF1A237E), const Color(0xFF000000)];
      }
    } else {
      // Day gradients
      switch (condition.toLowerCase()) {
        case 'clear':
          return [const Color(0xFF2196F3), const Color(0xFF64B5F6)];
        case 'clouds':
          return [const Color(0xFF90A4AE), const Color(0xFFCFD8DC)];
        case 'rain':
          return [const Color(0xFF616161), const Color(0xFF9E9E9E)];
        default:
          return [const Color(0xFF2196F3), const Color(0xFF64B5F6)];
      }
    }
  }
}
