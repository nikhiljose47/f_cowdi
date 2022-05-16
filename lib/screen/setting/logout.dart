import 'package:flutter/material.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/services/api.dart';

class logout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => logoutState();
}

class logoutState extends State<logout>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 250.0,
              decoration: ShapeDecoration(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),)),
              child: Column(
                children: <Widget>[
                  Icon(Icons.exit_to_app,size: 60.0,color: primarycolor,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, right: 20.0),
                        child: Text(
                          "Are you want to logout?",
                          style: TextStyle(color: Colors.white38, fontSize: 16.0),
                        ),
                      )],),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:const EdgeInsets.only(left:20.0,right:10.0,top:20.0,bottom:10.0),
                        child: ButtonTheme(
                          height: 35.0,
                          minWidth: 110.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: primarycolor[200],
                            onPressed: (){  Navigator.pop(context);},
                            child: Text(
                              'No',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                          ),),),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right:15.0, top: 20.0, bottom: 10.0),
                        child:  ButtonTheme(
                          height: 35.0,
                          minWidth: 110.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: primarycolor,
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove("token");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>MyHomePage(0)),
                              );

                            },
                            child: Text(
                              'Yes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),    ),
                        ),),
                    ],

                  )


                ], ),
            ),
          ),
        ),
      ),
    );
  }
}
