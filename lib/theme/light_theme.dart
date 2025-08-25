import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFFFE3D2D),
  secondaryHeaderColor: const Color(0xFF1ED7AA),
  disabledColor: const Color(0xFFDBDEE4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF999999),
  cardColor: Colors.white,
  shadowColor: Colors.black.withValues(alpha: 0.03),
  scaffoldBackgroundColor: const Color(0xFFFCFCFC),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF6B00))), colorScheme: const ColorScheme.light(primary: Color(0xFFFF6B00), secondary: Color(0xFFFF6B00)).copyWith(error: const Color(0xFFE84D4F)),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
  floatingActionButtonTheme: FloatingActionButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
  bottomAppBarTheme: const BottomAppBarTheme(
    surfaceTintColor: Colors.white, height: 60,
    padding: EdgeInsets.symmetric(vertical: 5),
  ),
  dividerTheme: const DividerThemeData(thickness: 0.2, color: Color(0xFFA0A4A8)),
);