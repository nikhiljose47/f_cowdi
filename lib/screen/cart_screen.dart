import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/categore.dart' as m;

import 'package:flutter_app/util/catpost.dart';
import 'package:flutter_app/util/subcat.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final String? title;
  CartScreen({Key? key, this.title}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<PList> listplist = [];
  var loading = true;
  String? topimage;
  List<PList> favList = [];
    List<m.CArr> listService = [];
  List<SCArr> listsubcat = [];
  String link1 = "";
   String linkb1 = "";
  List<SCArr> listSCArr = [];

    Future<Null> getData() async {
    setState(() {
      loading = true;
    });
    final responseData = await http.get(Uri.parse(baseurl + version + categorylink));
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final List<dynamic> listservices = jsonDecode(data)['content']['cArr'];

      final List<dynamic> subcat = jsonDecode(data)['content']['cArr'][0]['sCArr'];
        for (Map i in listservices) {
          listService.add(m.CArr.fromMap(i as Map<String, dynamic>));
          //print(listservices);
        }

        link1 = listService[0].link.toString();
        getDataSc(link1); 
        
    }
  }



  @override
  void initState() {
    super.initState();
  //  getData();
    
  }


 makeFavouriteList(List<PList> list){
   print("came");
    favList.addAll(list);
   
 }
       Future<Null> getDataFinal(String linkb1) async {
    final linkdata = '/'+ linkb1;
    print(baseurl + version  + linkdata);
    final responseData = await http.get(Uri.parse( baseurl + version  + linkdata));
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listplists = jsonDecode(data)['content']['pList'];
   //   print(listplists);

      
        for (Map i in listplists) {
          listplist.add(PList.fromMap(i as Map<String, dynamic>));
        }
       List<PList> pList = [];
        for(var i=0; i<pList.length;i++){
          if(listplist[i].isFavourite==1){
            print("fav spotted");
            pList.add(listplist[i]);
          }
          
        }
        print("NIKHIL");
        print(pList);

          
        
        makeFavouriteList(pList);
      
    }
    
  }

    Future<Null> getDataSc(link1) async {
       
    final linkdata = '/'+ link1!;
    print(baseurl + version  + linkdata);
    final responseData = await http.get(Uri.parse( baseurl + version  + linkdata));
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['sCArr'];
 
        print("object");
        for (Map i in listsCArr) {
          listSCArr.add(SCArr.fromMap(i as Map<String, dynamic>));
        }
        topimage = jsonDecode(data)['content']['bImage'];
        print("NIK");

       String linkb1 = listSCArr[0].link.toString();

       listSCArr.forEach((element) {
        
         getDataFinal(element.link.toString());
       });

  setState(() {
     loading = false;
    
   });
        
        
       
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    singleCard(iconcode, icontitle) {
      return Card(
        color: Colors.white,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                IconData(
                  iconcode,
                  fontFamily: 'MaterialIcons',
                ),
                color: primarycolor,
                size: 25.0,
              ),
              Text(
                icontitle,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Cart',
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
          : ListView.builder(
        itemCount: favList.length,
        itemBuilder: (context, int index) {
          final nplacesList = favList[index];
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
                                              padding: const EdgeInsets.only(
                                                left: 4.0),
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
                                              onPressed: null,
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
                           width: MediaQuery.of(context).size.width *
                                              0.35,
                                          child: nplacesList.title!.length >=50 ? Text(
                                            nplacesList.title!.substring(0, 30)+"..." ,style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          ): Text(
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
              // print(nplacesList.link);
              // print(widget.subcatlink);
              // print(widget.title);
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext context){

              //       return profiledetailpage(nplacesList.link, widget.subcatlink,widget.title,widget.pretitle ,widget.prelink);
              //     },
              //   ),
              //);
            },
          );
        },
      ),
    );
  }
}
