import 'package:flutter/material.dart';
import 'package:flutter_app/screen/Support/buyer.dart';
import 'package:flutter_app/services/api.dart';

class help extends StatefulWidget{
  help({Key key,this.title}):super(key:key);
  final String title;
  @override
  _helpState createState()=>_helpState();
}
class _helpState extends State<help>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    //
    singleCard(iconcode,icontitle){
      return Card(
        color: Colors.white,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                IconData(iconcode,fontFamily: 'MaterialIcons',),color: primarycolor,size: 25.0,),
              Text(
                icontitle,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,

                ),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Help & Support',style: TextStyle(color:Colors.black87),),
        leading: Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        centerTitle: true,

      ),
      body:Container(
        child:Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
                labelText: "  What are you looking for?",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(45.0)))),
          ),Expanded(
            child:GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.all(2),
              children: <Widget>[
                singleCard(59576,'        Getting              \t       Started '),
                singleCard(59576, '      Accounts &   \tProfile Settings '),
                singleCard(60223, '     Buying on         \t     Proposal'),
                singleCard(59576, '            My            \t        Orders'),
                singleCard(59553, '      Payment &        \t       Invoices'),
                singleCard(59641, '     Bussiness       \t        Tools'),
              ],
            ),),
          Container(
            child: Padding(
                padding: EdgeInsets.only(top:10.0),
                child: Text("Can't find what you're looking for?",style: TextStyle(fontSize: 16.0,height: 1.5),textAlign: TextAlign.center,)
            ),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.center,
              child: Text("Please visit our Help Center for more information",style: TextStyle(fontSize: 16.0,height: 1.5),textAlign: TextAlign.center,),
            ),
          ),
          Expanded(
            child:Align(
              alignment:FractionalOffset.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top:16.0),
                child: RaisedButton(
                  onPressed: (){ Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>buyer() ),
                  );
                  },
                  child: Text("BUYER HELP CENTER"),
                  color: primarycolor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(18.0),
                  splashColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() => _index = newIndex),
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        fixedColor: primarycolor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), title: Text("Inbox",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Explore",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), title: Text("Notifications",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), title: Text("Others",style: TextStyle(color: Colors.black87),)),
        ],
      ),
    );
  }
}