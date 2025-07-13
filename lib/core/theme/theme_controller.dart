import 'package:flutter/material.dart';
import '../../service/preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.dark);

  // Initialize theme from stored preference
  Future<void> init() async {
    bool value = await PreferenceManager().getBool("Mode") ?? true;
    theme.value = value ? ThemeMode.dark : ThemeMode.light;
  }
  // Toggle between light and dark theme
  static toggleTheme() async {
    theme.value = theme.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await PreferenceManager().setBool("Mode", theme.value == ThemeMode.dark);
  }
  ThemeMode getterThemeMode(){
    return theme.value;
  }
}