import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/others/other.dart';
import 'package:flutter_app/services/api.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

class terms extends StatefulWidget {
  @override
  termsState createState() => new termsState();
}

class termsState extends State<terms> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Terms of Service",style: TextStyle(
          color: Colors.black,
        ),),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: baseurl+termslink,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );

  }
}