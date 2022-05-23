import 'package:flutter/material.dart';
import 'package:flutter_app/Widget/catvariable.dart';
import 'package:flutter_app/services/api.dart';

class catDetailPage extends StatelessWidget {
  final Cat? cat;
  catDetailPage({Key? key, this.cat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80.0),
        Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: primarycolor),
        ),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.only(bottom: 20.00),
          child: Text(
            cat!.name!,
            style: TextStyle(color: Colors.white, fontSize: 45.0),
          ),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[

        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 4.0,
          top: 20.0,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: InkWell(

              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        )
      ],
    );

    final bottomContentText = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.00),
          child: Center(
            child: Text(
              cat!.name!,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ],
    );


    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[topContent, bottomContentText],
        ),
      ),
    );
  }
}