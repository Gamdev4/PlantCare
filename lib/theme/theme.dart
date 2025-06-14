import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade100,
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 221, 221, 221),
    onPrimary: Colors.black,
    primaryContainer: const Color.fromARGB(255, 230, 229, 229),
    onPrimaryContainer: Colors.black54,
    secondary: const Color.fromARGB(255, 207, 207, 207),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade800,
    onPrimary: Colors.white,
    primaryContainer: Colors.grey.shade700,
    onPrimaryContainer: Colors.white70,
    secondary: Colors.grey.shade500,
  ),
);