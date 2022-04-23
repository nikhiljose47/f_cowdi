import 'package:flutter/material.dart';
import 'package:flutter_app/screen/setting/notification.dart';
import 'package:flutter_app/screen/setting/logout.dart';
import 'package:flutter_app/screen/setting/privacy.dart';
import 'package:flutter_app/screen/setting/pushNotification.dart';
import 'package:flutter_app/screen/setting/terms.dart';
//import 'package:flutter_app/screen/setting/privacy.dart';
//import 'package:flutter_app/screen/setting/terms.dart';
class seting extends StatefulWidget{
  _setingState createState()=>_setingState();
}
class _setingState extends State<seting>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
       title: Text('Settings', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
      ),
      body:Column(
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
          SizedBox(height: 60),
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
            child: ListTile(
              title: Text('Push Notification',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing : Icon(Icons.arrow_forward_ios),
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
            child: ListTile(
              title: Text('Terms of Service',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing : Icon(Icons.arrow_forward_ios),
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
            child: ListTile(
              title: Text('Privacy Policy',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing :Icon(Icons.arrow_forward_ios),
                onTap: () {
               Navigator.push(
               context,
                MaterialPageRoute(builder: (context) => privacy()),
              );
               },
            ),),



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
            child:ListTile(
              title:   Text('Logout',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing:Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => logout()),
                );
              },
            ),

          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 25.0,bottom: 10.0),
            child: Text("v2.66.1(2)",style: TextStyle(color:Colors.black45),),
          ),
        ],
      ),

    );
  }
}