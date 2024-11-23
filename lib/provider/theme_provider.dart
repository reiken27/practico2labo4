import 'package:flutter/material.dart';
import 'package:practico2labo4/helpers/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = Preferences.darkmode;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    Preferences.darkmode = isDarkMode; // Actualiza SharedPreferences
    notifyListeners(); // Notifica a los widgets para reconstrucción
  }
}
