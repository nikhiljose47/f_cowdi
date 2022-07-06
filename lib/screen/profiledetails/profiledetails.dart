import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/screen/details/catdetail.dart';
import 'package:flutter_app/screen/inbox/inboxdetail.dart';
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/screen/profiledetails/cart.dart';
import 'package:flutter_app/screen/profiledetails/contactus.dart';
import 'package:flutter_app/util/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/util/propusal.dart';
import 'package:flutter_app/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/screen/custom_expansion_tile.dart' as custom;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/screen/mainscreen.dart';

class profiledetailpage extends StatefulWidget {
  final String? links,
      sublink,
      title,
      pretitle,
      prelink; //if you have multiple values add here
  profiledetailpage(
      this.links, this.sublink, this.title, this.prelink, this.pretitle,
      {Key? key})
      : super(key: key);

  @override
  _profiledetailpageState createState() => _profiledetailpageState();
}

class _profiledetailpageState extends State<profiledetailpage> {
  List<PDetail> listdata = [];
  List<Faq> listfaq = [];
  List<Review> listreview = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String>? imageslist;
  VoidCallback? _showPersBottomSheetCallBack;
  bool isExpanded = false;
  var loading = false;
  String? token = "";
  List<RView> listreviews = [];
  bool readmore = true;
  bool readless = false;
  var descriptionLength;

  myBoxDecorationfirst() {
    return BoxDecoration(
        color: Colors.white,
        border: new Border.all(
            color: Colors.grey, width: 0.5, style: BorderStyle.solid),
        borderRadius: new BorderRadius.all(new Radius.circular(10.0)));
  }

  addcart(String? package, String? product, String quenty) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    setState(() {
      loading = true;
    });

    final response = await http.post(Uri.parse(baseurl + version + addcartpage),
        body: {
          "proposal_id": package,
          "package_id": product,
          "proposal_qty": quenty
        },
        headers: {
          'Auth': token!
        });
    print(baseurl + version + addcartpage);
    print(response);
    print(package);
    print(product);
    print(quenty);
    print(token);

    final data = jsonDecode(response.body);
    print(data);
    String? value = data['status'];
    print(value);
    String? message = data['long_message'];
    if (value == '1') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return cart();
          },
        ),
      );
    } else {
      setState(() {
        loading = false;
      });
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

  Future<Null> reviewgetData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    setState(() {
      loading = true;
    });

    if (token == null) {
    } else {
      final responseData = await http
          .get(Uri.parse(baseurl + version + url), headers: {'Auth': token!});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        final recents = jsonDecode(data)['content']['rViews'];
        setState(() {
          for (Map i in recents) {
            listreviews.add(RView.fromMap(i as Map<String, dynamic>));
          }

          loading = false;
        });
      }
    }
  }

  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    setState(() {
      loading = true;
    });

    if (token != null) {
      final linkdata = '/' + widget.links!;
      final responseData = await http.get(
          Uri.parse(baseurl + version + linkdata),
          headers: {'Auth': token!});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        print(baseurl + version + linkdata);
        print(token);
        print(data);
        var listsCArr = jsonDecode(data)['content']['pDetails'];
        setState(() {
          for (Map i in listsCArr) {
            listdata.add(PDetail.fromMap(i as Map<String, dynamic>));
          }
          loading = false;
        });
      }
    } else {
      final linkdata = '/' + widget.links!;
      final responseData =
          await http.get(Uri.parse(baseurl + version + linkdata));
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        final listsCArr = jsonDecode(data)['content']['pDetails'];
        //var listfaqs = jsonDecode(data)['content']['pDetails']['faqs'] as List;

        setState(() {
          for (Map i in listsCArr) {
            listdata.add(PDetail.fromMap(i as Map<String, dynamic>));
          }

          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    reviewgetData();
    _showPersBottomSheetCallBack = _showBottomSheet;
    getData();
    super.initState();
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState!
        .showBottomSheet(
          (context) {
            return SingleChildScrollView(
              child: Container(

                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(103, 212, 224, 236),),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Container(
                      height: 5,
                      width: 40,
                      color: Colors.grey,
                      margin: EdgeInsets.only(bottom: 20, top: 10),
                    )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment(-1.0, -1.0),
                      padding: EdgeInsets.only(
                          left: 10.00, right: 10.00, top: 10.00, bottom: 5.00),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  listdata[0]
                                                      .seller!
                                                      .sellerImage!))),
                                      child: new Stack(
                                        children: <Widget>[
                                          if (listdata[0]
                                                  .seller!
                                                  .onlineStatus ==
                                              'online')
                                            new Positioned(
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new Icon(
                                                Icons.fiber_manual_record,
                                                size: 15.0,
                                                color: Colors.green,
                                              ),
                                            ),
                                          if (listdata[0]
                                                  .seller!
                                                  .onlineStatus ==
                                              'offline')
                                            new Positioned(
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new Icon(
                                                Icons.fiber_manual_record,
                                                size: 15.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      )),
                                  new Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    padding: EdgeInsets.only(left: 10.00),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: new Text(
                                                      listdata[0]
                                                          .seller!
                                                          .sellerName!,
                                                      style: TextStyle(),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                Container(
                                                    width: 100.0,
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.orange,
                                                          size: 16.0,
                                                        ),
                                                        new Text(
                                                          listdata[0]
                                                              .rating!
                                                              .averageRatting!,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        new Text(
                                                          " (" +
                                                              listdata[0]
                                                                  .rating!
                                                                  .totalReviews! +
                                                              ")",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text("User Information"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(left: 10.00),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: new Text(
                                                  "Seller Level",
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      listdata[0]
                                                          .seller!
                                                          .sellerLevel!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(left: 10.00),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: new Text(
                                                  "Location",
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      listdata[0]
                                                          .seller!
                                                          .sellerCountry!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.folder_open,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(left: 10.00),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: new Text(
                                                  "Recent Delivery",
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      listdata[0]
                                                          .seller!
                                                          .recentDelivery!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.date_range,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(left: 10.00),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: new Text(
                                                  "Seller Since",
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      listdata[0]
                                                          .seller!
                                                          .sellerSince!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(left: 10.00),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: new Text(
                                                  "Seller Last Activity",
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      listdata[0]
                                                          .seller!
                                                          .sellerLastActivity!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 1,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  left: 15.00,
                                  right: 10.00,
                                  top: 0.00,
                                  bottom: 10.00),
                              child: Text(
                                "Description",
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  left: 15.00,
                                  right: 10.00,
                                  top: 0.00,
                                  bottom: 10.00),
                              child: listdata[0]
                                          .seller!
                                          .sellerDescription!
                                          .length >=
                                      200
                                  ? Text(
                                      listdata[0]
                                          .seller!
                                          .sellerDescription!
                                          .substring(0, 200),
                                    )
                                  : Text(
                                      listdata[0].seller!.sellerDescription!,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  Widget expendableList() {
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listfaq.length.compareTo(0),
      itemBuilder: (context, i) {
        final datapass = listdata[i];
        return new custom.ExpansionTile(
          headerBackgroundColor: Colors.white,
          iconColor: isExpanded ? primarycolor : Colors.black,
          title: new Text(
            "Frequently Asked Questions",
            style: new TextStyle(
              color: isExpanded ? primarycolor : Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            new Column(
              children: <Widget>[
                new ListTile(
                  title: Text(datapass.faqs![i].question!),
                  subtitle: Text(datapass.faqs![i].answer!),
                )
              ],
            ),
          ],
          onExpansionChanged: (bool expanding) =>
              setState(() => this.isExpanded = expanding),
        );
      },
    );
  }

  Widget reviewexpendableList() {
    return listdata[0].reviews!.length == 0
        ? Container()
        : new custom.ExpansionTile(
            headerBackgroundColor: Colors.white,
            iconColor: isExpanded ? primarycolor : Colors.black,
            title: new Text(
              "Reviews",
              style: new TextStyle(
                color: isExpanded ? primarycolor : Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listdata[0].reviews!.length.compareTo(0),
                      itemBuilder: (context, index) {
                        final datapass = listdata[0].reviews![index];

                        return Container(
                          alignment: Alignment(-1.0, -1.0),
                          padding: EdgeInsets.only(
                              left: 10.00,
                              right: 10.00,
                              top: 10.00,
                              bottom: 5.00),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                      datapass.buyerImage!)))),
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        padding: EdgeInsets.only(left: 10.00),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: new Text(
                                                      datapass.buyerName!,
                                                      style: TextStyle(),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 16.0,
                                                    ),
                                                    Container(
                                                      child: new Text(
                                                          datapass.buyerRating!,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 0),
                                                ),
                                                Container(
                                                  child: new Text(
                                                      datapass.reviewDate!,
                                                      textAlign:
                                                          TextAlign.right),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 25.00),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: new Text(datapass.buyerReview!,
                                    textAlign: TextAlign.left),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ],
            onExpansionChanged: (bool expanding) =>
                setState(() => this.isExpanded = expanding),
          );
  }

  Widget review(context) {
    if (token == null) {
      return SizedBox(height: 3.0);
    } else {
      return Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 0.00),
              child: Text('Recently Viewes & more',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'SophiaNubian',
                  )),
            ),
          ]),
          Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              // alignment: FractionalOffset(1.0, 1.0),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(primarycolor)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      itemCount: listreviews.length,
                      itemBuilder: (context, i) {
                        final nplacesList = listreviews[i];
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 5.00, top: 5.00, right: 5.00),
                            width: 250,
                            decoration: myBoxDecorationfirst(),
                            child: Column(children: <Widget>[
                              Container(
                                height: 150,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      //height: 150,
                                      width: double.infinity,
                                      child: Image.network(
                                        nplacesList.postImage!,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10.00,
                                    right: 10.00,
                                    top: 10.00,
                                    bottom: 5.00),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        nplacesList
                                                            .sellerImage!)))),
                                        new Container(
                                          padding: EdgeInsets.only(left: 5.00),
                                          child:
                                              new Text(nplacesList.sellerName!),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(right: 10.00, left: 10.00),
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 5),
                                          child: Text(nplacesList.sellerLevel!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 10.00, left: 10.00, top: 10.00),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(children: <Widget>[
                                              Text(
                                                "From ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: primarycolor,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                "${nplacesList.price}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: primarycolor,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                            ])),
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                      new Container(
                                          child: Row(children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.orangeAccent,
                                        ),
                                        Text(
                                          "${nplacesList.rating!.averageRatting}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.orangeAccent,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "(${nplacesList.rating!.totalReviews})",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black38,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                        ),
                                      ])),
                                    ]),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return profiledetailpage(nplacesList.link,
                                      "home", "home", "home", "home");
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ]),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
          : listdata.length != 0
              ? ListView(
                  children: [
                    Column(
                      children: <Widget>[
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: new NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listdata.length.compareTo(0),
                          itemBuilder: (context, i) {
                            print("titleh");
                            // print(listdata[0].title.length < 30? listdata[0].title.length : listdata[0].title.substring(0, 30).length + listdata[0].description.length < 62? listdata[0].description.length: listdata[0].description.substring(0,62).length);
                            final datapass = listdata[i];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 0.0),
                                    color: Colors.white,
                                    height: 200,
                                    child: datapass.images!.length != 1 &&
                                            datapass.images!.length != null
                                        ? CarouselSlider.builder(
                                            itemCount: datapass.images!.length,
                                            itemBuilder: (context, index, i) {
                                              return Container(
                                                  child: Image.network(
                                                datapass.images![index],
                                                fit: BoxFit.cover,
                                                width: 350,
                                                height: 260,
                                              ));
                                            },
                                            options: CarouselOptions(
                                              height: 400,
                                              //aspectRatio: 16/9,
                                              viewportFraction: 0.8,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: false,
                                              autoPlayInterval:
                                                  Duration(seconds: 5),
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              scrollDirection: Axis.horizontal,
                                            ))
                                        : datapass.images!.length != null
                                            ? Container(
                                                child: Image.network(
                                                datapass.images![0],
                                                fit: BoxFit.fill,
                                                width: 350,
                                                height: 260,
                                              ))
                                            : Container(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // BoxShape.circle or BoxShape.retangle
                                        color: primarycolor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: wavesecond!,
                                            blurRadius: 15.0,
                                          ),
                                        ]),
                                    // padding: EdgeInsets.only(left: 10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 20.0),

                                    child: widget.sublink == "home"
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return MyHomePage(0);
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : widget.sublink == "search"
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return MyHomePage(2);
                                                      },
                                                    ),
                                                  );
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return catdetail(
                                                            widget.sublink,
                                                            widget.title,
                                                            widget.pretitle,
                                                            widget.prelink);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                  ),
                                ]),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1,
                                  alignment: Alignment(-1.0, -1.0),
                                  padding: EdgeInsets.only(
                                      left: 10.00,
                                      right: 10.00,
                                      top: 10.00,
                                      bottom: 5.00),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(
                                                          datapass.seller!
                                                              .sellerImage!))),
                                              child: new Stack(
                                                children: <Widget>[
                                                  if (datapass.seller!
                                                          .onlineStatus ==
                                                      'online')
                                                    new Positioned(
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: new Icon(
                                                        Icons
                                                            .fiber_manual_record,
                                                        size: 15.0,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  if (datapass.seller!
                                                          .onlineStatus ==
                                                      'offline')
                                                    new Positioned(
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: new Icon(
                                                        Icons
                                                            .fiber_manual_record,
                                                        size: 15.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                ],
                                              )),
                                          new Container(
                                            padding:
                                                EdgeInsets.only(left: 10.00),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: new Text(
                                                      datapass
                                                          .seller!.sellerName!,
                                                      style: TextStyle(),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                Container(
                                                    child: new Text(datapass
                                                        .seller!.sellerLevel!)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        onPressed: _showPersBottomSheetCallBack,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment(-1.0, -1.0),
                                  padding: EdgeInsets.only(
                                      left: 10.00,
                                      right: 10.00,
                                      top: 10.00,
                                      bottom: 5.00),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(left: 10.00),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: datapass.title!.length >=
                                                        30
                                                    ? Text(
                                                        datapass.title!
                                                                .substring(
                                                                    0, 30) +
                                                            "...",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )
                                                    : Text(
                                                        datapass.title!,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.90,
                                              child: datapass.description!
                                                          .length >=
                                                      62
                                                  ? Wrap(
                                                      children: [
                                                        Text(readmore
                                                            ? datapass
                                                                    .description!
                                                                    .substring(
                                                                        0, 62) +
                                                                '...'
                                                            : ''),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              readmore = false;
                                                              descriptionLength =
                                                                  datapass
                                                                      .description!
                                                                      .length;
                                                            });
                                                          },
                                                          child: Text(
                                                            readmore
                                                                ? 'Read More'
                                                                : datapass
                                                                    .description!,
                                                            style: TextStyle(
                                                                color: readmore
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  // ? Text.rich(TextSpan(
                                                  //     text: readmore?datapass
                                                  //             .description
                                                  //             .substring(
                                                  //                 0, 62) +
                                                  //         '...':'',
                                                  //     children: <
                                                  //         TextSpan>[
                                                  //         TextSpan(
                                                  //             text: readmore
                                                  //                 ? 'Read More'
                                                  //                 : datapass
                                                  //                     .description,
                                                  //             style: TextStyle(
                                                  //                 color: readmore? Colors
                                                  //                     .red:Colors.black),
                                                  //             recognizer:
                                                  //                 new TapGestureRecognizer()
                                                  //                   ..onTap =
                                                  //                       () {
                                                  //               setState(() {
                                                  //                 descriptionLength = datapass.description.length;
                                                  //               });
                                                  //               print(datapass.description.length);
                                                  //               print('jj');
                                                  //                     setState(() {
                                                  //                       readmore = false;
                                                  //                     });
                                                  //                   }),
                                                  //       ]))
                                                  : Text(
                                                      datapass.description!,
                                                    ),
                                            ),
                                            readmore
                                                ? Container()
                                                : InkWell(
                                                    onTap: () {
                                                      print('dbf');
                                                      setState(() {
                                                        readmore = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text(
                                                        'Read Less',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        DefaultTabController(
                          length: 3,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: Column(
                              children: <Widget>[
                                TabBar(
                                  labelColor: Colors.white,
                                  unselectedLabelColor: primarycolor,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: primarycolor),
                                  tabs: <Widget>[
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![0]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![1]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![2]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .pPackages![0]
                                                        .packageName!,
                                                    textAlign: TextAlign.left,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                              .pPackages![0]
                                                              .description!
                                                              .length >
                                                          30
                                                      ? listdata[0]
                                                              .pPackages![0]
                                                              .description!
                                                              .substring(
                                                                  0, 30) +
                                                          '...'
                                                      : listdata[0]
                                                          .pPackages![0]
                                                          .description!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Revisions"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .revisions!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .deliveryTime!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .price!)
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: FlatButton(
                                                      child: Text('Log In '),
                                                      color: primarycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: FlatButton(
                                                      child: Text(
                                                          'Add To Cart ' +
                                                              listdata[0]
                                                                  .pPackages![0]
                                                                  .price!),
                                                      color: primarycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId,
                                                              listdata[0]
                                                                  .pPackages![0]
                                                                  .packageId,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .packageName!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                              .pPackages![1]
                                                              .description!
                                                              .length >
                                                          20
                                                      ? listdata[0]
                                                              .pPackages![1]
                                                              .description!
                                                              .substring(
                                                                  0, 21) +
                                                          '...'
                                                      : listdata[0]
                                                          .pPackages![1]
                                                          .description!)
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(top: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Revisions"),
                                                  listdata[0]
                                                              .pPackages![1]
                                                              .revisions!
                                                              .length ==
                                                          0
                                                      ? Text("--")
                                                      : Text(listdata[0]
                                                          .pPackages![1]
                                                          .revisions!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .deliveryTime!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .price!)
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: FlatButton(
                                                      child: Text('Log In '),
                                                      color: primarycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: FlatButton(
                                                      child: Text(
                                                          'Add To Cart ' +
                                                              listdata[0]
                                                                  .pPackages![1]
                                                                  .price!),
                                                      color: primarycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId,
                                                              listdata[0]
                                                                  .pPackages![1]
                                                                  .packageId,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .packageName!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                              .pPackages![2]
                                                              .description!
                                                              .length >
                                                          38
                                                      ? listdata[0]
                                                              .pPackages![2]
                                                              .description!
                                                              .substring(
                                                                  0, 38) +
                                                          '...'
                                                      : listdata[0]
                                                          .pPackages![2]
                                                          .description!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Revisions"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .revisions!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .deliveryTime!)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .price!)
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: FlatButton(
                                                      child: Text('Log In '),
                                                      color: primarycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: FlatButton(
                                                      child: Text(
                                                          'Add To Cart ' +
                                                              listdata[0]
                                                                  .pPackages![2]
                                                                  .price!),
                                                      color: primarycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId,
                                                              listdata[0]
                                                                  .pPackages![2]
                                                                  .packageId,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : Container(
                            child: expendableList(),
                          ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : Container(
                            child: reviewexpendableList(),
                          ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : listdata[0].reviews!.length != 0
                            ? SizedBox(
                                height: 20,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                    review(context),
                  ],
                )
              : Center(
                  child: Text(
                  "Loading..",
                  style: TextStyle(fontSize: 20, color: primarycolor),
                )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          listdata[0].seller!.messagegroupid.toString().isNotEmpty &&
                  token != null
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Inboxdetailpage(
                          listdata[0].seller!.messagegroupid,
                          listdata[0].seller!.sellerName,
                          listdata[0].seller!.sellerImage);
                    },
                  ),
                )
              : token != null &&
                      listdata[0].seller!.messagegroupid.toString().isEmpty
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return contactdetailpage(listdata[0].seller!.sellerId,
                              listdata[0].seller!.sellerName);
                        },
                      ),
                    )
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login("loginfull"),
                      ),
                    );
        },
        label: loading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(primarycolor)))
            : listdata.length != 0
                ? Container(
                    padding: EdgeInsets.all(0.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(right: 15),
                            width: 30.0,
                            height: 30.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        listdata[0].seller!.sellerImage!))),
                            child: new Stack(
                              children: <Widget>[
                                if (listdata[0].seller!.onlineStatus ==
                                    'online')
                                  new Positioned(
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: new Icon(
                                      Icons.fiber_manual_record,
                                      size: 15.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                if (listdata[0].seller!.onlineStatus ==
                                    'offline')
                                  new Positioned(
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: new Icon(
                                      Icons.fiber_manual_record,
                                      size: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Chat',
                              style: TextStyle(
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                      ],
                    ))
                : Text("Log in"),
        backgroundColor: Colors.white,
      ),
    );
  }
}
