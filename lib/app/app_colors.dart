import 'package:flutter/material.dart';

/// Netflix-inspired color palette for FlickRadar app
/// Pure black backgrounds with Netflix red accents for cinema aesthetic
class AppColors {
  // Background colors - Netflix pure black theme
  static const Color background = Color(0xFF000000);  // Pure black
  static const Color surface = Color(0xFF141414);     // Netflix secondary bg
  static const Color surfaceLight = Color(0xFF2F2F2F); // Lighter surface

  // Primary/Accent colors - Netflix red
  static const Color primary = Color(0xFFE50914);     // Netflix red
  static const Color primaryLight = Color(0xFFFF1E27); // Lighter red
  static const Color accent = Color(0xFFE50914);      // Netflix red

  // Semantic colors
  static const Color error = Color(0xFFE50914);       // Use Netflix red for errors
  static const Color errorLight = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF4CAF50);     // Keep green for "available"
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color info = Color(0xFF2196F3);

  // Text colors - High contrast for dark theme
  static const Color textPrimary = Color(0xFFFFFFFF);   // Pure white
  static const Color textSecondary = Color(0xFFB3B3B3); // Light gray
  static const Color textTertiary = Color(0xFF808080);  // Medium gray

  // Border colors
  static const Color border = Color(0xFF404040);        // Dark gray
  static const Color borderLight = Color(0xFF606060);   // Lighter border

  // Common UI colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
}
