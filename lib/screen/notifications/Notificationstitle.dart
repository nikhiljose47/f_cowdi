import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';


Widget pagetilesec() {
  return Container(
    padding: EdgeInsets.only(left: 0.00),
    child: Center(child: Text("Notifications")),
  );
}
// title right
Widget rightsec(){
  return Container(
    padding: EdgeInsets.only(right: 5.0),
    child:
    Row(
      children: <Widget>[
        GestureDetector(
          child: Text(
            'Edit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primarycolor,
            ),
          ),
          onTap: () {
            print("home");
          },
        ),
      ],
    ),


  );
}
