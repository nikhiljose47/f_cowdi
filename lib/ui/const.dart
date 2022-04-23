import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';

class Constants{
  static String appName = "gtg";

  //Colors for theme
  static Color lightPrimary = Color(0xFFf8fbfc); //topbarcolor
  static Color lightAccent = Color(0xFFf8fbfc);// icon and shadow for trage
  static Color lightBG = Color(0xFFf8fbfc);// app bg color
  static Color darkBG = primarycolor;
  static Color badgeColor = Colors.red;
  static Color botternav = Color(0xFFf8fbfc);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor:  lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    bottomAppBarColor: botternav,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        subtitle1: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
   iconTheme: IconThemeData(
        color: lightAccent,
     ),
    ),
  );


}