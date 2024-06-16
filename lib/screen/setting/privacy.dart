import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class privacy extends StatefulWidget {
  @override
  privacyState createState() => new privacyState();
}

class privacyState extends State<privacy> {
 final _controller = WebViewController()
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
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(baseurl + version + privacypolicy));
  @override
  Widget build(BuildContext context) {
    print(baseurl + version + privacypolicy);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: Color.fromARGB(3, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller)
    );
  }
}
