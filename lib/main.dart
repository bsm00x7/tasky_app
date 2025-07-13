import 'package:flutter/material.dart';
import 'package:tasky/core/theme/ligthMode.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/service/preferences.dart';
import 'Page/switch_screens.dart';
import 'Page/welcom_page.dart';
import 'core/theme/darkTheme.dart';

// value Notifier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager().init();
  ThemeController().init();
  runApp(MyApp(username: PreferenceManager().getString("username")  ,));
}
class MyApp extends StatelessWidget {
  final String? username;
  const MyApp({super.key, this.username
  });
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.theme,
      builder: (BuildContext context, ThemeMode value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:  LightMode,
          darkTheme: DarkMode,
          themeMode:ThemeController.theme.value,
          home: username == null ? WelcomHome() : SiwtchScreen(),
        );
      },
    );
  }
}
