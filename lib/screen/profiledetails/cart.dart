import 'dart:convert';

import 'package:flutter/material.dart';
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
  var loading = true;
  String? token = "";
  bool isCartUpdating = false;

  addquenty(String? productid, String count, int index) async {
    setState(() {
      isCartUpdating = true;
    });

    final response = await http.post(Uri.parse(baseurl + version + changecart),
        body: {"proposal_id": productid, "proposal_qty": count},
        headers: {'Auth': token!});

    final data = jsonDecode(response.body);
    String? value = data['status'];
    String? message = data['message'];
    if (value == '1') {
      _itemCount = 0;
      loginToast("cart added");
      updateCartData(index);
      updatePaymentData();
    } else {
      loginToast(message!);
    }
  }

  delete(String? productid, int index) async {
    print(productid);

    setState(() {
      isCartUpdating = true;
    });

    final response = await http.post(Uri.parse(baseurl + version + removecart),
        body: {"proposal_id": productid}, headers: {'Auth': token!});

    final data = jsonDecode(response.body);
    String? value = data['status'];
    String? message = data['message'];
    if (value == '1') {
      setState(() {
        loginToast(message!);
        datacart.removeAt(index);
        updatePaymentData();
      });
    } else {
      loginToast(message!);
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

  getData() async {
    print("reacher $token");
    final responseData = await http.get(
        Uri.parse(baseurl + version + cartpagelink),
        headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['cartDetails'];
      final listsCArrs = jsonDecode(data)['content']['payments'];
      print(listsCArr);
      if (listsCArr != null) {
        setState(() {
          for (Map i in listsCArr) {
            datacart.add(CartDetail.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in listsCArrs) {
            directcontent.add(Payment.fromMap(i as Map<String, dynamic>));
          }
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  updateCartData(int index) async {
    final responseData = await http.get(
        Uri.parse(baseurl + version + cartpagelink),
        headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['cartDetails'];
      List<CartDetail> temp = [];
      for (Map i in listsCArr) {
        temp.add(CartDetail.fromMap(i as Map<String, dynamic>));
      }
      setState(() {
        datacart.removeAt(index);
        datacart.insert(index, temp[index]);
        isCartUpdating = false;
      });
    }
  }

  updatePaymentData() async {
    directcontent.clear();
    final responseData = await http.get(
        Uri.parse(baseurl + version + cartpagelink),
        headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArrs = jsonDecode(data)['content']['payments'];
      setState(() {
        for (Map i in listsCArrs) {
          directcontent.add(Payment.fromMap(i as Map<String, dynamic>));
        }
        isCartUpdating = false;
      });
    }
  }

  void initState() {
    super.initState();
    fetchToken();
  }

  void fetchToken() async {
    await SharedPreferences.getInstance().then((pref) {
      token = pref.getString("token");
      print("reacher $token");
      token == null ? onFetchTokenErr() : getData();
    }, onError: (err) => onFetchTokenErr());
  }

  void onFetchTokenErr() {
    setState(() {
      token = null;
      loading = false;
    });
  }

  showAlertDialog() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 500,
        child: Dialog(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("cart page came");
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage(0))),
          ),
          elevation: 0.0,
          title: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              child: Center(child: Text("Cart"))),
        ),
        body: datacart.isNotEmpty
            ? SafeArea(
                child: Stack(children: [
                Column(
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
                                          new AlwaysStoppedAnimation<Color>(
                                              primarycolor)))
                              : InkWell(
                                  onTap: () => {},
                                  child: Stack(
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
                                                          .proposalImage!),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        datacart[index]
                                                            .proposalTitle!,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        datacart[index].price!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          datacart[index]
                                                                      .proposalQuantity! !=
                                                                  '1'
                                                              ? new IconButton(
                                                                  icon:
                                                                      new Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color:
                                                                        primarycolor,
                                                                  ),
                                                                  onPressed: () =>
                                                                      setState(
                                                                          () {
                                                                    String
                                                                        value =
                                                                        (int.parse(datacart[index].proposalQuantity!) -
                                                                                1)
                                                                            .toString();
                                                                    addquenty(
                                                                        datacart[index]
                                                                            .proposalId,
                                                                        value,
                                                                        index);
                                                                  }),
                                                                )
                                                              : new Container(),
                                                          new Text(
                                                              datacart[index]
                                                                  .proposalQuantity!,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0)),
                                                          new IconButton(
                                                              icon: new Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      primarycolor),
                                                              onPressed:
                                                                  () =>
                                                                      setState(
                                                                          () {
                                                                        String
                                                                            value =
                                                                            (int.parse(datacart[index].proposalQuantity!) + 1).toString();
                                                                        addquenty(
                                                                            datacart[index].proposalId,
                                                                            value,
                                                                            index);
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
                                                      BorderRadius.circular(
                                                          5.0)),
                                              padding: EdgeInsets.all(0.0),
                                              color: Colors.red,
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              onPressed: () => delete(
                                                  datavalue.proposalId, index)),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        },
                      ),
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Sub Total Price",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16.0),
                                    ),
                                    directcontent.isNotEmpty
                                        ? Text(
                                            directcontent[0].subTotalPrice!,
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 16.0),
                                          )
                                        : Text(''),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Processing Fee  ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16.0),
                                    ),
                                    directcontent.isNotEmpty
                                        ? Text(
                                            directcontent[0].processingFee!,
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 16.0),
                                          )
                                        : Text(''),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Total Price",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16.0),
                                    ),
                                    directcontent.isNotEmpty
                                        ? Text(
                                            directcontent[0].totalPrice!,
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 16.0),
                                          )
                                        : Text(''),
                                  ],
                                ),
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
                                                builder: (context) => checkout(
                                                    directcontent[0].paymentUrl,
                                                    token)),
                                          );
                                        }))
                              ],
                            ),
                          )
                  ],
                ),
                isCartUpdating ? showAlertDialog() : Container()
              ]))
            : SafeArea(
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                primarycolor)))
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 30.0),
                        child: Center(
                          child: Text(
                            token == null
                                ? "Is seems you are not logged in!"
                                : "CART",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700),
                          ),
                        )),
              ));
  }
}
