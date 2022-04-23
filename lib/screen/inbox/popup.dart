import "package:flutter/material.dart";

class PopupMenuButtonPage extends StatefulWidget {
  @override
  _PopupMenuButtonState createState() => _PopupMenuButtonState();
}

class _PopupMenuButtonState extends State<PopupMenuButtonPage> {
  @override
  Widget build(BuildContext context) {
    Widget _threeItemPopup() => PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
            child: Text("Setting Language"),
            value: "1",
          ),
        );
        list.add(
          PopupMenuDivider(
            height: 10,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text(
              "English",
              style: TextStyle(color: Colors.red),
            ),
            value: "2",
            checked: true,
          ),
        );
        return list;

      },
      icon: Icon(
        Icons.settings,
        size: 50,
        color: Colors.white,
      ),
    );
    Widget _selectPopup() => PopupMenuButton<int>(

        itemBuilder: (context) => [
          PopupMenuItem(
            child: Container(
              color: Colors.red,
            child: Text("filters"),
          ),
        ),
          PopupMenuItem(
            value: 1,
            child: Text("All"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("unread"),
          ),
          PopupMenuItem(
            value: 3,
            child: Text("starred"),
          ),
          PopupMenuItem(
            value: 4,
            child: Text("Archive"),
          ),
          PopupMenuItem(
            value: 5,
            child: Text("spam"),
          ),
          PopupMenuItem(
            value: 6,
            child: Text("send"),
          ),
          PopupMenuItem(
            value: 7,
            child: Text("Custom Offers"),
          ),
          PopupMenuItem(
            child: Container(
              color: Colors.red,
              child: Text("tags"),
            ),
          ),

        ],
        initialValue: 2,
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
        },
        icon: Icon(Icons.list),

    );


    return Scaffold(
      appBar: AppBar(
        title: Text("POPUP_MENU_BUTTON"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              color: Colors.grey,
              constraints: BoxConstraints.expand(height: 80),
              child: Container(

                  child: _selectPopup()
              ),
            ),
          ],
        ),
      ),
    );
  }
}