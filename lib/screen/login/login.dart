import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/inbox/Inbox.dart';
import 'package:flutter_app/screen/notifications/Notifications.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/register/register.dart';
import 'package:flutter_app/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screen/forgetpassword/forget.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fb;

class Login extends StatefulWidget {
  final String logintxt;

  Login(this.logintxt, {Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _key = new GlobalKey<FormState>();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? username, email, userId, password;
  FocusNode passwordFocusNode = new FocusNode();
  bool _secureText = true;
  FocusNode emailFocusNode = new FocusNode();
  var firebastoken;
  TextEditingController? _controller;
  TextEditingController? _controller2;
  List<AppInfo> apiinforlist = [];

  var loading = false;
  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      firebastoken = token;
    });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    setState(() {
      loading = true;
    });
    print("firebasetoken");
    print(firebastoken);
    if (Platform.isIOS) {
      final response =
          await http.post(Uri.parse(baseurl + version + loginurl), body: {
          "username": userId,
          "password": password,
          "device_type": 'ios',
          "device_token": firebastoken,
        });

      final data = jsonDecode(response.body);
      String? value = data['status'];
      String? token = data['commonArr']['token'];
      String? message = data['message'];
     _setStateOnResponse(value, data);
    } else {
      final response =
          await http.post(Uri.parse(baseurl + version + loginurl), body: {
          "username": userId,
          "password": password,
          "device_type": 'android',
          "device_token": firebastoken,
        });

      final data = jsonDecode(response.body);
      String? value = data['status'];

      String? message = data['message'];
  _setStateOnResponse(value, data);
      showAlertDialog(context, value);
    }
  }

  _setStateOnResponse(value, data) {
    if (value == '1') {
      String token = data['commonArr']['token'];
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(token);
      });
    } else {
      _controller = new TextEditingController(text: userId);
      _controller2 = new TextEditingController(text: password);
      setState(() {
        loading = false;
      });
    }
  }
    _facebookLogin() async {
    final result = await fb.FacebookAuth.i.login(permissions: ['email']);

    if (result.status == fb.LoginStatus.success) {
      final userData = await fb.FacebookAuth.instance.getUserData(
        fields: "email,name",
      );
      userId = userData["email"];
       setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(result.accessToken?.token);
        loading = false;
      });
      showAlertDialog(context, '1');
    } else if (result.status == fb.LoginStatus.failed) {
      showAlertDialog(context, "fb_login_fail");
    }
  }

  showAlertDialog(BuildContext context, String? value) {
    String title;
    String content;
    List<Widget> actions;

    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    if (value == '1') {
      title = "Success!";
      content = "Welcome Back";
      actions = [];
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(0)));
      });
    } 
    else if (value == '0') {
      title = "Oops!";
      content = "Password or username is incorrect. Please try again!";
      actions = [okButton];
    } else {
      title = "Oops!";
      content = "Facebook login failed";
      actions = [okButton];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        title: Text(title), content: Text(content), actions: actions);
      },
    );
  }

  savePref(String? token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", token!);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  Future<Null> getData() async {
    final responseDataappinfo = await http.post(Uri.parse(baseurl + version + sitedetails),
        body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      final datalist = jsonDecode(dataapinfo)['content']['app_info'];
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    firebaseCloudMessaging_Listeners();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ClipRect(
                    child: Align(
                        alignment: Alignment.center,
                        heightFactor: 0.5,
                        child: Transform.scale(
                            scale: 0.8,
                            child:
                                Image.asset('assets/logo/cowdiar_logo.png')))),
                Text(
                  "Welcome back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 45,
                    width: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 6, 6, 6),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apple_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Login with Apple",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                             InkWell(
                  onTap: (() => _facebookLogin()),
                  child:
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 45,
                    width: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    decoration: BoxDecoration(
                        color: Color(0xff5890FF),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.facebook_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Login with Facebook",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "- OR -",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 0.0,
                          child: TextFormField(
                            controller: _controller,
                            validator: (e) => e!.isEmpty
                                ? "Please enter user name/email"
                                : null,
                            onSaved: (e) => userId = e,
                            style: TextStyle(
                              color: primarycolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),

                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: primarycolor),
                              ),
                              // contentPadding: EdgeInsets.all(18),
                              labelText: "username/email",
                              labelStyle: TextStyle(
                                  color: emailFocusNode.hasFocus
                                      ? Colors.black
                                      : primarycolor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 0.0,
                          child: TextFormField(
                            controller: _controller2,
                            validator: (e) =>
                                e!.isEmpty ? "Please enter the password" : null,
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            style: TextStyle(
                              color: primarycolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),

                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "password",
                              labelStyle: TextStyle(
                                  color: passwordFocusNode.hasFocus
                                      ? Colors.black
                                      : primarycolor),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: primarycolor),
                              ),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(
                                    _secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primarycolor),
                              ),

                              // contentPadding: EdgeInsets.all(18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      loading
                          ? Center(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      primarycolor)))
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: primarycolor),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FlatButton(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      onPressed: () {
                                        check();
                                      },
                                    ),
                                  ))),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  "FORGOT PASSWORD ?",
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => forgetpass()),
                                  );
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Skip >>",
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(0)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an Account ? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                          TextButton(
                            child: Text("Sign Up ",
                                style: TextStyle(
                                    color: primarycolor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15)),
                            onPressed: () {
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ));
        break;
      case LoginStatus.signIn:
        print(widget.logintxt);
        if (widget.logintxt == "loginfull") {
          return MyHomePage(0);
        } else if (widget.logintxt == "inbox") {
          return Inboxpage();
        } else if (widget.logintxt == "nottification") {
          return Notifications();
        }
//        return ProfilePage(signOut);
        break;
    }
    return Container();
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
