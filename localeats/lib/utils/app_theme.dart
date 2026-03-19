import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E8B57), primary: const Color(0xFF2E8B57), secondary: const Color(0xFFFF7F50)),
    textTheme: GoogleFonts.poppinsTextTheme(),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E8B57), brightness: Brightness.dark, primary: const Color(0xFF4CAF82), secondary: const Color(0xFFFF9B6B)),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
