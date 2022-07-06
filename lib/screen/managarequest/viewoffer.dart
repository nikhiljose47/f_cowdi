import 'package:flutter/material.dart';
import 'package:flutter_app/util/viewoffer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class viewoffer extends StatefulWidget {
  final String orderid;//if you have multiple values add here
  viewoffer(this.orderid, {Key? key}): super(key: key);
  @override
  _viewofferState createState() => _viewofferState();
}
class _viewofferState extends State<viewoffer> {
  List<RDetail> offerlistdata = [];
  List<ODetail> productlistdata = [];
  String? token = "";
  var loading = false;
  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);
    setState(() {
      loading = true;
    });
    print(baseurl + version  + manage);
    final responseData = await http.post(Uri.parse(baseurl + version  + viewofferlink ),
        body: {"request_id": widget.orderid},
        headers: {'Auth': token!}
    );
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['statusArr'];
      final offerdetails = jsonDecode(data)['content']['rDetails'];
      final productdetails = jsonDecode(data)['content']['oDetails'];
      print(offerdetails);
      setState(() {
        for (Map i in offerdetails) {
          offerlistdata.add(RDetail.fromMap(i as Map<String, dynamic>));
        }
        for (Map i in productdetails) {
          productlistdata.add(ODetail.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });

    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title:Container(
        width: MediaQuery.of(context).size.width/1.6,
    child: Center(child: Text("View Offers"))
    ),
    ),
    body: ListView(
    children: <Widget>[
        SingleChildScrollView(
            child:  Center(
              child: loading
                  ? Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 70, top: 8.00),
                  //alignment: FractionalOffset(1.0, 1.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.1,
                  child: Center( child: CircularProgressIndicator())
              ):
        Column(
        children: <Widget>[
        Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 10, top: 8.00),
              //alignment: FractionalOffset(1.0, 1.0),
              width: MediaQuery.of(context).size.width,
              height: offerlistdata.isEmpty && offerlistdata.isEmpty ? 1:MediaQuery.of(context).size.height/3.1,
              child:  ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: offerlistdata.length,
                  itemBuilder: (context, i) {
                    final datacard2 = offerlistdata[i];
                    return Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration:BoxDecoration(
                          border: Border.all(
                            color: primarycolor,
                            width: 2,
                          ),

                        ),
                        margin:  EdgeInsets.only(left: 10, right: 10,bottom: 8),
                        child: GestureDetector(
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context).size.width/1.2,
                                                margin:  EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                child: Center(child: Text("Request Description"))
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    margin:  EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                    child: Text(datacard2.requestTitle!)),

                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    margin:  EdgeInsets.only(bottom: 8),
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    child: Text("Request Budget: "+datacard2.requestBudget!)),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    margin:  EdgeInsets.only(bottom: 8),
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    child: Text("Request Date: "+datacard2.requestDate!)),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    margin:  EdgeInsets.only(bottom: 8),
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    child: Text("Request Duration: "+datacard2.requestDuration!)),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    margin:  EdgeInsets.only(bottom: 8),
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    child: Text("Request Category: "+datacard2.requestCategory!)),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          onTap: () {
                          },
                        )
                    );
                  }
              )
        ),
          Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 70, top: 8.00),
                //alignment: FractionalOffset(1.0, 1.0),
                width: MediaQuery.of(context).size.width,
                height: productlistdata.isEmpty && productlistdata.isEmpty ? 1:MediaQuery.of(context).size.height/1,
                child:  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: productlistdata.length,
                    itemBuilder: (context, i) {
                      final datacard2 = productlistdata[i];
                      return Container(
                          padding: EdgeInsets.only(bottom: 20),
                          decoration:BoxDecoration(
                            border: Border.all(
                              color: primarycolor,
                              width: 2,
                            ),

                          ),
                          margin:  EdgeInsets.only(left: 10, right: 10,bottom: 8),
                          child: GestureDetector(
                            child: Card(
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width/1.2,
                                     height: MediaQuery.of(context).size.height/5,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: NetworkImage(datacard2.offerImage!),
                                              fit: BoxFit.cover)

                                      ),
                                     ),],
                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(

                                                      width: MediaQuery.of(context).size.width/1.2,
                                                      margin:  EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                      child: Text(datacard2.offerTitle!)),

                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin:  EdgeInsets.only(bottom: 8),
                                                      width: MediaQuery.of(context).size.width/1.2,
                                                      child: Text(datacard2.offerDescription!)),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin:  EdgeInsets.only(bottom: 8),
                                                      width: MediaQuery.of(context).size.width/1.2,
                                                      child: Text("Offer Budget: "+datacard2.offerBudget!)),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin:  EdgeInsets.only(bottom: 8),
                                                      width: MediaQuery.of(context).size.width/1.2,
                                                      child: Text("Offer Duration: "+datacard2.offerDuration!)),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            onTap: () {
                            },
                          )
                      );
                    }
                )
          )
              ]
        ),
            )
        )
  ]
    ),
    );
  }
}