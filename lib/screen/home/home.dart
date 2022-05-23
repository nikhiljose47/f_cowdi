import 'package:flutter/material.dart';
import 'package:flutter_app/screen/cart_screen.dart';
import 'package:flutter_app/screen/details/catdetail.dart';
import 'package:flutter_app/screen/inbox/inboxdetail.dart';
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/managarequest/managarequest.dart';
import 'package:flutter_app/screen/manage/manage.dart';
import 'package:flutter_app/screen/profiledetails/checkout.dart';
import 'package:flutter_app/screen/profiledetails/contactus.dart';
import 'package:flutter_app/screen/profiledetails/profiledetails.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:flutter_app/util/propusal.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/util/home.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/screen/category/category.dart';
import 'package:flutter_app/ui/invitafriend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screen/category/detailsubcat.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:new_version/new_version.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Message {
  String? title;
  String? body;
  String? message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class _HomeState extends State<Home> {
  String? token = "";
  List<PService> listService = [];
  List<MPlace> listplaces = [];
  List<AppInfo> apiinforlist = [];
  List<RView> listreview = [];
  List<FProposal> firtlist = [];
  List<ODetail> customlist = [];
  List<Container> recent = [];
  var loading = false;
  String title = "Title";
  String helper = "helper";
  List<Message>? messagesList;
  List<PDetail> listdata = [];

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String? title = notification['title'];
    final String? body = notification['body'];
    String? mMessage = data['page'];
    print("Title: $title, body: $body, message: $mMessage");
    setState(() {
      if (mMessage == "inbox") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(1)));
      } else if (mMessage == "ordermessages") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => manageorder()));
      } else if (mMessage == "orders") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => manageorder()));
      } else if (mMessage == "notifications") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(2)));
      } else if (mMessage == "requests") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => manageeq()));
      } else if (mMessage == "proposals") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => manageeq()));
      } else if (mMessage == "accounts") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(4)));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(0)));
      }
    });
  }

  _configureFirebaseListeners() {
    // _firebaseMessaging.(
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //     return _setMessage(message);
    //   },
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //     return _setMessage(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //     return _setMessage(message);
    //   },

    // );
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool _seen = await preferences.setBool('seen', true);
    setState(() {
      token = preferences.getString("token");
      loading = true;
    });
    if (token == null) {
      print("token absent");
      final responseDataappinfo = await http.post(
          Uri.parse(baseurl + version + sitedetails),
          body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
      final responseData = await http.get(Uri.parse(baseurl + version + url));
      if (responseData.statusCode == 200) {
        final dataapinfo = responseDataappinfo.body;
        final data = responseData.body;

        final List<dynamic> listservices =
            jsonDecode(data)['content']['pServices'];
        final List<dynamic> listpalces = jsonDecode(data)['content']['mPlaces'];
        final List<dynamic> flistvalue =
            jsonDecode(data)['content']['fProposals'];
        final List<dynamic> datalist =
            jsonDecode(dataapinfo)['content']['app_info'];
        setState(() {
          for (Map i in datalist) {
            apiinforlist.add(AppInfo.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in listservices) {
            listService.add(PService.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in listpalces) {
            listplaces.add(MPlace.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in flistvalue) {
            firtlist.add(FProposal.fromMap(i as Map<String, dynamic>));
          }
          loading = false;
        });
      }
    } else {
      print("token present");
      final responseDataappinfo = await http.post(
          Uri.parse(baseurl + version + sitedetails),
          body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
      final responseData = await http
          .get(Uri.parse(baseurl + version + url), headers: {'Auth': token!});
      if (responseData.statusCode == 200) {
        final dataapinfo = responseDataappinfo.body;
        final data = responseData.body;
        final List<dynamic> listservices =
            jsonDecode(data)['content']['pServices'];
        final List<dynamic> listpalces = jsonDecode(data)['content']['mPlaces'];
        final List<dynamic> recent = jsonDecode(data)['content']['rViews'];
        final List<dynamic> flistvalue =
            jsonDecode(data)['content']['fProposals'];
        final List<dynamic> customervalue =
            jsonDecode(data)['content']['oDetails'];
        String? token = jsonDecode(data)['commonArr']['token'];
        final List<dynamic> datalist =
            jsonDecode(dataapinfo)['content']['app_info'];
        setState(() {
          for (Map i in customervalue) {
            customlist.add(ODetail.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in datalist) {
            apiinforlist.add(AppInfo.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in listservices) {
            listService.add(PService.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in listpalces) {
            listplaces.add(MPlace.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in recent) {
            listreview.add(RView.fromMap(i as Map<String, dynamic>));
          }
          for (Map i in flistvalue) {
            firtlist.add(FProposal.fromMap(i as Map<String, dynamic>));
          }
          loading = false;
        });
      }
    }
  }

  updateApp() async {
    final checkVersion = NewVersion(
        androidId: "com.cowdiar.mobileapp", iOSId: "com.cowdiar.mobileapp");
    final appStatus =
        await (checkVersion.getVersionStatus() as FutureOr<VersionStatus>);
    if (appStatus.canUpdate) {
      checkVersion.showUpdateDialog(context: context, versionStatus: appStatus);
      print("canUpdate ${appStatus.canUpdate}");
      print("localVersion ${appStatus.localVersion}");
      print("storeVersion ${appStatus.storeVersion}");
    } else {
      print('Update version');
    }
  }

  _setFavourite(List list, int index) {
    setState(() {
      list[index].isFavourite = list[index].isFavourite == 1 ? 0 : 1;
    });
  }

//Panggil Data / Call Data
  @override
  void initState() {
    print("xcxcxccxxc");
    super.initState();
    getData();
    //  updateApp();
    _firebaseMessaging.getToken().then((token) => print(token));
    //  _configureFirebaseListeners();
  }

    Future<List<PDetail>> getChatData(String link) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");

    if (token != null) {
      final linkdata = '/' + link;
      final responseData = await http
          .get(Uri.parse(baseurl + version + linkdata), headers: {'Auth': token!});
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
      final linkdata = '/' + link;
      final responseData = await http.get(Uri.parse(baseurl + version + linkdata));
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
    return listdata;
  }

  onChatClicked(String link) async {
    print("NIK-onchat");
    final data = await getChatData(link);
    final nplacesList = data[0];

    nplacesList.seller!.messagegroupid.toString().isNotEmpty && token != null
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Inboxdetailpage(listdata[0].seller!.messagegroupid,
                          listdata[0].seller!.sellerName);
                    },
                  ),
                )
              : token != null && listdata[0].seller!.messagegroupid.toString().isEmpty
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
  }

  Widget review(context) {
    if (token == null) {
      return SizedBox(height: 3.0);
    } else {
      return Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.00, bottom: 10),
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
                      itemCount: listreview.length,
                      itemBuilder: (context, i) {
                        final nplacesList = listreview[i];
                        String? statusin = nplacesList.onlineStatus;
                        return InkWell(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 5.00, top: 5.00, right: 5.00),
                            width: 250,
                            decoration: myBoxDecorationfirst(),
                            child: Column(children: <Widget>[
                              Container(
                                    height: 150,
                                    //chat button integrate with top Image
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: <Widget>[
                                        //Image
                                        Container(
                                          //height: 150,
                                          width: double.infinity,
                                          child: Image.network(
                                            nplacesList.postImage!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        //chat button
                                        Container(
                                          width: 90,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              color: Colors.white),
                                          child: SizedBox.expand(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.white,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  onSurface: Colors.white,
                                                  elevation: 100),
                                              onPressed: () => onChatClicked(nplacesList.link.toString()),
                                              child: Container(
                                                  child: Text(
                                                'Chat',
                                                style: TextStyle(
                                                  color: primarycolor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ),
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
                                    Expanded(
                                      child: Row(
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
                                                              .sellerImage!))),
                                              child: new Stack(
                                                children: <Widget>[
                                                  if (statusin == 'online')
                                                    new Positioned(
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: new Icon(
                                                        Icons
                                                            .fiber_manual_record,
                                                        size: 15.0,
                                                        color: primarycolor,
                                                      ),
                                                    ),
                                                  if (statusin == 'offline')
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
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 5.00),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(nplacesList
                                                          .sellerName!),
                                                      Text(nplacesList
                                                          .sellerLevel!),
                                                    ])),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                onPressed: () => _setFavourite(
                                                    listreview, i),
                                                icon: Icon(
                                                  Icons.favorite,
                                                  size: 18.0,
                                                  color:
                                                      nplacesList.isFavourite ==
                                                              1
                                                          ? Color.fromARGB(
                                                              255, 255, 166, 0)
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                          child: Text(
                                              nplacesList.title!.length > 25
                                                  ? nplacesList.title!
                                                          .substring(0, 25) +
                                                      "..."
                                                  : nplacesList.title!),
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
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return profiledetailpage(nplacesList.link, "home",
                                  "home", "home", "home");
                            }));
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

  Widget custorsec(context) {
    if (token == null) {
      return SizedBox(height: 3.0);
    } else {
      return customlist.length != 0
          ? Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.00, bottom: 0),
                        child: Text('My Custom Offers',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'SophiaNubian',
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, top: 8.00),
                        child: InkWell(
                            child: Text("See all",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primarycolor,
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => manageeq()));
                            }),
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
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      primarycolor)))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              itemCount: customlist.length,
                              itemBuilder: (context, i) {
                                final nplacesList = customlist[i];
                                String? statusin = nplacesList.onlineStatus;
                                return InkWell(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5.00, top: 10.00, right: 5.00),
                                      height: 200,
                                      width: 280,
                                      decoration: myBoxDecorationfirst(),
                                      child: Column(children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10.00,
                                              right: 10.00,
                                              top: 10.00),
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
                                                          shape:
                                                              BoxShape.circle,
                                                          image: new DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: new NetworkImage(
                                                                  nplacesList
                                                                      .sellerImage!))),
                                                      child: new Stack(
                                                        children: <Widget>[
                                                          if (statusin ==
                                                              'online')
                                                            new Positioned(
                                                              right: 0.0,
                                                              bottom: 0.0,
                                                              child: new Icon(
                                                                Icons
                                                                    .fiber_manual_record,
                                                                size: 15.0,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          if (statusin ==
                                                              'offline')
                                                            new Positioned(
                                                              right: 0.0,
                                                              bottom: 0.0,
                                                              child: new Icon(
                                                                Icons
                                                                    .fiber_manual_record,
                                                                size: 15.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                        ],
                                                      )),
                                                  new Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5.00),
                                                    child: new Text(nplacesList
                                                        .sellerName!),
                                                  ),
                                                ],
                                              ),
                                              Row(children: <Widget>[
                                                new Container(
                                                  child: new Text(
                                                    nplacesList.offerBudget!,
                                                    style: TextStyle(
                                                      color: primarycolor,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10.00,
                                              right: 10.00,
                                              top: 10.00),
                                          child: Column(children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: 80,
                                                  height: 50,
                                                  decoration:
                                                      myBoxDecorationfirst(),
                                                  child: Image.network(
                                                      nplacesList.offerImage!,
                                                      fit: BoxFit.cover),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0, top: 5),
                                                    child: Text(nplacesList
                                                                .offerDescription!
                                                                .length >
                                                            45
                                                        ? nplacesList
                                                                .offerDescription!
                                                                .substring(
                                                                    0, 45) +
                                                            "..."
                                                        : nplacesList
                                                            .offerDescription!),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10.00,
                                                right: 10.00,
                                                top: 20.00,
                                                bottom: 20.00),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Delivery " +
                                                    nplacesList.offerDuration!),
                                              ],
                                            )),
                                        Divider(
                                          color: Colors.black26,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Column(children: <Widget>[
                                              Text(
                                                "Offer valid at all time. Lucky you! ",
                                                textAlign: TextAlign.right,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, top: 10.0),
                                                child: Row(children: <Widget>[
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15, right: 10),
                                                      child: Column(children: <
                                                          Widget>[
                                                        RaisedButton(
                                                          color:
                                                              Colors.lightGreen,
                                                          textColor:
                                                              Colors.white,
                                                          padding: EdgeInsets
                                                              .fromLTRB(10, 10,
                                                                  10, 10),
                                                          splashColor:
                                                              Colors.grey,
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      5.0)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Inboxdetailpage(
                                                                      nplacesList
                                                                          .messagegroupid,
                                                                      nplacesList
                                                                          .sellerName);
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                              'OPEN IN CHAT',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    1,
                                                              )),
                                                        ),
                                                      ])),
                                                  RaisedButton(
                                                    color: primarycolor,
                                                    textColor: Colors.white,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 10),
                                                    splashColor: Colors.grey,
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    5.0)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return checkout(
                                                                nplacesList
                                                                    .checkouturl,
                                                                token);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Text('REVIEW',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                        )),
                                                  ),
                                                ]),
                                              )
                                            ]))
                                      ])),
                                  onTap: () {},
                                );
                              },
                            ))
                ]),
              ],
            )
          : Container();
    }
  }

  Widget topview(context) {
    return firtlist.length != 0
        ? Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 10.00, bottom: 10),
                  child: Text('Top Featured Proposals/Services',
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
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primarycolor)))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          itemCount: firtlist.length,
                          itemBuilder: (context, i) {
                            final nplacesList = firtlist[i];
                            String? statusin = nplacesList.onlineStatus;

                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 5.00, top: 5.00, right: 5.00),
                                width: 250,
                                decoration: myBoxDecorationfirst(),
                                child: Column(children: <Widget>[
                                  Container(
                                    height: 150,
                                    //chat button integrate with top Image
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: <Widget>[
                                        //Image
                                        Container(
                                          //height: 150,
                                          width: double.infinity,
                                          child: Image.network(
                                            nplacesList.postImage!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        //chat button
                                        Container(
                                          width: 90,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              color: Colors.white),
                                          child: SizedBox.expand(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.white,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  onSurface: Colors.white,
                                                  elevation: 100),
                                              onPressed: () => onChatClicked(nplacesList.link.toString()),
                                              child: Container(
                                                  child: Text(
                                                'Chat',
                                                style: TextStyle(
                                                  color: primarycolor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ),
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
                                        Expanded(
                                          child: Row(
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
                                                                  .sellerImage!))),
                                                  child: new Stack(
                                                    children: <Widget>[
                                                      if (statusin == 'online')
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
                                                      if (statusin == 'offline')
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
                                              Expanded(
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5.00),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(nplacesList
                                                              .sellerName!),
                                                          Text(nplacesList
                                                              .sellerLevel!),
                                                        ])),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        _setFavourite(
                                                            firtlist, i),
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      size: 18.0,
                                                      color: nplacesList
                                                                  .isFavourite ==
                                                              1
                                                          ? Color.fromARGB(
                                                              255, 255, 166, 0)
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: 10.00, left: 10.00),
                                    child: Column(children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, top: 5),
                                              child: Text(
                                                  nplacesList.title!.length > 25
                                                      ? nplacesList.title!
                                                              .substring(
                                                                  0, 25) +
                                                          "..."
                                                      : nplacesList.title!),
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
                                                padding:
                                                    EdgeInsets.only(left: 10),
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
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                ),
            icon: Icon(Icons.shopping_cart)),
        title: apiinforlist.length != 0
            ? Image.network(
                apiinforlist[0].appLogo!,
                width: 100,
                height: 100,
              )
            : Text(""),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: new Image.asset('assets/icons/cat.png',
                width: 20, height: 20, fit: BoxFit.fill),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => category()),
              );
            },
          ),
        ],
      ),
      body: WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () => Future.value(false)
        //return a `Future` with false value so this route cant be popped or closed.
        ,
        child: ListView(children: [
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.00, right: 20.00, top: 10.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(10.0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.00),
                          //width: 280,
                          height: 45,

                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.search,
                                size: 20.0,
                                color: Colors.black,
                              ),
                              new Text("  What are you looking for?"),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(2),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(right: 10.00),
                          height: 45,
                          child: Row(
                            children: <Widget>[],
                          ),
                        ),
                        onTap: () {
                          print("Container was tapped");
                        },
                      ),
                    ]),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.00, bottom: 5),
              child: Text('Popular Professional Services',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'SophiaNubian',
                  )),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 15.0, top: 10.00, bottom: 10),
              child: InkWell(
                  child: Text("See all",
                      style: TextStyle(
                        fontSize: 16,
                        color: primarycolor,
                      )),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => category()));
                  }),
            ),
          ]),
          Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 15, top: 10.00),
              //alignment: FractionalOffset(1.0, 1.0),
              width: MediaQuery.of(context).size.width,
              height: 220,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(primarycolor)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      itemCount: listService.length,
                      itemBuilder: (context, i) {
                        final nDataList = listService[i];
                        return InkWell(
                          child: Container(
                            // alignment: Alignment(-1.0, -1.0),
                            padding: EdgeInsets.only(top: 0, left: 10),
                            height: 220,
                            width: 120,
                            child: Container(
                              constraints: new BoxConstraints.expand(
                                height: 200.0,
                              ),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: new DecorationImage(
                                  image: new NetworkImage(nDataList.image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(top: 0),
                                  alignment: Alignment(0.0, -0.7),
                                  child: Text(
                                    nDataList.title!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return catdetail(nDataList.link,
                                      nDataList.title, "home", "home");
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 10.00, bottom: 10),
              child: Text('Explore The Marketplace',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'SophiaNubian',
                  )),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 15.0, top: 10.00, bottom: 10),
              child: InkWell(
                  child: Text("See all",
                      style: TextStyle(
                        fontSize: 16,
                        color: primarycolor,
                      )),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => category()));
                  }),
            ),
          ]),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 0, top: 5),
                // alignment: FractionalOffset(1.0, 1.0),
                width: MediaQuery.of(context).size.width,
                height:
                    Theme.of(context).textTheme.displayLarge!.fontSize! * 1.1 +
                        25,
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                primarycolor)))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        itemCount: listplaces.length,
                        itemBuilder: (context, i) {
                          final nplacesList = listplaces[i];
                          print(nplacesList.image!.length);
                          return GestureDetector(
                            child: Container(
                              // alignment: Alignment(0.0, 0.0),
                              padding: EdgeInsets.only(top: 0, left: 10),
                              height: 150,
                              width: 110,
                              child: Container(
                                constraints: new BoxConstraints.expand(
                                  height: 150.0,
                                ),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.3),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: 10.0, top: 20.0),
                                    alignment: Alignment(0.0, 1.0),
                                    child: Column(
                                      children: <Widget>[
                                        Image(
                                          image: new NetworkImage(
                                            nplacesList.image != null
                                                ? nplacesList.image!
                                                : "https://www.cowdiar.com//cat_images/p8.png",
                                          ),
                                          width: 50,
                                          height: 50,
                                        ),
                                        Container(
                                          width: 80,
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            nplacesList.title!.length > 21
                                                ? nplacesList.title!
                                                    .substring(0, 21)
                                                : nplacesList.title!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return subcatDetails(
                                        nplacesList.link, nplacesList.title);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          custorsec(context),
          topview(context),
          review(context),
          invitePage(),
        ]),
      ),
    );
  }
}
