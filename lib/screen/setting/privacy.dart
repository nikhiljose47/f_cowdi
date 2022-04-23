import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/others/other.dart';
import 'package:flutter_app/services/api.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

class privacy extends StatefulWidget {
  @override
  privacyState createState() => new privacyState();
}

class privacyState extends State<privacy> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    print(baseurl+version+privacypolicy);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Privacy Policy",style: TextStyle(
          color: Colors.black,
        ),),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: baseurl + version + privacypolicy,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );

  }
}