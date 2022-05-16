import 'package:flutter/material.dart';
import 'package:flutter_app/screen/mainscreen.dart';
import 'package:flutter_app/screen/search/search.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/util/categore.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/screen/category/detailsubcat.dart';
import 'package:flutter_app/screen/explore/explore.dart';
import 'package:flutter_app/screen/others/others.dart';

class category extends StatefulWidget {
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {
  List<CArr> listService = [];
  List<SCArr> listsubcat = [];
  var loading = false;


  Future<Null> getData() async {
    setState(() {
      loading = true;
    });

    final responseData = await http.get(baseurl + version + categorylink);
    print("file");
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listservices = jsonDecode(data)['content']['cArr'] as List;

      var subcat = jsonDecode(data)['content']['cArr'][0]['sCArr'] as List;
      setState(() {
        for (Map i in listservices) {
          listService.add(CArr.fromMap(i));
          print(listservices);

        }

        for (Map i in subcat) {
          listsubcat.add(SCArr.fromMap(i));
          print(listsubcat);
        }
        loading = false;
      });
    }
  }
  //Panggil Data / Call Data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  int _index=0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>  Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => MyHomePage(0))),
          ),
        actions: <Widget>[
          searchsec(context),
        ],
      ),
      body: ListView(children: [
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20, top: 20.00),
              //alignment: FractionalOffset(1.0, 1.0),
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height/1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  itemCount: listService.length,
                  itemBuilder: (context, i) {

                    final nDataList = listService[i];
                    return nDataList.image == null ? Container() : Container(
                      decoration: new BoxDecoration(
                        color: Colors.white10,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),

                        ),
                      ),
                      child:  ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,

                          padding: const EdgeInsets.all(10.0),
                          child: Image(
                            image: new NetworkImage(
                              nDataList.image,
                            ),
                            height: 30,
                            width: 30,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                              Text(nDataList.title),
                               Text( listService[i].sCArr[0].subCategoryTitle == null ?  listService[i].sCArr[0].subCategoryTitle + ' , ' + listService[i].sCArr[1].subCategoryTitle:
                                 "",  style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),),
                            ],)),
                        //subtitle: Text((listsubcat[i].subCategoryTitle[i])),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context){
                                return subcatDetails(nDataList.link,nDataList.title);
                              },
                            ),
                          );
                        },

                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ]
      ),

    );
  }
}






Widget searchsec(context) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(

              margin: EdgeInsets.only(top: 10.00, right: 5.00,left: 5.00),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid
                  ),
                  borderRadius:new BorderRadius.all(new Radius.circular(10.0)
                  )),


              child:
              Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    GestureDetector(
                      child: Container(

                        padding: EdgeInsets.only(left: 10.00,right: 65),

                        height: 40,

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
                          MaterialPageRoute(builder: (context) =>  MyHomePage(2)),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(right: 10.00),
                        height: 40,
                        child: Row(
                          children: <Widget>[

                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage(2)),
                        );
                      },
                    ),

                  ]
              ),

            ),
          ],

        ),

      ],
    ),
  );
}