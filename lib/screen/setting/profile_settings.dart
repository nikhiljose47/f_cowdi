import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:flutter_app/util/methods.dart';
import 'package:flutter_app/util/profile.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../util/const.dart';
import 'package:flutter_app/services/api.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String token = "";
  String? name, username, email, phoneNumber;
  FocusNode nameFocusNode = new FocusNode();
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode phoneNumberFocusNode = new FocusNode();
  var loading = false;
  bool checkBoxVal = false;
  bool hasNetworkIssue = false;
  bool hasProfilePicPicked = false;
  FilePickerResult? profileImgFile ;

  List<MProfile> listService = [];
  String? linkdata;
  List<AppInfo> apiinforlist = [];
  //dropdown values
  String timeZoneDropdownValue = 'Africa/Abidjan';
  String countryDropdownValue = 'India';
  String langDropdownValue = 'Select your language';
  String dialCodeDropdownValue = '+91';
  //profile
  MProfile profileDetails = new MProfile();

  //keys
  final _key = new GlobalKey<FormState>();

//color
  Color boxColor = Colors.grey;
  Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    getPref();
    getDatalist();
  }

  Future<Null> getDatalist() async {
    final responseDataappinfo = await http.post(Uri.parse(baseurl + version + sitedetails),
        body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info'] as List;
      linkdata = jsonDecode(dataapinfo)['content']['app_info'][0]['app_link'];
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i as Map<String,dynamic>));
        }
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token").toString();
    });
    print(token);
    setState(() {
      loading = true;
    });
    print(token);
    if (token == null) {
      print("not");
    } else {
      final responseData =
          await http.get(Uri.parse(baseurl + version + profile), headers: {'Auth': token});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        var listservices = jsonDecode(data)['content']['mProfile'] as List;

        print(listservices[0]);
        setState(() {
          for (Map i in listservices) {
            listService.add(MProfile.fromMap(i as Map<String,dynamic>));
          }
          profileDetails = listService.first;
          loading = false;
        });
      } else {
        hasNetworkIssue = true;
      }
    }
  }

  getFile() async {
    hasProfilePicPicked = false;
    profileImgFile = await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      print(profileImgFile);
      hasProfilePicPicked = true;
    });
    //N-todo save & local compressed cache
    //N-todo - profile details get & pre display in all fields
  }

  save() async {
    //N-Todo
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        loading = true;
      });
      save();
    }
  }

  callBackFn(String data) {
    setState(() {
      this.dialCodeDropdownValue = data;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: ListView.builder(
      itemCount: Constants.dialCodes.length,
      itemBuilder: (BuildContext context, int index) {
        return CountryCodeItem(index, Constants.dialCodes[index], callBackFn);
      },
    ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.center,
          heightFactor: 0.75,
          child: alert,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Profile Settings")),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(boxColor)))
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 15.0, bottom: 45),
                      child: Stack(children: [
                        (hasProfilePicPicked && profileImgFile != null)
                            ? ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                      child:
                                          Image.file(File(profileImgFile!.files.first.path.toString())),
                                ),
                              ))
                            : CircleAvatar(
                                radius: 45.0,
                                backgroundImage:
                                    NetworkImage((profileDetails.sellerImage).toString()),
                              ),
                        Positioned(
                          right: -15,
                          top: -10,
                          child: IconButton(
                              onPressed: () => getFile(),
                              icon: new Icon(
                                Icons.edit,
                                color: Colors.red,
                                size: 25,
                              )),
                        ),
                      ])),
                  Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Material(
                              elevation: 0.0,
                              child: TextFormField(
                                //focusNode: nameFocusNode,
                                initialValue: profileDetails.sellerName,

                                onSaved: (e) => name = e.toString(),
                                // onChanged: (e) => _fnameKey.currentState.validate(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(13.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    labelText: "Full name",
                                    labelStyle: TextStyle(color: textColor)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Material(
                              elevation: 0.0,
                              child: TextFormField(
                                //focusNode: nameFocusNode,
                                //  initialValue: profileDetails.sellerName,
                                validator: (e) => !Util.emailValidate(e)
                                    ? "Please enter valid email"
                                    : null,
                                onSaved: (e) => email = e.toString(),
                                // onChanged: (e) => _fnameKey.currentState.validate(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(13.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: textColor)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: boxColor,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () => showAlertDialog(context),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Text(
                                                      dialCodeDropdownValue,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: IconButton(
                                                      onPressed: null,
                                                      icon: new Icon(
                                                        Icons.arrow_downward,
                                                        size: 15,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                )
                                              ]),
                                        ))),
                                SizedBox(width: 1),
                                Expanded(
                                  flex: 6,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],

                                    onSaved: (e) => phoneNumber = e.toString(),
                                    // onChanged: (e) => _fnameKey.currentState.validate(),
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(13.0),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: boxColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: boxColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: boxColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        labelText: "Phone number",
                                        labelStyle:
                                            TextStyle(color: textColor)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: boxColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: DropdownButton(
                                      underline:
                                          Container(color: Colors.transparent),
                                      menuMaxHeight: 250,
                                      isExpanded: true,
                                      value: countryDropdownValue,
                                      borderRadius: BorderRadius.circular(8),
                                      items: Constants.countryNames
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          countryDropdownValue = newValue.toString();
                                        });
                                      }),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: TextFormField(
                              //focusNode: nameFocusNode,
                              // initialValue: "",

                              onSaved: (e) => name = e.toString(),
                              // onChanged: (e) => _fnameKey.currentState.validate(),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(13.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: boxColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: boxColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: boxColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "City",
                                  labelStyle: TextStyle(color: textColor)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: boxColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: DropdownButton(
                                      underline:
                                          Container(color: Colors.transparent),
                                      menuMaxHeight: 250,
                                      isExpanded: true,
                                      value: timeZoneDropdownValue,
                                      borderRadius: BorderRadius.circular(8),
                                      items: <String>[
                                        'Africa/Abidjan',
                                        'Africa/Accra',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          timeZoneDropdownValue = newValue.toString();
                                        });
                                      }),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: boxColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: DropdownButton(
                                      underline:
                                          Container(color: Colors.transparent),
                                      menuMaxHeight: 250,
                                      isExpanded: true,
                                      value: langDropdownValue,
                                      borderRadius: BorderRadius.circular(8),
                                      items: <String>[
                                        'Select your language',
                                        'French',
                                        'Malayalam',
                                        'English',
                                        'Spanish',
                                        'Russian',
                                        'Chinese',
                                        'Hindi',
                                        'Korean'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          langDropdownValue = newValue.toString();
                                        });
                                      }),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Material(
                              elevation: 0.0,
                              child: TextFormField(
                                maxLines: 4,
                                //focusNode: nameFocusNode,
                                // initialValue: "",

                                onSaved: (e) => name = e.toString(),
                                // onChanged: (e) => _fnameKey.currentState.validate(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    labelText: "Headline",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(color: textColor)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Material(
                              elevation: 0.0,
                              child: TextFormField(
                                maxLines: 4,
                                //focusNode: nameFocusNode,
                                // initialValue: "",

                                onSaved: (e) => name = e.toString(),
                                // onChanged: (e) => _fnameKey.currentState.validate(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: boxColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    labelText: "Description",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                      color: textColor,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ElevatedButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                onPressed: () {
                                  //Todo clearCache();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text("Save Changes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                                onPressed: () {
                                  check();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ))
                ],
              ),
      ),
    );
  }
}

class CountryCodeItem extends StatefulWidget {
  final int index;
  final String name;
  final Function callback;
  const CountryCodeItem(this.index, this.name, this.callback);

  @override
  CountryCodeItemState createState() => CountryCodeItemState();
}

class CountryCodeItemState extends State<CountryCodeItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(widget.name,
                maxLines: 2,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          ),
        ),
        Expanded(
            child: InkWell(
          onTap: () {
            var items = widget.name.split(' ');
            var item = items[items.length - 1];
            widget.callback(item.substring(1, item.length - 1));
            // dropdownValue =
            //     dropdownValue.substring(1, dropdownValue.length - 1);
            setState(() {
              isSelected = true;
            });
            Future.delayed(const Duration(milliseconds: 500),
                () => Navigator.pop(context));
          },
          child: Container(
            decoration: BoxDecoration(
                color: isSelected ? primarycolor : null,
                border: Border.all(color: Colors.black),
                shape: BoxShape.circle),
            // padding: EdgeInsets.all(8),
            width: 18,
            height: 18,
          ),
        )),
      ],
    );
  }
}
