
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, content;
  final Icon image;
  final Color colors;
  CustomDialog({
    this.title,
    this.content,
    this.image,
    this.colors
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(  // Bottom rectangular box
          margin: EdgeInsets.only(top: 40), // to push the box half way below circle
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: colors, fontSize: 16.0,fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                content,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: colors,
          maxRadius: 40.0,
          child: image,
        ),
      ],
    );
  }
}

