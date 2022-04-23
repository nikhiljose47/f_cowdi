import 'package:flutter/material.dart';
import 'package:flutter_app/util/const.dart';
import 'package:flutter_app/screen/Splashscreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Git To Do',
      theme:  Constants.lightTheme,
      home: new AnimatedSplashScreen(),
      // home: DetailPage(),
    );
  }
}