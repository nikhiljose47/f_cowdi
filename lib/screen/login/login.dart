import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/inbox/Inbox.dart';
import 'package:flutter_app/screen/notifications/Notifications.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/register/register.dart';
import 'package:flutter_app/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screen/forgetpassword/forget.dart';
class Login extends StatefulWidget {
  final String logintxt;

  Login(this.logintxt, {Key key}): super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }



class _LoginState extends State<Login> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _key = new GlobalKey<FormState>();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  FocusNode passwordFocusNode = new FocusNode();
  bool _secureText = true;
  FocusNode emailFocusNode = new FocusNode();
  var firebastoken;
  TextEditingController _controller;
  TextEditingController _controller2;
  List<AppInfo> apiinforlist = [];

  var loading = false;
  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token){
      firebastoken = token;
    });
  }
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }

  }
  login() async {
    setState(() {
      loading = true;
    });
    print("firebastoken");
    print(firebastoken);
    if (Platform.isIOS) {
      final response = await http
          .post(baseurl + version + loginurl, body: {
        "username": username,
        "password": password,
        "device_type":'ios',
        "device_token": firebastoken,
      }
      );

      final data = jsonDecode(response.body);
      String value = data['status'];
      String token = data['commonArr']['token'];
      String message = data['message'];
      if (value == '1') {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(token);
        });
        loginToast(message);
      } else {
        _controller = new TextEditingController(text: username);
        _controller2 = new TextEditingController(text: username);

        setState(() {
          loading = false;
        });

        loginToast('invalid login credentials');
      }
    }else{
      final response = await http
          .post(baseurl + version + loginurl, body: {
        "username": username,
        "password": password,
        "device_type":'android',
        "device_token": firebastoken,
      }
      );

      final data = jsonDecode(response.body);
      String value = data['status'];

      String message = data['message'];
      if (value == '1') {
        String token = data['commonArr']['token'];
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(token);
        });
        loginToast(message);
      } else {
        _controller = new TextEditingController(text: username);
        _controller2 = new TextEditingController(text: username);
        setState(() {
          loading = false;
        });
        loginToast('invalid login credentials');
      }
    }
  }
  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: secondercolor,
        textColor: Colors.white);
  }

  savePref(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", token);
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
      final responseDataappinfo = await http.post( baseurl + version + sitedetails,body: {'mobile_type':Platform.isAndroid?'android':'ios'});
      if (responseDataappinfo.statusCode == 200) {
        final dataapinfo = responseDataappinfo.body;
        var datalist = jsonDecode(dataapinfo)['content']['app_info']  as List;
        setState(() {
          for (Map i in datalist) {
            apiinforlist.add(AppInfo.fromMap(i));
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
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipper2(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [wavefirst,wavefirst])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper3(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [wavesecond, wavesecond])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper1(),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          apiinforlist.length != 0 ? Image.network(apiinforlist[0].appLogo,color: Colors.white,):Text(
                            "GigToDo",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 30),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [primarycolor, primarycolor])),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
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
                    validator: (e) {
                      if (e.isEmpty) {

                        return "Please Enter The username";
                      }
                    },
                    onSaved: (e) => username = e,
                    style: TextStyle(
                      color: primarycolor,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primarycolor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primarycolor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primarycolor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),

                        prefixIcon: Padding(
                          padding:
                          EdgeInsets.only(left: 20, right: 15),
                          child:
                          Icon(Icons.person, color: primarycolor),
                        ),
                        // contentPadding: EdgeInsets.all(18),
                        labelText: "username" ,
                        labelStyle: TextStyle(
                            color: emailFocusNode.hasFocus ? Colors
                                .black : primarycolor
                        ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 0.0,

                  child: TextFormField(
                    controller: _controller2,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please Enter The Password";
                      }
                    },
                    obscureText: _secureText,
                    onSaved: (e) => password = e,
                    style: TextStyle(
                      color: primarycolor,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
    borderSide: BorderSide(color: primarycolor),
    borderRadius: BorderRadius.circular(30.0),
    ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primarycolor),
                        borderRadius: BorderRadius.circular(30.0),

                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primarycolor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                          color: passwordFocusNode.hasFocus ? Colors
                              .black : primarycolor
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                        child: Icon(Icons.phonelink_lock,
                            color: primarycolor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_secureText
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
                height: 25,
              ),
              loading
                  ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                  : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: primarycolor),
                    child: SizedBox(
                      width: double.infinity,
                      child:FlatButton(

                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      onPressed: () {check();},
                    ),
                  ))),
              SizedBox(height: 20,),
              Center(
                child: SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
    InkWell (      child:  Text("FORGOT PASSWORD ?", style: TextStyle(color:primarycolor,fontSize: 12 ,fontWeight: FontWeight.w700 ),),
      onTap: () { Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => forgetpass()),
      ); },
    ),
                      InkWell (      child: Text("Skip >>", style: TextStyle(color:primarycolor,fontSize: 12 ,fontWeight: FontWeight.w700),),
                        onTap: () { Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(0)),
                        ); },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an Account ? ", style: TextStyle(color:Colors.black,fontSize: 12 ,fontWeight: FontWeight.normal),),
    InkWell( child:Text("Sign Up ", style: TextStyle(color:primarycolor, fontWeight: FontWeight.w500,fontSize: 12 )),
        onTap: () {{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register()),
          );
        }; },
    ),

                ],
              )
            ],
          ),
        )],
    )
    );
        break;
      case LoginStatus.signIn:
        print(widget.logintxt);
        if(widget.logintxt == "loginfull") {
          return MyHomePage(0);
        }else if(widget.logintxt == "inbox") {
          return Inboxpage();
        }else if(widget.logintxt == "nottification") {
          return Notifications();
        }
//        return ProfilePage(signOut);
        break;
    }
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