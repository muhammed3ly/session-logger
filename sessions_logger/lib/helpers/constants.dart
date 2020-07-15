import 'package:flutter/material.dart';

class Constants {
  static const lightColorMap = const {
    50: Color.fromRGBO(30, 49, 157, 0.1),
    100: Color.fromRGBO(30, 49, 157, 0.2),
    200: Color.fromRGBO(30, 49, 157, 0.3),
    300: Color.fromRGBO(30, 49, 157, 0.4),
    400: Color.fromRGBO(30, 49, 157, 0.5),
    500: Color.fromRGBO(30, 49, 157, 0.6),
    600: Color.fromRGBO(30, 49, 157, 0.7),
    700: Color.fromRGBO(30, 49, 157, 0.8),
    800: Color.fromRGBO(30, 49, 157, 0.9),
    900: Color.fromRGBO(30, 49, 157, 1),
  };
  static final lightPrimaryColor = MaterialColor(0xFF1E319D, lightColorMap);

  static const darkColorMap = const {
    50: Color.fromRGBO(36, 42, 56, 0.1),
    100: Color.fromRGBO(36, 42, 56, 0.2),
    200: Color.fromRGBO(36, 42, 56, 0.3),
    300: Color.fromRGBO(36, 42, 56, 0.4),
    400: Color.fromRGBO(36, 42, 56, 0.5),
    500: Color.fromRGBO(36, 42, 56, 0.6),
    600: Color.fromRGBO(36, 42, 56, 0.7),
    700: Color.fromRGBO(36, 42, 56, 0.8),
    800: Color.fromRGBO(36, 42, 56, 0.9),
    900: Color.fromRGBO(36, 42, 56, 1),
  };
  static final darkPrimaryColor = MaterialColor(0xFF242A38, darkColorMap);

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: lightPrimaryColor,
    accentColor: lightPrimaryColor,
    fontFamily: 'Century',
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: darkPrimaryColor,
    primarySwatch: darkPrimaryColor,
    accentColor: Colors.white,
    fontFamily: 'Century',
  );
}
