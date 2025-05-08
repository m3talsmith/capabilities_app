import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.highContrastLight().copyWith(
      primary: const Color.fromARGB(255, 253, 1, 93),
      onPrimary: const Color.fromARGB(255, 255, 255, 255),
      secondary: const Color.fromARGB(255, 113, 0, 42),
      onSecondary: Colors.white,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.koHoTextTheme().copyWith(
      labelLarge: GoogleFonts.koHoTextTheme().labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      labelMedium: GoogleFonts.koHoTextTheme().labelMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      labelSmall: GoogleFonts.koHoTextTheme().labelSmall?.copyWith(
        fontSize: 12,
      ),
    ),
  );
}
