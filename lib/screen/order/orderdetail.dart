import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/orderdetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/services/api.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class orderpage extends StatefulWidget {
  final String? orderid;
  final String? postTitle;
   //if you have multiple values add here
  orderpage(this.orderid,this.postTitle, {Key? key}) : super(key: key);

  @override
  _orderpageState createState() => _orderpageState();
}

class _orderpageState extends State<orderpage> {
  File? _file;
  ScrollController _scrollController = ScrollController();
  final _key = new GlobalKey<FormState>();
  Color myGreen = Color(0xff4bb17b);

  var textvalue;
  List<ODetail> listorder = [];
  List<ConversationArr> friendsLists = [];
  var loading = false;
  String? topimage;
  String? token = "";

  Future getFile() async {
    File? file = null;

    setState(() {
      _file = file;
    });
  }

  void _uploadFile(filePath) async {
    final form = _key.currentState!;
    form.save();

    print("textvalue");
    print(textvalue);
    print(filePath);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    setState(() {
      loading = true;
    });
    if (filePath != null) {
      String fileName = basename(filePath.path);
      print("file base name:$fileName");

      try {
        FormData formData = new FormData.fromMap({
          'order_id': widget.orderid,
          'message': textvalue,
          'file':
              await MultipartFile.fromFile(filePath.path, filename: fileName),
        });
        Response response = await Dio().post(
          baseurl + version + sendmsg,
          data: formData,
          options: Options(
            headers: {
              'Auth': token, // set content-length
            },
          ),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          setState(() {
            getData();
          });
        }
        // loading = false;
        print("File upload response: $response");

        print(response.data['message']);
      } catch (e) {
        print("expectation Caugch: $e");
      }
    } else {
      try {
        FormData formData = new FormData.fromMap({
          'order_id': widget.orderid,
          'message': textvalue,
          'file': '',
        });
        Response response = await Dio().post(
          baseurl + version + sendmsg,
          data: formData,
          options: Options(
            headers: {
              'Auth': token, // set content-length
            },
          ),
        );
        if (response.statusCode == 200) {
          setState(() {
            getData();
          });
        }
        //  loading = false;
        print("File upload response: $response");
        print(response.statusCode);
        print(response.data['message']);
      } catch (e) {
        print("expectation Caugch: $e");
      }
    }
  }

  Future<Null> getData() async {
    friendsLists.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);
    setState(() {
      loading = true;
    });
    final linkdata = widget.orderid;
    print(linkdata);
    print(baseurl + version + orderdetails);
    final responseData = await http.post(Uri.parse(baseurl + version + orderdetails),
        body: {'order_id': widget.orderid}, headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final friendsList = jsonDecode(data)['content']['conversationArr'];
      final listorders = jsonDecode(data)['content']['oDetails'];
      print(listorders);
      setState(() {
        _file = null;
        for (Map i in listorders) {
          listorder.add(ODetail.fromMap(i as Map<String, dynamic>));
        }
        for (Map i in friendsList) {
          friendsLists.add(ConversationArr.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.pixels);
  }

  @override
  void initState() {
       getData();
    _scrollController = ScrollController();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //toolbarHeight: 38,
          elevation: 6.0,
          foregroundColor: Colors.black,
          backgroundColor:  Colors.white,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            
            labelColor: Color.fromARGB(255, 87, 87, 87),
            indicatorWeight: 3,
            indicatorColor: Color.fromARGB(255, 169, 169, 169),
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: "Details"),
              Tab(text: "Chat"),
            ],
          ),
          title:  Container(child: Center(child: Text(widget.postTitle.toString()))),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(primarycolor)))
            : TabBarView(
                children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listorder.length,
                      itemBuilder: (context, i) {
                        final datacard = listorder[i];
                        return Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Text(
                                datacard.postTitle!,
                                style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 16,
                                ),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: Center(
                                      child: Image.network(datacard.postImage!),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Seller: ",
                                          style: TextStyle(
                                            color: primarycolor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          datacard.sellerName!,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Order id: ",
                                                  style: TextStyle(
                                                    color: primarycolor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "#" + datacard.orderNumber!,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                  elevation: 4,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    "Iteam",
                                                    style: TextStyle(
                                                      color: primarycolor,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    "Duration",
                                                    style: TextStyle(
                                                      color: primarycolor,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    "Price",
                                                    style: TextStyle(
                                                      color: primarycolor,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                //                   <--- left side
                                                color: Colors.black,
                                                width: 0.5,
                                              ),
                                              bottom: BorderSide(
                                                //                    <--- top side
                                                color: Colors.black,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 20),
                                                  child: Center(
                                                      child: Text(
                                                    datacard.postTitle!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    datacard.orderDuration!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    datacard.itemPrice!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                //                    <--- top side
                                                color: Colors.black,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 4),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Center(
                                                      child: Text(
                                                    "Processing",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 4),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5,
                                                  child:
                                                      Center(child: Text(""))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    datacard.orderFee!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    "Total",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child:
                                                      Center(child: Text(""))),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.6,
                                                  child: Center(
                                                      child: Text(
                                                    datacard.orderPrice!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primarycolor)))
                      : Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: friendsLists.length,
                                      controller: _scrollController,
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        final listcat = friendsLists[i];

                                        return ListTile(
                                          leading: Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(
                                                          listcat
                                                              .senderImage!)))),
                                          title: Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Text(
                                                        listcat.senderName!,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                        child: Text(
                                                      listcat.dateTime!,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                  ]),
                                                  Text(
                                                    listcat.message!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  listcat.filename != null &&
                                                          listcat.filetype ==
                                                              null
                                                      ? Text(
                                                          listcat.filename!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 0,
                                                        ),
                                                  listcat.filetype == "image"
                                                      ? Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: new BoxDecoration(
                                                              image: new DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: new NetworkImage(
                                                                      listcat
                                                                          .file!))))
                                                      : Container(
                                                          height: 0,
                                                        ),
                                                ],
                                              )),
                                          //subtitle: Text((listsubcat[i].subCategoryTitle[i])),
                                        );
                                      },
                                    ),
                                  ),
                                  Form(
                                      key: _key,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              //                   <--- top side
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 0.0,
                                            bottom: 0.0,
                                            right: 5.0,
                                            left: 5.0),
                                        margin: EdgeInsets.only(
                                            top: 5.0,
                                            bottom: 0.0,
                                            right: 0.0,
                                            left: 0.0),
                                        height: 100,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: TextFormField(
                                                        onSaved: (e) =>
                                                            textvalue = e,
                                                        style: TextStyle(
                                                          height: 1,
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontFamily:
                                                              'SophiaNubian',
                                                        ),
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                "Type a Message...",
                                                            border: InputBorder
                                                                .none),
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(Icons
                                                                      .attachment),
                                                                  color:
                                                                      primarycolor,
                                                                  onPressed:
                                                                      () {
                                                                    getFile();
                                                                  },
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                child: Text(
                                                                  "send",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color:
                                                                        primarycolor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        'SophiaNubian',
                                                                  ),
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                onPressed: () {
                                                                  _uploadFile(
                                                                      _file);
                                                                },
                                                              ),
                                                            ]))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}
