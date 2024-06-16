import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class terms extends StatefulWidget {
  @override
  termsState createState() => new termsState();
}

class termsState extends State<terms> {
  var _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(baseurl+termslink));
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
      body: WebViewWidget(controller: _controller),
    );

  }
}