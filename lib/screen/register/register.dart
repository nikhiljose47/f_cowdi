import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/util/appinfo.dart';

import '../../util/const.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

enum regStatus { register, login }

class _RegisterState extends State<Register> {
  regStatus _regStatus = regStatus.register;
  String name, username, email, phoneNumber, password, confirm_password;
  FocusNode nameFocusNode = new FocusNode();
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode phoneNumberFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confirmpasswordFocusNode = new FocusNode();
  bool _secureText = true;
  bool _secureText2 = true;
  var loading = false;
  bool checkBoxVal = false;
  String dropdownValue = '+91';
  //keys
    final _key = new GlobalKey<FormState>();
     final _fnameKey = new GlobalKey<FormState>();


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
      if (password != confirm_password) {
        registerToast("Passwords not match");
      } else if (!regex.hasMatch(email)) {
        registerToast("Incorrect Email");
      } else {
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
    final response = await http.post(baseurl + version + register, body: {
      "fullname": name,
      "username": username,
      "phone_number": phoneNumber.isEmpty?'':dropdownValue+phoneNumber,
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
    if (value == '1') {
      registerToast("user has been registered successfully");
      setState(() {
        _regStatus = regStatus.login;
      });
    } else {
      if (responseCode == '202') {
        if (error.length == 1) {
          var errormsg = jsonDecode(data)['errArr'][0]['error_msg'];
          registerToast(errormsg);
        } else {
          setState(() {
            loading = false;
          });
          registerToast('User name & Email already exist');
        }
      }
    }
  }

  registerToast(String toast) {
    return FlutterToast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: secondercolor,
        textColor: Colors.white);
  }

  callBackFn(String data) {
    setState(() {
      this.dropdownValue = data;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: ListView.builder(
      itemCount: Constants.dropDownItems.length,
      itemBuilder: (BuildContext context, int index) {
        return CountryCodeItem(index, Constants.dropDownItems[index], callBackFn);
      },
    ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.center,
          heightFactor: 0.75,
          child: alert,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_regStatus) {
      case regStatus.register:
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Join",
                  style: TextStyle(
                      color: primarycolor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.bottomLeft,
                  child: ClipRect(
                      // clipper: MyClip(),
                      child: Align(
                          alignment: Alignment.center,
                          widthFactor: 0.8,
                          child: Image.asset('assets/logo/cowdiar_logo.png'))),
                ),
              ],
            ),
            foregroundColor: Colors.black,
            backgroundColor: Color.fromARGB(255, 250, 250, 250),
          ),
          backgroundColor: Colors.white,
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 20,
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
                        "Sign up with Apple",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
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
                        "Sign up with Facebook",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
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
              loading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(primarycolor)))
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
                                key: _fnameKey,
                                focusNode: nameFocusNode,
                                validator: (e) => e.isEmpty?"Please enter Full Name":null                                                             ,
                                onSaved: (e) => name = e,
                               // onChanged: (e) => _fnameKey.currentState.validate(),
                                style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.person,
                                          color: primarycolor),
                                    ),
                                    //contentPadding: EdgeInsets.all(15),
                                    labelText: "Fullname",
                                    labelStyle: TextStyle(color: primarycolor)),
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
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.person,
                                          color: primarycolor),
                                    ),
                                    //contentPadding: EdgeInsets.all(15),
                                    labelText: "Username",
                                    labelStyle: TextStyle(color: primarycolor)),
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
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.email,
                                          color: primarycolor),
                                    ),
                                    // contentPadding: EdgeInsets.all(18),
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: primarycolor)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0.0),
                                        //  contentPadding: EdgeInsets.symmetric(
                                        //     vertical: 10.0),

                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: primarycolor,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () => showAlertDialog(context),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Text(dropdownValue,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: primarycolor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: IconButton(
                                                      onPressed: null,
                                                      icon: new Icon(
                                                        Icons.arrow_downward,
                                                        size: 16,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                )
                                              ]),
                                        ))),
                                SizedBox(width: 1),
                                Expanded(
                                  flex: 6,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    focusNode: phoneNumberFocusNode,
                                    validator: (e) => !e.isEmpty
                                        ? null
                                        : null,
                                    onSaved: (e) => phoneNumber = e,
                                    style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primarycolor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primarycolor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primarycolor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 15),
                                          child: Icon(Icons.phone,
                                              color: primarycolor),
                                        ),
                                        // contentPadding: EdgeInsets.all(18),
                                        labelText: "(optional) Phone number ",
                                        labelStyle:
                                            TextStyle(color: primarycolor)),
                                  ),
                                )
                              ],
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
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(
                                          _secureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: primarycolor),
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.phonelink_lock,
                                          color: primarycolor),
                                    ),
                                    // contentPadding: EdgeInsets.all(18),
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: primarycolor)),
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
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: showHidepass,
                                      icon: Icon(
                                          _secureText2
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: primarycolor),
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.phonelink_lock,
                                          color: primarycolor),
                                    ),
                                    // contentPadding: EdgeInsets.all(18),
                                    labelText: "Confirm Password",
                                    labelStyle: TextStyle(color: primarycolor)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: checkBoxVal,
                                  onChanged: (val) =>
                                      setState(() => checkBoxVal = val)),
                              Text("I accept terms and conditions"),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: checkBoxVal?primarycolor:Colors.grey),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FlatButton(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        if(checkBoxVal)
                                        check();
                                      },
                                    ),
                                  ))),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already Have Account ?  ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                              TextButton(
                                child: Text("Login",
                                    style: TextStyle(
                                        color: primarycolor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Login("loginfull")),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
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

class CountryCodeItem extends StatefulWidget {
  final int index;
  final String name;
  final Function callback;
  const CountryCodeItem(this.index, this.name, this.callback);

  @override
  CountryCodeItemState createState() => CountryCodeItemState();
}

class CountryCodeItemState extends State<CountryCodeItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(widget.name,
                maxLines: 2,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          ),
        ),
        Expanded(
            child: InkWell(
          onTap: () {
            var items = widget.name.split(' ');
            var item = items[items.length - 1];
            widget.callback(item.substring(1, item.length - 1));
            // dropdownValue =
            //     dropdownValue.substring(1, dropdownValue.length - 1);
            setState(() {
              isSelected = true;
            });
            Future.delayed(const Duration(milliseconds: 500),()=> Navigator.pop(context))
            ;
          },
          child: Container(
            decoration: BoxDecoration(
                color: isSelected ? primarycolor : null,
                border: Border.all(color: Colors.black),
                shape: BoxShape.circle),
            // padding: EdgeInsets.all(8),
            width: 18,
            height: 18,
          ),
        )),
      ],
    );
  }
}
