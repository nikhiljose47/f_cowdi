import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/home/home.dart';
import 'package:flutter_app/screen/inbox/inbox.dart';
import 'package:flutter_app/screen/notifications/notifications.dart';
import 'package:flutter_app/screen/explore/explore.dart';
import 'package:flutter_app/screen/others/other.dart';
import 'package:flutter_app/screen/profiledetails/profiledetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screen/search/search.dart';
import 'package:flutter_app/screen/manage/manage.dart';
import 'package:flutter_app/services/api.dart';

void main() async {
  runApp(MyHomePage(0));
}

class MyHomePage extends StatefulWidget {
  final int menulink; //if you have multiple values add here
  MyHomePage(this.menulink, {Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum LoginStatus { notSignIn, signIn }

class _MyHomePageState extends State<MyHomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);

      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  int menuvalue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuvalue = widget.menulink;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (menuvalue) {
      case 0:
        child = Home();
        break;
      case 1:
        child = Inboxpage();
        break;
      case 2:
        child = search();
        break;
      case 3:
        child = Notifications();
        break;
      case 4:
        child = Others();
        break;
    }

    return Container(
        color: Colors.red,
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade200,
          body: SizedBox.expand(child: child),
          bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  primaryColor: Colors.red,
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(caption: new TextStyle(color: Colors.black))),
              child: BottomNavigationBar(
                onTap: (newIndex) => setState(() => menuvalue = newIndex),
                currentIndex: menuvalue,
                type: BottomNavigationBarType.fixed,
                fixedColor: primarycolor,
                items: [
                  //N-Replaced by activeIcon
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/icons/home.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                        activeIcon: new Image.asset('assets/icons/home.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/icons/inbox.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                        activeIcon: new Image.asset('assets/icons/inbox.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/icons/search.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                    activeIcon: new Image.asset('assets/icons/search.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/icons/note.png',
                        width: 20, height: 20, fit: BoxFit.fill),
                    activeIcon: new Image.asset('assets/icons/note.png',
                        width: 20,
                        height: 20,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/icons/profile.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                    activeIcon: new Image.asset('assets/icons/profile.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                ],
              )),
        ));
  }
}
