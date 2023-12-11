import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(15, 15, 15, 0.6),
        background: const Color.fromRGBO(15, 15, 15, 0.6),
        primary: Color.fromRGBO(22, 22, 22, 1),
        secondary: Color.fromRGBO(97, 63, 216, 1),
      ),
      cardTheme: CardTheme().copyWith(
        clipBehavior: Clip.hardEdge,
        elevation: 8.0,
        shadowColor: Colors.blueGrey,
      ),
      textTheme: TextTheme().copyWith(
        titleLarge: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: GoogleFonts.roboto(
          color: Colors.white70,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
