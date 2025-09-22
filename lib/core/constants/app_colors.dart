import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Premium gradient theme
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color accent = Color(0xFF06B6D4);

  // Background Gradients
  static const Color backgroundStart = Color(0xFF0F0F23);
  static const Color backgroundEnd = Color(0xFF1A1B3A);

  // Modern Weather-based Gradients
  static const List<Color> sunnyGradient = [
    Color(0xFFFF8A65),
    Color(0xFFFFB74D),
    Color(0xFFFFC107),
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF0F3460),
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF0A0E27),
    Color(0xFF1565C0),
    Color(0xFF2196F3),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF0F0F23),
    Color(0xFF1A1B3A),
    Color(0xFF2D3748),
  ];

  static const List<Color> snowGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFf093fb),
  ];

  static const List<Color> fogGradient = [
    Color(0xFF232526),
    Color(0xFF414345),
    Color(0xFF616161),
  ];

  // Premium Dark Gradients for better contrast
  static const List<Color> premiumDark = [
    Color(0xFF0F0F23),
    Color(0xFF1A1B3A),
    Color(0xFF2D1B69),
  ];

  static const List<Color> premiumBlue = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF6366F1),
  ];

  static const List<Color> premiumPurple = [
    Color(0xFF8B5CF6),
    Color(0xFF7C3AED),
    Color(0xFF6D28D9),
  ];

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE5E7EB);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFF111827);

  // Card Colors with improved glass morphism
  static const Color cardBackground = Color(0x25FFFFFF);
  static const Color cardBorder = Color(0x40FFFFFF);
  static const Color glassEffect = Color(0x20FFFFFF);
  static const Color cardShadow = Color(0x40000000);

  // Status Colors - More vibrant
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF06B6D4);

  // New Professional Colors
  static const Color surfaceLight = Color(0x30FFFFFF);
  static const Color surfaceDark = Color(0x15000000);
  static const Color divider = Color(0x20FFFFFF);
  static const Color overlay = Color(0x80000000);
  // Shimmer Colors
  static const Color shimmerBase = Color(0x20FFFFFF);
  static const Color shimmerHighlight = Color(0x30FFFFFF);

  // Weather Condition Colors
  static const Color uvLow = Color(0xFF10B981);
  static const Color uvModerate = Color(0xFFF59E0B);
  static const Color uvHigh = Color(0xFFEF4444);
  static const Color uvVeryHigh = Color(0xFF7C2D12);

  // Premium UI Colors
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumSilver = Color(0xFFC0C0C0);
  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFFE040FB);

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
      case 'mist':
      case 'fog':
      case 'haze':
        return fogGradient;
      default:
        return cloudyGradient;
    }
  }

  // Helper method to get gradient based on time of day
  static List<Color> getTimeBasedGradient(DateTime time) {
    final hour = time.hour;

    if (hour >= 6 && hour < 12) {
      // Morning
      return [
        Color(0xFFFFE082),
        Color(0xFFFFCC02),
        Color(0xFFFFC107),
      ];
    } else if (hour >= 12 && hour < 18) {
      // Afternoon
      return sunnyGradient;
    } else if (hour >= 18 && hour < 20) {
      // Evening
      return [
        Color(0xFFFF7043),
        Color(0xFFFF5722),
        Color(0xFFE64A19),
      ];
    } else {
      // Night
      return nightGradient;
    }
  }
}
