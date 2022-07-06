import 'package:flutter/material.dart';
import 'package:flutter_app/screen/setting/pushNotification.dart';
import 'package:flutter_app/screen/setting/email.dart';

class notification extends StatefulWidget {
  _notificaitionState createState() => _notificaitionState();
}
class _notificaitionState extends State<notification>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        title: Text('Notifications',style: TextStyle(color: Colors.black87),),
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
            child:ListTile(
              title: Text('Push notifications',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PushNotification()),
                );
              },),),


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
              title: Text('Email notifications',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing :Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => email()),
                );
              },),
          ),
        ],
      ),

    );
  }
}

