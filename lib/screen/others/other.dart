import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/screen/Payment/Payment.dart';
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/screen/managarequest/managarequest.dart';
import 'package:flutter_app/screen/manage/manage.dart';
import 'package:flutter_app/screen/manage/selling_order.dart';
import 'package:flutter_app/screen/onlistatus/onlinestatus.dart';
import 'package:flutter_app/screen/postarequest/postarequest.dart';
import 'package:flutter_app/screen/register/register.dart';
import 'package:flutter_app/screen/setting/privacy.dart';
import 'package:flutter_app/screen/setting/seting.dart';
import 'package:flutter_app/screen/setting/terms.dart';
import 'package:flutter_app/screen/support/support.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/util/profile.dart';

class Others extends StatefulWidget {
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  String token = "";
  var loading = false;
  String linkdata;
  bool exitApp = false;
  List<MProfile> listService = [];
  String listservicesstus;
  List<AppInfo> apiinforlist = [];
  Future<Null> getDatalist() async {
    final responseDataappinfo = await http.post(baseurl + version + sitedetails,
        body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info'] as List;
      linkdata = jsonDecode(dataapinfo)['content']['app_info'][0]['app_link'];
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i));
        }
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);
    setState(() {
      loading = true;
    });
    print(token);
    if (token == null) {
      print("not");
    } else {
      final responseData =
          await http.get(baseurl + version + profile, headers: {'Auth': token});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        var listservices = jsonDecode(data)['content']['mProfile'] as List;

        print(listservices);
        setState(() {
          for (Map i in listservices) {
            listService.add(MProfile.fromMap(i));
          }
          loading = false;
        });
      }
    }
  }

  getstatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);

    final responseDatastatus = await http
        .get(baseurl + version + statuscheck, headers: {'Auth': token});
    if (responseDatastatus.statusCode == 200) {
      final data = responseDatastatus.body;
      var listservicesstus =
          jsonDecode(data)['content']['seller_status'] as String;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => onlinestatus(listservicesstus),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getDatalist();
  }

  Widget othersec(context) {
    if (token == null) {
      return ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  height: 150,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 136, 135, 135),
                  ),
                  padding: EdgeInsets.only(top:20),
                  child: Row(children: <Widget>[
                    Column(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Guest",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Welcome to Cowdiar!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
            ],
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.vpn_key,
              ),
              title: Text("Join Cowdiar"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: Text('Sign In'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login("loginfull"),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "General",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.format_indent_decrease,
              ),
              title: Text('Terms of services '),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => terms()),
                );
              },
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.lock,
              ),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => privacy()),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  height: 200,
                  decoration: new BoxDecoration(
                    color: primarycolor,
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primarycolor)))
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listService.length,
                          itemBuilder: (context, i) {
                            final datacard = listService[i];
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Icon(
                                          Icons.settings,
                                          size: 30.0,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => seting(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 35.0),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage: NetworkImage(
                                              datacard.sellerImage),
                                        ),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      datacard.sellerName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ]);
                          })),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "Buying",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.reorder,
              ),
              title: Text('Manage Orders'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => manageorder(),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.list,
              ),
              title: Text('Manage Requests'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => manageeq(),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: listService.length == 0
                ? Text("")
                : ListTile(
                    leading: Icon(
                      Icons.open_in_new,
                    ),
                    title: Text('Post a Request '),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => postarequest(
                              listService[0].sellerVerificationStatus),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "Selling",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.reorder,
              ),
              title: Text('Manage Orders'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellingOrder(),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "General",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.cached,
              ),
              title: Text('Online Status'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                getstatus();
                print(listservicesstus);
              },
            ),
          ),
          linkdata != ""
              ? Container(
                  decoration: new BoxDecoration(
                    color: Colors.white10,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.rotate_left,
                    ),
                    title: Text('Invite Friends'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      final RenderBox box = context.findRenderObject();
                      Share.share(linkdata,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                  ),
                )
              : Container(
                  height: 0,
                ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.call,
              ),
              title: Text('Support'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => support(0)),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Future<bool> onWillPop() {
    setState(() {
      exitApp = !exitApp;
      Future.delayed(Duration(seconds: 5), () {
        exitApp = !exitApp;
      });
    });
    if (exitApp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Text("Are you sure to exit!"),
        margin: const EdgeInsets.all(60),
      ));
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
    return false as Future<bool>;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop, child: Scaffold(body: othersec(context)));
  }
}
