import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/profiledetails/profiledetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/searchcall.dart';

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

    final responseData =
        await http.post(Uri.parse(baseurl + version + searchurl), body: {
      "search_string": text,
    });
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listpalces = jsonDecode(data)['content']['pList'];
      print(listpalces);
      setState(() {
        for (Map i in listpalces) {
          listplaces.add(PList.fromMap(i as Map<String, dynamic>));
        }
      });
    }
  }

  Future _printLatestValue() async {
    String text = editingController.text;
    final responseData =
        await http.post(Uri.parse(baseurl + version + searchurl), body: {
      "search_string": text,
    });
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listpalces = jsonDecode(data)['content']['pList'];
      print(listpalces);
      setState(() {
        for (Map i in listpalces) {
          listplaces.add(PList.fromMap(i as Map<String, dynamic>));
        }
      });
    }
  }

  setFavourite(int index) {
    setState(() {
      // listplaces[index].isFavourite = listplist[index].isFavourite == 1 ? 0 : 1;
    });
    //N-todo set favourite
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
              child: FlatButton(
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
              child: FlatButton(
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
              child: FlatButton(
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
      body: ListView.builder(
        itemCount: listplaces.length,
        itemBuilder: (context, int index) {
          final nplacesList = listplaces[index];
          return InkWell(
            child: Container(
              margin: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Container(
                  height: 120,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          height: 120.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(
                                nplacesList.postImage!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Row(children: [
                                        Icon(
                                          Icons.star,
                                          size: 12.0,
                                          color: Colors.amber,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            nplacesList.rating!.averageRatting!,
                                            style: TextStyle(
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            "(${nplacesList.rating!.totalReviews})",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () => setFavourite(index),
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 18.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: nplacesList.title!.length >= 50
                                      ? Text(
                                          nplacesList.title!.substring(0, 30) +
                                              "...",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        )
                                      : Text(
                                          nplacesList.title!,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "From " + nplacesList.price.toString(),
                                    style: TextStyle(
                                      color: primarycolor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
      ),
    );
  }
}

//2 grid list
// CustomScrollView(controller: _scrollController, slivers: <Widget>[
//         grid(),]);
// Widget grid() {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 1,
//         childAspectRatio: 2.3 *
//             MediaQuery.of(context).size.width /
//             (MediaQuery.of(context).size.height),
//       ),
//       delegate: SliverChildBuilderDelegate(
//         (context, i) {
//           final nplacesList = listplaces[i];
//           return InkWell(
//             child: Card(
//               elevation: 0.0,
//               child: Container(
//                 // margin: EdgeInsets.only(left: 5.00, top: 5.00, right: 5.00),
//                 decoration: myBoxDecorationfirst(),

//                 child: Column(children: <Widget>[
//                   Container(
//                     height: 150,
//                     width: double.infinity,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(0),
//                       child: Image.network(
//                         nplacesList.postImage!,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(
//                         left: 10.00, right: 10.00, top: 5.00, bottom: 5.00),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             new Container(
//                                 width: 30.0,
//                                 height: 30.0,
//                                 decoration: new BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     image: new DecorationImage(
//                                         fit: BoxFit.fill,
//                                         image: new NetworkImage(
//                                             nplacesList.sellerImage!)))),
//                             new Container(
//                                 padding: EdgeInsets.only(left: 5.00),
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(nplacesList.sellerName!),
//                                       Text(nplacesList.sellerLevel!),
//                                     ])),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(right: 10.00, left: 10.00),
//                     child: Column(children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Flexible(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 10.0, top: 5),
//                               child: Text(nplacesList.title!.length > 30
//                                   ? nplacesList.title!.substring(0, 30) + "..."
//                                   : nplacesList.title!),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ]),
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(right: 10.00, top: 10.00),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             new Container(
//                                 padding: EdgeInsets.only(left: 10),
//                                 child: Row(children: <Widget>[
//                                   Text(
//                                     "From ",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: primarycolor,
//                                     ),
//                                     maxLines: 2,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                   Text(
//                                     "${nplacesList.price}",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: primarycolor,
//                                     ),
//                                     maxLines: 2,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                 ])),
//                           ],
//                         ),
//                         Row(children: <Widget>[
//                           new Container(
//                               child: Row(children: <Widget>[
//                             Icon(
//                               Icons.star,
//                               size: 14,
//                               color: Colors.orangeAccent,
//                             ),
//                             Text(
//                               "${nplacesList.rating!.totalReviews} ",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.orangeAccent,
//                               ),
//                               maxLines: 2,
//                               textAlign: TextAlign.left,
//                             ),
//                             Text(
//                               "(${nplacesList.rating!.averageRatting})",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black38,
//                               ),
//                               maxLines: 2,
//                               textAlign: TextAlign.left,
//                             ),
//                           ])),
//                         ]),
//                       ],
//                     ),
//                   ),
//                 ]),
//               ),
//             ),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) {
//                     return profiledetailpage(nplacesList.link, "search",
//                         "search", "search", "search");
//                   },
//                 ),
//               );
//             },
//           );
//         },
//         childCount: listplaces.length,
//       ),
//     );
//   }