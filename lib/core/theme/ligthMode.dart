import 'package:flutter/material.dart';

import '../colors/styles.dart';

ThemeData LightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primaryContainer: Color(0xffFFFFFF),
    secondary: Color(0xFF6A6A6A),
    primary: Color(0xFF161F1B),
    onPrimary: Color(0xffA0A0A0)

  ),
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF6F7F9),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColor.primryColor),
      foregroundColor: WidgetStateProperty.all(AppColor.textColor),
    ),
  ),
  appBarTheme: AppBarTheme(


    centerTitle: true,
    backgroundColor: Color(0xFFF6F7F9),
    iconTheme: IconThemeData(color: AppColor.textColor),
    titleTextStyle: TextStyle(
      color: Color(0xFF161F1B),
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
    trackOutlineColor: WidgetStateProperty.resolveWith((setets) {
      if (setets.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return Color(0xff9E9E9E);
    })
  ),
  textTheme: TextTheme(
      titleSmall: TextStyle(
        color: Color(0xFF3A4640),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    titleLarge:TextStyle(color: Color(0xFF161F1B), fontSize: 20) ,
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Color(0xFF161F1B),
    ),
    displayMedium: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    titleMedium:TextStyle(
       color:  Color(0xFF6A6A6A),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ) ,
    labelMedium: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
      displayLarge: TextStyle(
      color: Color(0xFF161F1B),
        fontSize: 32,
  fontWeight: FontWeight.w400,
),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFFFFFFF),
    focusColor:  Color(0xFFD1DAD6),
    enabledBorder: OutlineInputBorder(

      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(

          color: Color(0xFFD1DAD6)
      ),

    ) ,
    hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
    border: OutlineInputBorder(

      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(

          color: Color(0xFFD1DAD6)
      ),

    ),
  ),
  splashFactory: NoSplash.splashFactory,
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(0xffF6F7F9)
  ),


);
