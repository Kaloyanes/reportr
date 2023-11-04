import 'package:flutter/material.dart';

class Themes {
  static ThemeData light = generateTheme(
    ColorScheme(
      background: Colors.white, // Light background for a light theme
      primary: Colors.blue, // Primary color can stay the same if it contrasts well
      onPrimary: Colors.white, // Text on primary might need to be darker for readability
      secondary: Colors.grey.shade300, // A lighter shade for secondary background
      onSecondary: Colors.black, // Text on secondary needs to be dark for readability
      error: Colors.red, // Error color is usually vivid, so it can stay the same
      onError: Colors.black, // Text on error should be readable, so choose a contrasting color
      onBackground: Colors.black, // Text on background should be dark for a light theme
      brightness: Brightness.light, // Overall brightness is light for a light theme
      surface: Colors.white, // Surface is usually the same as background for a light theme
      onSurface: Colors.black, // Text on surface should be dark for readability
    ),
  );

  static ThemeData dark = generateTheme(ColorScheme(
    background: const Color.fromARGB(255, 12, 12, 12),
    surface: const Color.fromARGB(255, 12, 12, 12),
    primary: Colors.deepPurple.shade400,
    onPrimary: Colors.white,
    secondary: const Color.fromARGB(255, 50, 50, 50),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onBackground: Colors.white,
    brightness: Brightness.dark,
    onSurface: Colors.white,
  ));

  static ThemeData generateTheme(ColorScheme color) {
    return ThemeData(
      splashFactory: InkSparkle.splashFactory,
      useMaterial3: true,
      colorScheme: color,
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: color.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(shape: RoundedRectangleBorder()),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
