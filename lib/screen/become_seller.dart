import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BecomeSeller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Set up seller profile on a desktop to start selling",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
              width: 250,
              height: 250,
              child: Image.asset(
                'assets/desktop_seller.png',
              )),
          
        ],
      ),
    );
  }
}
