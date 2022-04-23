import 'package:flutter/material.dart';
import 'package:flutter_app/screen/Payment/currency.dart';
import 'package:flutter_app/services/api.dart';

class payment extends StatefulWidget{
  @override
  _paymentState createState(){
    return _paymentState();
  }

}
class _paymentState extends State<payment> {
  int _index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        title:  Text('Payments',style: TextStyle(color: Colors.black87),),
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
            child: new Container(
              child: ListTile(
                title: Text('Currency', style:TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                )
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              //  onTap: () {
                //  Navigator.push(
                  //  context,
                   // MaterialPageRoute(builder: (context) => currency()),
                  //);
                //},
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