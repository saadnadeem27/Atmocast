import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Premium blue gradient theme
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);

  // Background Gradients
  static const Color backgroundStart = Color(0xFF0F172A);
  static const Color backgroundEnd = Color(0xFF1E293B);

  // Weather-based Gradients
  static const List<Color> sunnyGradient = [
    Color(0xFFFFB347),
    Color(0xFFFFCC33),
    Color(0xFFFFD700),
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF64748B),
    Color(0xFF94A3B8),
    Color(0xFFCBD5E1),
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF1E3A8A),
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFF334155),
  ];

  static const List<Color> snowGradient = [
    Color(0xFFE2E8F0),
    Color(0xFFF1F5F9),
    Color(0xFFFFFBEB),
  ];

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE2E8F0);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDark = Color(0xFF1E293B);

  // Card Colors
  static const Color cardBackground = Color(0x20FFFFFF);
  static const Color cardBorder = Color(0x30FFFFFF);
  static const Color glassEffect = Color(0x15FFFFFF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Shimmer Colors
  static const Color shimmerBase = Color(0x20FFFFFF);
  static const Color shimmerHighlight = Color(0x30FFFFFF);

  // Weather Condition Colors
  static const Color uvLow = Color(0xFF10B981);
  static const Color uvModerate = Color(0xFFF59E0B);
  static const Color uvHigh = Color(0xFFEF4444);
  static const Color uvVeryHigh = Color(0xFF7C2D12);

  // Helper method to get weather gradient based on condition
  static List<Color> getWeatherGradient(String condition, bool isDay) {
    if (!isDay) return nightGradient;

    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return sunnyGradient;
      case 'clouds':
      case 'cloudy':
        return cloudyGradient;
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return rainyGradient;
      case 'snow':
        return snowGradient;
      default:
        return cloudyGradient;
    }
  }
}
