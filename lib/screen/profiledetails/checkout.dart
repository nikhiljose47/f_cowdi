import 'package:flutter/material.dart';
import 'package:flutter_app/screen/manage/manage.dart';
import 'package:flutter_app/screen/profiledetails/CustomDialog.dart';
import 'package:flutter_app/screen/profiledetails/cart.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_app/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class checkout extends StatefulWidget {
  final String? checkoutlink ,token;//if you have multiple values add here
  checkout(this.checkoutlink, this.token, {Key? key}): super(key: key);
  @override
  _checkoutState createState() => new _checkoutState();
}

class _checkoutState extends State<checkout> {
  InAppWebViewController? webView;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  String url  ="";
  String? tokens = "";
  double progress = 0;
  String? checkoutpar ="";
  void makeRequest() {
    setState(() {
      url = baseurl + version +'/';
      checkoutpar = widget.checkoutlink;
      tokens = widget.token;
    });
    print(url+checkoutpar!+'&Auth='+tokens!);
  }



  @override
  void dispose() {
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    print("sdsdsdsd");
    print(url+checkoutpar!+'&Auth='+tokens!);

    return Scaffold(
        appBar: AppBar(
          title: Text("Checkout"),
          centerTitle: true,
        ),
        body: Container(
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress, valueColor:
                  new AlwaysStoppedAnimation<Color>(primarycolor))
                      : Container()),
              Expanded(
                child: webvies(),
              ),
            ])));
  }
  Widget webvies(){
    return Container(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url+checkoutpar!+'&Auth='+tokens!) ) ,
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
            )),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onReceivedServerTrustAuthRequest: (InAppWebViewController controller, URLAuthenticationChallenge challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
        onLoadStart: (InAppWebViewController controller, Uri? uri) {
          setState(() {
            
            this.url = 'url';
            var valuetoredirect = this.url.substring(39, 45);
            print(valuetoredirect);
            if (valuetoredirect == 'succes') {
              print('if');
              print(valuetoredirect);
              showDialog(
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(seconds: 5), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  manageorder()));
                    });
                    return CustomDialog(
                      title: "Order Completed Successfuly!",
                      content:
                      "We've sent you an email with the order information",
                      image: Icon(Icons.check, color: Colors.white,size: 40,),
                      colors: Colors.green,
                    );
                  });
            } else if (valuetoredirect == 'failed') {
              print('elsee');
              print(valuetoredirect);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  cart()));
                    });
                    return CustomDialog(
                      title: "Your Order Failed!",
                      content:
                      "Please try again",
                      image: Icon(Icons.cancel, color: Colors.white,size: 40,),
                      colors: Colors.red,
                    );
                  });
            }
          });
        },
        onProgressChanged:
            (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      ),
    );
  }
}
