import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/screen/home/home.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/profiledetails/checkout.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/cartpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class cart extends StatefulWidget {
  @override
  cartPage createState() => cartPage();
}

class cartPage extends State<cart> {
  int _itemCount = 0;
  List<CartDetail> datacart = [];
  List<Payment> directcontent = [];
  var loading = false;
  String token = "";

  addquenty(String productid, String count) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print("index");
    print(count);
    print(token);
    print(productid);
    final response = await http.post(baseurl + version + changecart,
        body: {"proposal_id": productid, "proposal_qty": count},
        headers: {'Auth': token});

    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == '1') {
      _itemCount = 0;
      loginToast(message);
      datacart.clear();
      directcontent.clear();
      getData();
    } else {
      setState(() {
        loading = false;
      });
      loginToast(message);
    }
  }

  delete(String productid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print("index");
    print(token);
    print(productid);
    final response = await http.post(baseurl + version + removecart,
        body: {"proposal_id": productid}, headers: {'Auth': token});

    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == '1') {
      loginToast(message);
      datacart.clear();
      directcontent.clear();
      getData();
    } else {
      setState(() {
        loading = false;
      });
      loginToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }

  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print("index");
    print(token);
    setState(() {
      loading = true;
    });

    final responseData = await http
        .get(baseurl + version + cartpagelink, headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['cartDetails'] as List;
      var listsCArrs = jsonDecode(data)['content']['payments'] as List;
      print(listsCArr);
      if (listsCArr != null) {
        setState(() {
          for (Map i in listsCArr) {
            datacart.add(CartDetail.fromMap(i));
          }
          for (Map i in listsCArrs) {
            directcontent.add(Payment.fromMap(i));
          }
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );
      }
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (datacart.length != null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
          appBar:  AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () =>  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => MyHomePage(0))),
            ),
            elevation: 0.0,
          title: Container(
          width: MediaQuery.of(context).size.width/1.8,
    child: Center(child:Text("Cart")
    )
    ),
          ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.0),
                  itemCount: datacart.length,
                  itemBuilder: (BuildContext context, int index) {
                    final datavalue = datacart[index];
                    return loading
                        ? Center(
                        child: CircularProgressIndicator(
                            valueColor:
                            new AlwaysStoppedAnimation<Color>(primarycolor)))
                        : Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              right: 30.0, bottom: 10.0),
                          child: Material(
                            borderRadius:
                            BorderRadius.circular(5.0),
                            elevation: 3.0,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    child: Image.network(
                                        datacart[index]
                                            .proposalImage),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          datacart[index]
                                              .proposalTitle,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          datacart[index].price,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            datacart[index]
                                                .proposalQuantity == "2"
                                                ? new IconButton(
                                              icon: new Icon(Icons.remove,color: primarycolor,),
                                              onPressed: () => setState(() {
                                               String value = (int.parse(datacart[index].proposalQuantity)-1).toString();
                                                  addquenty(datacart[index]
                                                      .proposalId,
                                                      value);}),)
                                                : new Container(),
                                            new Text(datacart[index]
                                                .proposalQuantity ,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 18.0)),
                                            new IconButton(
                                                icon: new Icon(Icons.add,color: primarycolor),
                                                onPressed: () =>
                                                    setState(() {
                                                      String value = (int.parse(datacart[index].proposalQuantity)+1).toString();
                                                      addquenty(datacart[index].proposalId, value
                                                      );
                                                    }))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 15,
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(5.0)),
                              padding: EdgeInsets.all(0.0),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                print(datavalue.proposalId);
                                setState(() {
                                  delete(datavalue.proposalId);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              loading
                  ? Center(
                  child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(primarycolor)))
                  : Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Text(
                          "Sub Total Price",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ),
                        directcontent.isNotEmpty? Text(
                          directcontent[0].subTotalPrice,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ):Text(''),
                      ],),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Text(
                          "Processing Fee  ",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ),
                        directcontent.isNotEmpty?  Text(
                          directcontent[0].processingFee,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ):Text(''),
                      ],),

                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total Price",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ),
                        directcontent.isNotEmpty?  Text(
                          directcontent[0].totalPrice,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.0),
                        ):Text(''),
                      ],),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                            height: 50.0,
                            color: primarycolor,
                            child: Text(
                              "Checkout".toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => checkout( directcontent[0].paymentUrl, token)),
                              );
                            }))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    loading
                        ? Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                primarycolor)))
                        : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 30.0),
                        child: Text(
                          "CART",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        )),
                  ])));
    }
  }
}
