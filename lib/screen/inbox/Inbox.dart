import 'package:flutter/material.dart';
import 'package:flutter_app/screen/inbox/Inboxtitle.dart';
import 'package:flutter_app/screen/inbox/inboxdetail.dart';
import 'package:flutter_app/screen/inbox/popmenu.dart';
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/util/inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
class Inboxpage extends StatefulWidget {
  Inboxpage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _InboxpageState createState() => _InboxpageState();
}

class _InboxpageState extends State<Inboxpage> {
  int _selectedIndex = 0;
  String token = "";
  List<InboxArr> listSCArr = [];
  String choice;
  String items="all";
  var loading = false;

  Future<Null> getData(String choice) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print("index");
    print(token);
    setState(() {
      loading = true;
    });
    print(choice);
    if(token != null) {
      if (choice == null) {
        final responseData = await http.post(baseurl + version + inboxbox,
            body: {"filter_status": "all"}
            , headers: {'Auth': token});
        if (responseData.statusCode == 200) {
          final data = responseData.body;
          var listsCArr = jsonDecode(data)['content']['inboxArr'] as List;
          setState(() {
            for (Map i in listsCArr) {
              listSCArr.add(InboxArr.fromMap(i));
            }
            loading = false;
          });
        }
      } else {
        final responseData = await http.post(baseurl + version + inboxbox,
            body: {"filter_status": choice}
            , headers: {'Auth': token});
        if (responseData.statusCode == 200) {
          final data = responseData.body;
          var listsCArr = jsonDecode(data)['content']['inboxArr'] as List;
          print(listsCArr);
          setState(() {
            for (Map i in listsCArr) {
              listSCArr.add(InboxArr.fromMap(i));
            }
            loading = false;
          });
        }
      }
    }

  }
  Future<Null> action(String messageGroupId, String actionval) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print("index");
    print(token);
    setState(() {
      loading = true;
    });

    final responseData = await http.post( baseurl + version  + actionlink ,
        body: {"message_group_ids": messageGroupId,
          "action_status":actionval},
        headers: {'Auth': token}
    );
    final data = responseData.body;
    var value = jsonDecode(data)['status'];
    var message = jsonDecode(data)['message'];
    print(value);
    if(value=="1"){
      loginToast(message);
      listSCArr.clear();
      getData(choice);
    }else{
      loginToast(message);
    }
    setState(() {
    });

  }
  loginToast(String toast) {
    return FlutterToast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }
  void choiceAction(String choice){
    if(choice == Constants.unread){
      listSCArr.clear();
      getData(choice);
    }else if(choice == Constants.star){
      listSCArr.clear();
      getData(choice);
    }else if(choice == Constants.archive){
      listSCArr.clear();
      getData(choice);
      print(choice);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(choice);

  }
  Widget slideRightBackground() {
    return Container(
      color: primarycolor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Text(
              "archive",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (token != null) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          elevation: 0.0,
          title: Container(
              width: MediaQuery.of(context).size.width/1.7,
              child: Center(child: Text("Inbox"))
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],

        ),
        // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: loading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
            : listSCArr.length != 0 ? ListView.builder(
            itemCount: listSCArr.length,
            itemBuilder: (context, i) {
              final nDataList = listSCArr[i];
              String statusin =  nDataList.onlineStatus;
              return Dismissible(
                key: Key(nDataList.senderName),
                child: InkWell(
                    child: GestureDetector(
                      child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                nDataList.senderImage)
                                        )
                                    ),
                                      child: new Stack(
                                        children: <Widget>[
                                          if (statusin == 'online')
                                            new Positioned(
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new  Icon(
                                                Icons.fiber_manual_record,
                                                size: 15.0,
                                                color: primarycolor,
                                              ),
                                            ),

                                          if (statusin == 'offline')
                                            new Positioned(
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new   Icon(
                                                Icons.fiber_manual_record,
                                                size: 15.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      )
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                nDataList.senderName.length > 21 ? nDataList.senderName.substring(0,21): nDataList.senderName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black87,
                                                    fontSize: 17.0),
                                              ),
                                              Text(
                                                nDataList.dateTime,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black54,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 1.8,
                                                    child: Text(
                                                      nDataList.senderMessage,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 15.5),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ]
                      ),
                      onLongPress: () async {
                        final bool res = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    "Are you sure you want to make unread it ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "No",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      // TODO: Delete the item from DB etc..
                                      setState(() {
                                        action(nDataList.messageGroupId,"unread");
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                        return res;
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Inboxdetailpage(
                                  nDataList.messageGroupId, nDataList.senderName);
                            },
                          ),
                        );
                      },
                    )),
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to delete ?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // TODO: Delete the item from DB etc..
                                  setState(() {
                                    action(nDataList.messageGroupId,"delete");
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  } else {
                    // TODO: Navigate to edit page;
                  }
                  if (direction == DismissDirection.startToEnd) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to archive ?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // TODO: Delete the item from DB etc..
                                  setState(() {
                                    action(nDataList.messageGroupId,"archive");
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  }else{

                  }
                },
              );
            }):Container(
          child: Center(
            child:Text("No Inbox Are Avaliable", style: TextStyle(
              color: primarycolor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),),
          ),
        ),
      );
    }else {
      return Login("inbox");
    }
  }
}