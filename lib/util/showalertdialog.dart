import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {  
  final BuildContext? context;
  final String title;
  final String? content;

 ShowAlertDialog({Key? key, this.context, required this.title, this.content}) : super(key: key);

  @override  
  Widget build(context) { 
    print("call came"); 
    return Padding(  
      padding: const EdgeInsets.all(20.0),  
      child: ElevatedButton(  
        child: Text('Show alert'),  
        onPressed: () {  
          showAlertDialog(context);  
        },  
      ),  
    );  
  }  

  showAlertDialog(BuildContext context) {  
  Widget okButton = ElevatedButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text(title),  
    content: Text(content!),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
}  