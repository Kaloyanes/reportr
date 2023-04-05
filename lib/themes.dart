import 'package:flutter/material.dart';

class Themes {
  static ThemeData generateTheme(bool darkMode) {
    return ThemeData(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );
  }
}
