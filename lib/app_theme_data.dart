import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.highContrastLight().copyWith(
      primary: const Color.fromARGB(255, 253, 1, 93),
      onPrimary: const Color.fromARGB(255, 0, 0, 0),
      secondary: const Color.fromARGB(255, 113, 0, 42),
      onSecondary: Colors.white,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.koHoTextTheme(),
  );
}
