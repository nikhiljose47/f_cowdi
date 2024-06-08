import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/screen/managarequest/managarequest.dart';
import 'package:flutter_app/screen/manage/manage.dart';
import 'package:flutter_app/screen/manage/selling_order.dart';
import 'package:flutter_app/screen/onlistatus/onlinestatus.dart';
import 'package:flutter_app/screen/postarequest/postarequest.dart';
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
import '../setting/logout.dart';
import '../setting/pushNotification.dart';
import '../setting/setting.dart';

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
    super.initState();
    getPref();
    getDatalist();
  }

  List<Widget> sharedSettings() {
    return [
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
              Icons.language,
            ),
            title: Text('Language'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
              Icons.currency_exchange,
            ),
            title: Text('Currency'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
              Icons.policy,
            ),
            title: Text('About'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
          title: Text('Terms of services'),
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
              Icons.business,
            ),
            title: Text('Become a Seller'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
              Icons.display_settings,
            ),
            title: Text('Appearence'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ))
    ];
  }

  Widget othersec(context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: double.maxFinite,
                height: 180,
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
                                Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.settings,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Setting(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  child: CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage:
                                        NetworkImage(datacard.sellerImage),
                                  ),
                                ),
                                SizedBox(height: 7),
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
          padding: EdgeInsets.only(top: 15, bottom: 16, left: 20),
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
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 113, 113, 113),
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
          padding: EdgeInsets.only(top: 6, bottom: 16, left: 20),
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
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 113, 113, 113),
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
          padding: EdgeInsets.only(top: 6, bottom: 16, left: 20),
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
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 113, 113, 113),
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
              Icons.notifications,
            ),
            title: Text(
              'Push Notification',
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PushNotification()),
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
      ]
        ..addAll(sharedSettings())
        ..add(Container(
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
            title: Text(
              'Logout',
            ),
            leading: Icon(
              Icons.logout,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => logout()),
              );
            },
          ),
        )),
    );
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
