import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1B6CA8);
  static const Color secondary = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color danger = Color(0xFFE74C3C);
  static const Color surface = Color(0xFFF8F9FA);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(backgroundColor: primary, foregroundColor: Colors.white, elevation: 0, centerTitle: true),
    cardTheme: CardThemeData(
      color: Colors.white, elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    chipTheme: ChipThemeData(
      selectedColor: primary, labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primary, unselectedItemColor: Colors.grey, backgroundColor: Colors.white, elevation: 8,
    ),
  );

  static Color priceColor(int rank, int total) {
    if (total <= 1) return secondary;
    final ratio = rank / (total - 1);
    if (ratio < 0.33) return secondary;
    if (ratio < 0.66) return warning;
    return danger;
  }
}
