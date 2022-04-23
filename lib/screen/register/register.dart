import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
enum regStatus { register, login }
class _RegisterState extends State<Register> {
  regStatus _regStatus = regStatus.register;
  String name, username, email, password, confirm_password;
  final _key = new GlobalKey<FormState>();
  FocusNode nameFocusNode = new FocusNode();
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confirmpasswordFocusNode = new FocusNode();
  bool _secureText = true;
  bool _secureText2 = true;
  var loading = false;

  showHide() {
    setState(() {
      _secureText = !_secureText;
     // _secureText2 = !_secureText2;
    });
  }
  showHidepass() {
    setState(() {
      _secureText2 = !_secureText2;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      form.save();
      if(password != confirm_password) {
        registerToast("Incorrect Password");
      } else if(!regex.hasMatch(email)) {
        registerToast("Incorrect Email");
      }else{
        print(name);
        print(username);
        print(email);
        print(password);
        print(confirm_password);
        setState(() {
          loading = true;
        });
        save();
      }

    }
  }

  save() async {
    final response = await http
        .post(baseurl + version + register, body: {
      "fullname": name,
      "username": username,
      "email": email,
      "password": password,
      "confirm_password": confirm_password,
    });

    final data = response.body;
    var value = jsonDecode(data)['status'];
    var error = jsonDecode(data)['errArr'];
    var message = jsonDecode(data)['message'];
    var responseCode = jsonDecode(data)['response_code'];
    print(value);
    if(value == '1'){
      registerToast("user has been register successfully");
      setState(() {
        _regStatus = regStatus.login;

      });
    }else{
      if(responseCode == '202') {
        if(error.length == 1){

          var errormsg = jsonDecode(data)['errArr'][0]['error_msg'];
          registerToast(errormsg);
        }else{
          setState(() {
            loading = false;
          });
          registerToast('User name & Email already exist' );
        }
      }
      }
    }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: secondercolor,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    switch (_regStatus) {
      case regStatus.register:
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
                      height: 200,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [wavefirst, wavefirst])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper3(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 200,
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
                            height: 50,
                          ),
                          Text(
                            "GigToDo",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 30),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 200,
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
              loading
                  ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                  : Form(
    key: _key,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 0.0,
                  child: TextFormField(
                    focusNode: nameFocusNode,
                    validator: (e) {
                      if (e.isEmpty) {
                        Text txt = Text("Please Enter Full Name",  textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr);
                          var fullname = txt.data;
                        return fullname;
                      }
                    },
                    onSaved: (e) => name = e,
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
                          padding: EdgeInsets.only(
                              left: 20, right: 15),
                          child: Icon(
                              Icons.person, color: primarycolor),
                        ),
                        //contentPadding: EdgeInsets.all(15),
                        labelText: "Fullname",
                        labelStyle: TextStyle(
                            color: primarycolor
                        )
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
                  child:TextFormField(
                    inputFormatters: [
                //      WhitelistingTextInputFormatter(RegExp("^[a-zA-Z0-9_]+|\s")),
                    ],
                    focusNode: usernameFocusNode,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please Enter User Name";
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
                          padding: EdgeInsets.only(
                              left: 20, right: 15),
                          child: Icon(
                              Icons.person, color: primarycolor),
                        ),
                        //contentPadding: EdgeInsets.all(15),
                        labelText: "Username",
                        labelStyle: TextStyle(
                            color: primarycolor
                        )),
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

                  child:TextFormField(
                    focusNode: emailFocusNode,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please Enter Email";
                      }
                    },
                    onSaved: (e) => email = e,
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
                          padding: EdgeInsets.only(
                              left: 20, right: 15),
                          child: Icon(
                              Icons.email, color: primarycolor),
                        ),
                        // contentPadding: EdgeInsets.all(18),
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color:  primarycolor
                        )),
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

                  child:TextFormField(
                    focusNode: passwordFocusNode,
                    obscureText: _secureText,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please Enter Password";
                      }
                    },
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
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: primarycolor),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 15),
                          child: Icon(Icons.phonelink_lock,
                              color: primarycolor),
                        ),
                        // contentPadding: EdgeInsets.all(18),
                        labelText: "Password",
                        labelStyle: TextStyle(
                            color:  primarycolor
                        )),
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

                  child:TextFormField(
                    focusNode: confirmpasswordFocusNode,
                    obscureText: _secureText2,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please Enter Password";
                      }
                    },
                    onSaved: (e) => confirm_password = e,
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
                        suffixIcon: IconButton(
                          onPressed: showHidepass,
                          icon: Icon(_secureText2
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: primarycolor),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 15),
                          child: Icon(Icons.phonelink_lock,
                              color: primarycolor),
                        ),
                        // contentPadding: EdgeInsets.all(18),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                            color:  primarycolor
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: primarycolor),
                      child: SizedBox(
                        width: double.infinity,
                        child:FlatButton(

                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          onPressed: () {check();},
                        ),
                      ))),
              SizedBox(height: 20,),

              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already Have Account ?  ", style: TextStyle(color:Colors.black,fontSize: 12 ,fontWeight: FontWeight.normal),),
                  InkWell( child:Text("Login", style: TextStyle(color:primarycolor, fontWeight: FontWeight.w500,fontSize: 12 )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login("loginfull")),
                      );
                     },
                  ),

                ],
              ),
      SizedBox(height: 20,),
            ],
          )
    ),
    ],
    ),
    );
        break;

      case regStatus.login:
        return Login("loginfull");
//        return ProfilePage(signOut);
        break;
    }
  }
}

