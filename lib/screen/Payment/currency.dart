//import 'dart:developer';

//import 'package:flutter/material.dart';

//class currency extends StatefulWidget {
 // @override
 // _currencyState createState() => _currencyState();
//}

//class _currencyState extends State<currency > {
  //double padValue = 0;

  //List<Paint> paints = <Paint>[
  //  Paint(1, 'British Pound', Colors.red),
    //Paint(2, 'Euro', Colors.blue),
    //Paint(3, 'Australian Dollar', primarycolor),
    //Paint(4, 'Canadian Dollar', Colors.lime),
    //Paint(5, 'US Dollar', Colors.indigo),
    //Paint(6, 'Israeli New Shekei', Colors.yellow),
    //Paint(6, 'Brazillian Real', Colors.pink),
    //Paint(6, 'Hong Kong Dollar', Colors.purple),
    //Paint(6, 'New Zealand Dollar', Colors.lightGreenAccent),
    //Paint(6, 'Singapore Dollar', Colors.orange),
    //Paint(6, 'Swiss Franc', Colors.grey),
    //Paint(6, 'South African Rand', Colors.indigo)
  //];

  //@override
  //Widget build(BuildContext context) {

    //return MaterialApp(
      //home: Scaffold(
      // appBar: AppBar(
         // title: Text("Currency"),
       //   centerTitle: true,
        //),
        //body: ListView(
          //children: List.generate(paints.length, (index) {
            //return ListTile(
              //onTap: () {
                //setState(() {
                  //paints[index].selected = !paints[index].selected;
                  //log( paints[index].selected.toString());
              //  });
              //},
              //selected: paints[index].selected,
              //leading: GestureDetector(
                //behavior: HitTestBehavior.opaque,
                //onTap: () {},
                //child: Container(
                 // width: 48,
                  //height: 48,
                  //padding: EdgeInsets.symmetric(vertical: 4.0),
                  //alignment: Alignment.center,
                  //child: CircleAvatar(
                   // backgroundColor: paints[index].colorpicture,
                 // ),
                //),
              //),
              //title: Text(paints[index].title ,  style:TextStyle(
                //fontSize: 20,
                //color: Colors.black,
              //)),

              //trailing: (paints[index].selected) ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank, color: Colors.transparent,),

            //);
         // }),
        //),
      //),
    //);
//  }
//}

//class Paint {
  //final int id;
  //final String title;
  //final Color colorpicture;
  //bool selected = false;

  //Paint(this.id, this.title, this.colorpicture);
//}