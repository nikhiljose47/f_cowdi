import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:share/share.dart';

class invitePage extends StatefulWidget {
  @override
  _invitePage createState() => _invitePage();
}

myBoxDecorationfirst() {
  return BoxDecoration(
      color: Colors.white,
      border: new Border.all(
          color: Colors.grey,
          width: 0.5,
          style: BorderStyle.solid
      ),

      borderRadius:new BorderRadius.all(new Radius.circular(10.0)
      ));
}

class _invitePage extends State<invitePage> {
  List<AppInfo> apiinforlist = [];
  String linkdata;
  Uri s;

  Future<Null> getData() async {
    //final responseDataappinfo = await http.post( Uri.parse(baseurl + version + sitedetails), body:{'mobile_type':Platform.isAndroid?'android':'ios'});
    final responseDataappinfo = await http.post(s, body:{'mobile_type':Platform.isAndroid?'android':'ios'});

    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info']  as List;
      linkdata=jsonDecode(dataapinfo)['content']['app_info'][0]['app_link'];
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i));
        }
      });
    }
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    return linkdata != "" ?Container(
margin: EdgeInsets.only(left: 5.0,right: 5.0),
      child: Center(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top:20,left: 10,right: 10,bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                apiinforlist.length != 0 ? Text("Invite friends & get up to "+ apiinforlist[0].invitePrice ,style: TextStyle(
                  fontSize: 16,
                  color: primarycolor,
                  fontWeight: FontWeight.w600,
                ),textAlign: TextAlign.center):Text(""),
                ListTile(
                  subtitle: Text('Introduce your friends to the fastest way to get things done.',textAlign: TextAlign.center,),
                ),
                ElevatedButton(
                  onPressed: ()
                    {
                      final RenderBox box = context.findRenderObject();
                      Share.share(linkdata,
                          sharePositionOrigin:
                          box.localToGlobal(Offset.zero) &
                          box.size);
                    },
                  child: Text(
                    "INVITE",
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ):Container(height: 0,);
  }
}