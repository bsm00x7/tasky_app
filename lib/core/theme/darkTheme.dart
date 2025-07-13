import 'package:flutter/material.dart';

import '../colors/styles.dart';

ThemeData DarkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primaryContainer: Color(0xFF282828),
    secondary: Color(0xFFA0A0A0),
    primary: Color(0xFFFFFCFC),
      onPrimary: Color(0xFFA0A0A0)
  ),
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColor.bgColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColor.primryColor),
      foregroundColor: WidgetStateProperty.all(AppColor.textColor),
    ),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: AppColor.bgColor,
    iconTheme: IconThemeData(color: AppColor.textColor),
    titleTextStyle: TextStyle(
      color: AppColor.textColor,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColor.primryColor,
    foregroundColor: AppColor.textColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  ),

  switchTheme: SwitchThemeData(
    thumbColor:WidgetStateProperty.resolveWith((setets) {
      if (setets.contains(WidgetState.selected)) {
        return Color(0xffF6F7F9);
      }
      return Color(0xff9E9E9E) ;
    }),
    trackColor: WidgetStateProperty.resolveWith((setets) {
      if (setets.contains(WidgetState.selected)) {
        return AppColor.primryColor;
      }
      return AppColor.textColor;
    }),
    trackOutlineWidth: WidgetStateProperty.resolveWith((setets) {
      if (setets.contains(WidgetState.selected)) {
        return 0;
      }
      return 2;
    }),
  ),
  textTheme: TextTheme(
    titleSmall: TextStyle(
      color: Color(0xFFC6C6C6),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(color: Colors.white),
    titleLarge:TextStyle(color: Color(0xFFFFFCFC), fontSize: 20) ,
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),

    displayLarge: TextStyle(
      color: Color(0xFFFFFCFC),
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red, width: 0.5),
    ),
    filled: true,
    fillColor: Color(0xFF282828),
    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  splashFactory: NoSplash.splashFactory,
  popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Color(0xff6D6D6D)
  ),

);
