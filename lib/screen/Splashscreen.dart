import 'dart:async';
import 'package:flutter/material.dart';
import  'package:flutter_app/screen/mainscreen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {  

  late AnimationController animationController;
  late Animation<double> animation;

  void navigationPage() async {
     Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage(0)));

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // bool _seen = (preferences.getBool('seen') ?? false);
    // if(_seen == true) {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (BuildContext context) => MyHomePage(0)));
    // }else{
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (BuildContext context) => MyHomePage(0)));
    // }
  }

  void setTimer() async {
    Timer(Duration(milliseconds: 1900), navigationPage);

  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1800));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/logo/cowdiar_logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}