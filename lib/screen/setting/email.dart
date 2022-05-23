import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';

class email extends StatefulWidget{
  @override
  _emailState createState(){
    return _emailState();
  }

}
class _emailState extends State<email> {
  int _index=0;
  bool _isSwitched = false;
  bool _newisSwitched=false;
  bool _onSwitched=false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        title: Text('Email Notification',style: TextStyle(color: Colors.black87),),
        centerTitle: true,
      ),
      body: Column(
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
              title:   Text(
                "Order Messages",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (bool newval) => setState(() => _isSwitched = newval),
                value: _isSwitched,
              ),),
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
            child:ListTile(
              title: Text('Order Updates', style: TextStyle(fontSize: 18,color: Colors.black),),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (bool newval) => setState(() => _newisSwitched = newval),
                value: _newisSwitched,
              ),),
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
              title: Text('Inbox Messages', style: TextStyle(fontSize: 18,color: Colors.black),),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (bool newval) => setState(() => _onSwitched = newval),
                value: _onSwitched,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() => _index = newIndex),
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        fixedColor: primarycolor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), activeIcon: Text("Home",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), activeIcon: Text("Inbox",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Text("Explore",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), activeIcon: Text("Notifications",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Text("Others",style: TextStyle(color: Colors.black87),)),
        ],
      ),

    );
  }
}