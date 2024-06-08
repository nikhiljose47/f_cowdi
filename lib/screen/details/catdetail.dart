import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/category/detailsubcat.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/profiledetails/profiledetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/catpost.dart';

class catdetail extends StatefulWidget {
  final String subcatlink,
      title,
      prelink,
      pretitle; //if you have multiple values add here
  catdetail(this.subcatlink, this.title, this.prelink, this.pretitle, {Key key})
      : super(key: key);
  @override
  _catdetailState createState() => _catdetailState();
}

class _catdetailState extends State<catdetail> {
  List<PList> listplist = [];
  var loading = true;
  String topimage;

  Future<Null> getData() async {
    final linkdata = '/' + widget.subcatlink;
    final titlelink = '/' + widget.title;
    print(baseurl + version + linkdata);
    final responseData = await http.get(baseurl + version + linkdata);
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listplists = jsonDecode(data)['content']['pList'] as List;
      //   print(listplists);

      setState(() {
        for (Map i in listplists) {
          listplist.add(PList.fromMap(i));
        }
        loading = false;
      });
    }
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

  setFavourite(int index) {
    setState(() {
      listplist[index].isFavourite = listplist[index].isFavourite == 1 ? 0 : 1;
    });
    //N-todo set favourite
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    // print(widget.pretitle + widget.prelink);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: widget.prelink == "home"
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage(0))),
              )
            : widget.pretitle != "home"
                ? IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => subcatDetails(
                                widget.prelink, widget.pretitle))),
                  )
                : true,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
          : ListView.builder(
              itemCount: listplist.length,
              itemBuilder: (context, int index) {
                final nplacesList = listplist[index];
                return InkWell(
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                    child: Card(
                      child: Container(
                        height: 120,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      nplacesList.postImage,
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
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text(
                                                  nplacesList
                                                      .rating.averageRatting,
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text(
                                                  "(${nplacesList.rating.totalReviews})",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () =>
                                                  setFavourite(index),
                                              icon: Icon(
                                                Icons.favorite,
                                                size: 18.0,
                                                color:
                                                    nplacesList.isFavourite == 1
                                                        ? Color.fromARGB(255, 255, 166, 0)
                                                        : Colors.grey,
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
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: nplacesList.title.length >= 50
                                            ? Text(
                                                nplacesList.title
                                                        .substring(0, 30) +
                                                    "...",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Text(
                                                nplacesList.title,
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
                                          "From " + nplacesList.price,
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
                    // print(nplacesList.link);
                    // print(widget.subcatlink);
                    // print(widget.title);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return profiledetailpage(
                              nplacesList.link,
                              widget.subcatlink,
                              widget.title,
                              widget.pretitle,
                              widget.prelink);
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
