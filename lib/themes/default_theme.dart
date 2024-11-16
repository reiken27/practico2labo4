import 'package:flutter/material.dart';

class DefaultTheme {
  static const Color primaryDark = Colors.red;
  static const Color secondary = Colors.grey;
  static const Color formElementsColor = Colors.purple;
  static final Color primaryHover = Colors.red.shade600;

  static final ThemeData lightTheme = ThemeData.light().copyWith();

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red, foregroundColor: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: primaryDark, foregroundColor: Colors.white)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: secondary, foregroundColor: Colors.white)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(iconColor: primaryDark),
      /* switchTheme: SwitchThemeData(), */
      inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: formElementsColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )));
}
