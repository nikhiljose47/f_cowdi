import 'dart:convert';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter_app/screen/profiledetails/profiledetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/searchcall.dart';
import 'package:flutter_app/Widget/recentvariable.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController editingController = TextEditingController();
  List<PList> listplaces = [];
  final ScrollController _scrollController = ScrollController();

  onSearchTextChanged(String text) async {
    listplaces.clear();
    String text = editingController.text;
    print(text);

    final responseData = await http.post(baseurl + version + searchurl, body: {
      "search_string": text,
    });
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listpalces = jsonDecode(data)['content']['pList'] as List;
      print(listpalces);
      setState(() {
        for (Map i in listpalces) {
          listplaces.add(PList.fromMap(i));
        }
      });
    }
  }

  Future _printLatestValue() async {
    String text = editingController.text;
    final responseData = await http.post(baseurl + version + searchurl, body: {
      "search_string": text,
    });
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listpalces = jsonDecode(data)['content']['pList'] as List;
      print(listpalces);
      setState(() {
        for (Map i in listpalces) {
          listplaces.add(PList.fromMap(i));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _printLatestValue();
  }

  myBoxDecorationfirst() {
    return BoxDecoration(
      color: Colors.white,
      border: new Border.all(
          color: Colors.grey, width: 0.5, style: BorderStyle.solid),
      borderRadius: new BorderRadius.vertical(
        bottom: new Radius.circular(10.0),
        //bottom: new Radius.circular(20.0),
      ),
    );
  }

  final bottomContentText = Container(
    padding: EdgeInsets.only(left: 10.00, top: 10.00, bottom: 10.00),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Shop By",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.white,
                textColor: Colors.grey,
                padding: EdgeInsets.all(8.0),
                onPressed: () {},
                child: Text(
                  "Style",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: TextButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.white,
                textColor: Colors.grey,
                padding: EdgeInsets.all(8.0),
                onPressed: () {},
                child: Text(
                  "Seller's Experience",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.white,
                textColor: Colors.grey,
                padding: EdgeInsets.all(8.0),
                onPressed: () {},
                child: Text(
                  "Editiable",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget grid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.1),
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final nplacesList = listplaces[i];
          return GestureDetector(
            child: Card(
              elevation: 0.0,
              child: Container(
                // margin: EdgeInsets.only(left: 5.00, top: 5.00, right: 5.00),
                decoration: myBoxDecorationfirst(),

                child: Column(children: <Widget>[
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        nplacesList.postImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 10.00, right: 10.00, top: 5.00, bottom: 5.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            nplacesList.sellerImage)))),
                            new Container(
                                padding: EdgeInsets.only(left: 5.00),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(nplacesList.sellerName),
                                      Text(nplacesList.sellerLevel),
                                    ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.00, left: 10.00),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5),
                              child: Text(nplacesList.title.length > 30
                                  ? nplacesList.title.substring(0, 30) + "..."
                                  : nplacesList.title),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(right: 10.00, top: 10.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              "${nplacesList.rating.totalReviews} ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.orangeAccent,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "(${nplacesList.rating.averageRatting})",
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
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return profiledetailpage(nplacesList.link, "search",
                        "search", "search", "search");
                  },
                ),
              );
            },
          );
        },
        childCount: listplaces.length,
      ),
    );
  }

  Card customersec(Recent recent) => Card(
        child: Container(
          // margin: EdgeInsets.only(left: 5.00, top: 5.00, right: 5.00),

          // height: 1000,
          width: 250,
          decoration: myBoxDecorationfirst(),

          child: Column(children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  "${recent.coverimg}",
                  height: 167,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 10.00, right: 10.00, top: 10.00, bottom: 5.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(recent.profileimg)))),
                      new Container(
                        padding: EdgeInsets.only(left: 5.00),
                        child: new Text(recent.name),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.00, left: 10.00),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 5),
                        child: Text(recent.description),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.00, left: 10.00, top: 10.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              "${recent.price}",
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
                        "${recent.rating} ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.orangeAccent,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "(${recent.ratingcount})",
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
      );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                elevation: 1.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 45,
                      child: TextField(
                        onChanged: onSearchTextChanged,
                        controller: editingController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black38,
                          ),
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text("dfdfdf"),
          ],
        ),
      ),
      body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
        grid(),
      ]),
    );
  }
}
