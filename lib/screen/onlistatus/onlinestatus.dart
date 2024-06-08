import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/services/api.dart';
class onlinestatus extends StatefulWidget{
  final String listservicesstus;//if you have multiple values add here
  onlinestatus(this.listservicesstus, {Key key}): super(key: key);

  @override
  _onlinestatusState createState(){
    return _onlinestatusState();

  }

}
class _onlinestatusState extends State<onlinestatus> {
  String token = "";
  String name,listservicesstus;
  bool _isSwitched;
  var loading = false;
  getdata() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);

    final responseDatastatus = await http.get( baseurl + version + statuscheck, headers: {'Auth': token});
    if (responseDatastatus.statusCode == 200) {
      final data = responseDatastatus.body;
      var listservicesstus = jsonDecode(data)['content']['seller_status'] as String;
     if (listservicesstus == "online"){
       setState(() {
         _isSwitched =  true;
         print(_isSwitched);
       });

     }else{
       setState(() {
         _isSwitched =  false;
       });
     }

      loading = false;
    }
  }




  save() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });

    if( _isSwitched == true ) {
      print("innertrur");
      final response = await http
          .post(
          baseurl+version+updateonlinestatus, body: {
        "online_status": "online",
      }, headers: {'Auth': token});
      final data = response.body;
      var value = jsonDecode(data)['status'];
      var message = jsonDecode(data)['message'];
      if(value == '1'){
        postreToast(message);
      }else{
        postreToast(message);
      }
    }else{
      print("innerfalse");
      final response = await http
          .post(
         baseurl+version+updateonlinestatus, body: {
        "online_status": "offline",
      }, headers: {'Auth': token});
      final data = response.body;
      var value = jsonDecode(data)['status'];
      var message = jsonDecode(data)['message'];
      if(value == '1'){
        postreToast(message);
      }else{
        postreToast(message);
      }
    }

  }
  postreToast(String toast) {
    return FlutterToast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
print(_isSwitched);
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Status", style: TextStyle(color: Colors.black87),),
        centerTitle: true,
      ),
      body:
      _isSwitched == null ?  Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
          : Column(
        children: <Widget>[
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
          ),
          SizedBox(height: 55),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:  ListTile(
              title: Text(
                "Show Online",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (val) {
                  setState(() {
                    _isSwitched = val;
                  });
                  print(_isSwitched);
                  save();
                },
                value: _isSwitched ,

              ),
            )
          ),
          Container(
            padding: EdgeInsets.only(right:42.00,top: 15.0),
            child: Text("You'll remain Online for as long as the app is open",style: TextStyle(fontSize: 13.0,color: Colors.grey),textAlign: TextAlign.left,),
          )
        ],
      ),

    );
  }
}