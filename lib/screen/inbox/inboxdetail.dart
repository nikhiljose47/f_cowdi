import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/api.dart';
import 'dart:convert';
import 'package:flutter_app/util/inboxdetails.dart';
import 'package:path_provider/path_provider.dart';

class Inboxdetailpage extends StatefulWidget {
  final String? messagegropid,
      sellname,
      sellerImage; //if you have multiple values add here
  Inboxdetailpage(this.messagegropid, this.sellname, this.sellerImage,
      {Key? key})
      : super(key: key);

  @override
  _InboxdetailpageState createState() => _InboxdetailpageState();
}

class _InboxdetailpageState extends State<Inboxdetailpage> {
  String? imgUrl;

  bool downloading = false;
  var progressString = "";
  String progress = '0';
  ScrollController _scrollController = ScrollController();
  File? _file;
  bool isFileFetching = false;
  FilePickerResult? chatFile;

  final _key = new GlobalKey<FormState>();
  Color myGreen = Color(0xff4bb17b);

  var textvalue;
  List<ConversationArr> friendsLists = [];

  var loading = false;
  String? topimage;
  String? token = "";

  Future<void> downloadFile(imgUrl) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      await dio.download(imgUrl, "${dir.path}",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  Future getFile() async {
    setState(() {
      isFileFetching = true;
    });

    chatFile = await FilePicker.platform.pickFiles(type: FileType.any);
    setState(() {
      print(chatFile);
      isFileFetching = false;
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
          'message_group_id': widget.messagegropid,
          'message': textvalue,
          'file':
              await MultipartFile.fromFile(filePath.path, filename: fileName),
        });

        Response response = await Dio().post(
          baseurl + version + inboxsend,
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
          'message_group_id': widget.messagegropid,
          'message': textvalue,
          'file': '',
        });

        Response response = await Dio().post(
          baseurl + version + inboxsend,
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
    final linkdata = widget.messagegropid;
    print("jjjk");
    print(linkdata);
    print(baseurl + version + inboxdetails);
    final responseData =
        await http.post(Uri.parse(baseurl + version + inboxdetails), body: {
      'message_group_id': widget.messagegropid,
    }, headers: {
      'Auth': token!
    });
    if (responseData.statusCode == 200) {
      print("sasaas");
      final data = responseData.body;
      final friendsList = jsonDecode(data)['content']['conversationArr'];

      setState(() {
        _file = null;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final snackBar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(minutes: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
        padding: EdgeInsets.all(10),
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        content: SizedBox(
            height: 400,
            child: Column(
              children: [
                Center(
                    child: Container(
                  height: 5,
                  width: 40,
                  color: Colors.grey,
                  margin: EdgeInsets.only(bottom: 50),
                )),
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              new NetworkImage(widget.sellerImage as String))),
                ),
                Text(widget.sellname.toString(),
                    style: TextStyle(fontSize: 22, color: Colors.black))
              ],
            )));

    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 6.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: InkWell(
              onTap: () =>
                  {ScaffoldMessenger.of(context).showSnackBar(snackBar)},
              child: Center(widthFactor: 1, heightFactor: 1, child: Text(widget.sellname!,overflow: TextOverflow.ellipsis,))),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(primarycolor)))
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
                                                listcat.senderImage!)))),
                                title: Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(right: 10),
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
                                                listcat.filetype == null
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
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            listcat
                                                                .messageFile!))))
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
                                  top: 0.0, bottom: 0.0, right: 5.0, left: 5.0),
                              margin: EdgeInsets.only(
                                  top: 3.0, bottom: 0.0, right: 0.0, left: 0.0),
                              height: 100,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: TextFormField(
                                              onSaved: (e) => textvalue = e,
                                              style: TextStyle(
                                                height: 1,
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'SophiaNubian',
                                              ),
                                              decoration: InputDecoration(
                                                  hintText: "Type a Message...",
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Row(children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: IconButton(
                                                    icon:
                                                        Icon(Icons.attachment),
                                                    color: primarycolor,
                                                    onPressed: () {
                                                      getFile();
                                                    },
                                                  ),
                                                ),
                                                isFileFetching
                                                    ? CircularProgressIndicator()
                                                    : chatFile == null
                                                        ? Container()
                                                        : Row(

                                                          mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                                                                                            ClipRect(
                                                                child: SizedBox(
                                                                  width: 40,
                                                                  height: 30,
                                                                  child: FittedBox(
                                                                    alignment: Alignment.centerRight,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      child: Image.file(File(chatFile!
                                                                          .files
                                                                          .first
                                                                          .path
                                                                          .toString()))),
                                                                ),
                                                              ),
                                                              IconButton(highlightColor: Colors.grey,
                                                                alignment: Alignment.centerLeft,
                                                                padding: EdgeInsets.all(2),
                                                                icon: Icon(Icons
                                                                    .close_sharp , color: primarycolor, size: 18,),
                                                                onPressed: () =>
                                                                    setState(
                                                                        () {
                                                                  chatFile =
                                                                      null;
                                                                }),
                                                              ),

                                                            ],
                                                          ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: TextButton(
                                                      child: Text(
                                                        "send",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: primarycolor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              'SophiaNubian',
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _uploadFile(_file);
                                                      },
                                                    ),
                                                  ),
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
      ),
    );
  }
}
