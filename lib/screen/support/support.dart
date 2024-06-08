import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/util/support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
class support extends StatefulWidget{
  final int index;
  support(this.index);
  _supportState createState()=>_supportState();
}
class _supportState extends State<support>{
  final _key = new GlobalKey<FormState>();
  FocusNode subjectFocusNode = new FocusNode();
  FocusNode messageFocusNode = new FocusNode();
  FocusNode ordernumberFocusNode = new FocusNode();
  FocusNode rollFocusNode = new FocusNode();
  String? subject;
  String? Message;
  String? ordernumber;
  String? roll;
  List<TypesArr> listService = [];
  var loading = false;
  String? _mySelection;
  String token = "";
  String _path = '...';
  String _fileName = '...';
  FileType? _pickingType;
  String? _extension;
  final subjectHolder = TextEditingController();
  final MessageHolder = TextEditingController();
  final ordernumberHolder = TextEditingController();
  final rollHolder = TextEditingController();

  void _openFileExplorer() async {
    try {
      _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
    });

  }
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }
   save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
   final response = await http
          .post(baseurl +version+ sendfeedback, body: {
        "enquiry_type": _mySelection,
        "subject": subject,
        "message": Message,
        "order_number": ordernumber,
        "user_role": roll,
        "file": ""
      } , headers: {
     'Auth': token
   }
      );
      final data = jsonDecode(response.body);
      String value = data['status'];
      String message = data['message'];
      if (value == "1") {
        registerToast(
            " Thanks for Registering.  After successful verification, you could log in to our Application.");
        subjectHolder.clear();
        MessageHolder.clear();
        rollHolder.clear();
        ordernumberHolder.clear();
      } else {
        registerToast(message);
      }
  }
  check1() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save1();
    }
  }
  save1() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    final response = await http
        .post(baseurl +version+ sendfeedback, body: {
      "enquiry_type": _mySelection,
      "subject": subject,
      "message": Message,
      "file": ""
    } , headers: {
      'Auth': token
    }
    );
    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == "1") {
      registerToast(
          " Thanks for Registering.  After successful verification, you could log in to our Application.");
      subjectHolder.clear();
      MessageHolder.clear();

    } else {
      registerToast(message);
    }
  }
  check2() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save2();
    }
  }
  save2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    final response = await http
        .post(baseurl +version+ sendfeedback, body: {
      "enquiry_type": _mySelection,
      "subject": subject,
      "message": Message,
      "file": ""
    } , headers: {
      'Auth': token
    }
    );
    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == "1") {

      registerToast(" Thanks for Registering.  After successful verification, you could log in to our Application.");
      subjectHolder.clear();
      MessageHolder.clear();

    } else {
      registerToast(message);
    }
  }
  check3() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save3();
    }
  }
  save3() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    final response = await http
        .post(baseurl +version+ sendfeedback, body: {
      "enquiry_type": _mySelection,
      "subject": subject,
      "message": Message,
      "file": ""
    } , headers: {
      'Auth': token
    }
    );
    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == "1") {
      registerToast(
          " Thanks for Registering.  After successful verification, you could log in to our Application.");
      subjectHolder.clear();
      MessageHolder.clear();
    } else {
      registerToast(message);
    }
  }
  registerToast(String toast) {
    return FlutterToast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }
  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    setState(() {
      loading = true;
    });

    final responseData = await http.get(
       baseurl+version+getenquirytypes, headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listservices = jsonDecode(data)['content']['typesArr'] as List;
      setState(() {
        for (Map i in listservices) {
          listService.add(TypesArr.fromMap(i));
        }
        loading = false;
      });
    }


  }

  void initState(){
    super.initState();
    getData();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body:  ListView(
        children: <Widget>[
          Container(

            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: new DropdownButton(

                isExpanded: true,
                hint:  Text("Choose a Category"),
                items: listService.map((item) {
                  return new DropdownMenuItem(

                    child: new Text(item.enquiryTitle),
                    value: item.enquiryType.toString(),

                  );
                }).toList(),
                onChanged: (newVal) {

                  setState(() {

                    _mySelection = newVal;
                  });
                  print(_mySelection);
                },
                value: _mySelection,
              ),
            ),
          ),
          _mySelection == "2" ? Container(
            child:   Material(
              elevation: 0.0,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              controller: subjectHolder,
                              focusNode: subjectFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => subject = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Subject",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,

                            child: TextFormField(
                              controller: MessageHolder,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              focusNode: messageFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => Message = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Message",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              controller: ordernumberHolder,
                              focusNode: ordernumberFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => roll = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),

                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Order Number",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              controller: rollHolder,
                              focusNode: rollFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => ordernumber = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "User Role",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          OutlineButton(

                            onPressed: () {
                              _openFileExplorer();
                            },
                            child: Text('Choose File'),
                          ),
                          SizedBox(height: 15),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [primarycolor[600], primarycolor])),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child:TextButton(

                                      child: Text(
                                        "Submit Request",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        check();
                                      },
                                    ),
                                  ))),
                        ],
                      )),

                ],
              ),
            ),
          ): Container(
          ), _mySelection == "3" ? Container(
            child:   Material(
              elevation: 0.0,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              controller: subjectHolder,
                              focusNode: subjectFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => subject = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Subject",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,

                            child: TextFormField(
                              controller: MessageHolder,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              focusNode: messageFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => Message = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Message",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),

                          SizedBox(height: 15),
                          OutlineButton(

                            onPressed: () {
                              _openFileExplorer();
                            },
                            child: Text('Choose File'),
                          ),
                          SizedBox(height: 15),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [primarycolor[600], primarycolor])),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child:TextButton(

                                      child: Text(
                                        "Submit Request",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        check1();
                                      },
                                    ),
                                  ))),
                        ],
                      )),

                ],
              ),
            ),
    ): Container(
          ),
          _mySelection == "4" ? Container(
            child:   Material(
              elevation: 0.0,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              controller: subjectHolder,
                              focusNode: subjectFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => subject = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Subject",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,

                            child: TextFormField(
                              controller: MessageHolder,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              focusNode: messageFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => Message = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Message",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),

                          SizedBox(height: 15),
                          OutlineButton(

                            onPressed: () {
                              _openFileExplorer();
                            },
                            child: Text('Choose File'),
                          ),
                          SizedBox(height: 15),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [primarycolor[600], primarycolor])),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child:TextButton(

                                      child: Text(
                                        "Submit Request",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        check2();
                                      },
                                    ),
                                  ))),
                        ],
                      )),

                ],
              ),
            ),
          ): Container(
          ),
          _mySelection == "5" ? Container(
            child:   Material(
              elevation: 0.0,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              controller: subjectHolder,
                              focusNode: subjectFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => subject = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Subject",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,

                            child: TextFormField(
                              controller: MessageHolder,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              focusNode: messageFocusNode,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter field";
                                }
                                return null;
                              },
                              onSaved: (e) => Message = e,
                              style: TextStyle(
                                //height: 1,
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primarycolor),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  labelText: "Message",
                                  labelStyle: TextStyle(
                                      color: primarycolor
                                  )),
                            ),
                          ),

                          SizedBox(height: 15),
                          OutlineButton(

                            onPressed: () {
                              _openFileExplorer();
                            },
                            child: Text('Choose File'),
                          ),
                          SizedBox(height: 15),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [primarycolor[600], primarycolor])),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child:TextButton(

                                      child: Text(
                                        "Submit Request",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        check3();
                                      },
                                    ),
                                  ))),
                        ],
                      )),

                ],
              ),
            ),
          ): Container(
          ),
        ],
      ),


    );
  }
}
