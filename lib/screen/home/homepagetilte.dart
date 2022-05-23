import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';

Widget pagetilesec() {
  return Container(
    padding: EdgeInsets.only(left: 0.00),
    child: Center(child: Text("Cowdiar")),
  );
}
// title right
Widget rightsec(context){
return Container(
    child: Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.grid_on,
            size: 20.0,
            color: Colors.black,
          ),
          onPressed: () {


          },
        ),
      ],
    ));
}


Widget custorsec() {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 8.00),
      child: Text('My Custom Offers',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'SophiaNubian',
          )),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 8.00),
      child: InkWell(
          child: Text("See all",
              style: TextStyle(
                fontSize: 16,
                color: primarycolor,
              )),
          onTap: () {
            print('saasas');
          }),
    ),
  ]);
}

Widget servicestitle() {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10.00),
      child: Text('Popular Professional Services',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'SophiaNubian',
          )),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 8.00),
      child: InkWell(
          child: Text("See all",
              style: TextStyle(
                fontSize: 16,
                color: primarycolor,
              )),
          onTap: () {
            print('saasas');
          }),
    ),
  ]);
}

Widget marketplacetitle() {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 0.00),
      child: Text('Explore The Marketplace',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'SophiaNubian',
          )),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 0.00),
      child: InkWell(
          child: Text("See all",
              style: TextStyle(
                fontSize: 16,
                color: primarycolor,
              )),
          onTap: () {
            print('saasas');
          }),
    ),
  ]);
}


// Serach section
Widget searchsec() {
  return Column(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 20.00, right: 20.00),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(
              color: Colors.grey,
              width: 1.0,
              style: BorderStyle.solid
          ),
  borderRadius:new BorderRadius.all(new Radius.circular(10.0)
  )),


        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(left: 10.00),
              //width: 280,
              height: 45,

              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  new Text("  What are you looking for?"),
                ],
              ),
            ),
            onTap: () {
              print("Container ");
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 10.00),
              height: 45,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.mic,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            onTap: () {
              print("Container was tapped");
            },
          ),
        ]),
      ),
    ],
  );
}