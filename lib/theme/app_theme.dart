import 'package:flutter/material.dart';

class AppTheme {
  static const forest = Color(0xFF176A62);
  static const ocean = Color(0xFF122A43);
  static const mint = Color(0xFFEAF6F1);
  static const canvas = Color(0xFFF6F8FA);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      primary: forest,
      surface: Colors.white,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ocean,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
