// To parse this JSON data, do
//
//     final dropdownsubcat = dropdownsubcatFromJson(jsonString);

import 'dart:convert';

Dropdownsubcat dropdownsubcatFromJson(String str) => Dropdownsubcat.fromMap(json.decode(str));

String dropdownsubcatToJson(Dropdownsubcat data) => json.encode(data.toMap());

class Dropdownsubcat {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  Dropdownsubcat({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Dropdownsubcat.fromMap(Map<String, dynamic> json) => Dropdownsubcat(
    responseCode: json["response_code"],
    message: json["message"],
    status: json["status"],
    content: Content.fromMap(json["content"]),
    commonArr: CommonArr.fromMap(json["commonArr"]),
  );

  Map<String, dynamic> toMap() => {
    "response_code": responseCode,
    "message": message,
    "status": status,
    "content": content.toMap(),
    "commonArr": commonArr.toMap(),
  };
}

class CommonArr {
  String token;

  CommonArr({
    this.token,
  });

  factory CommonArr.fromMap(Map<String, dynamic> json) => CommonArr(
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "token": token,
  };
}

class Content {
  List<SCArr> sCArr;
  String bImage;

  Content({
    this.sCArr,
    this.bImage,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    sCArr: List<SCArr>.from(json["sCArr"].map((x) => SCArr.fromMap(x))),
    bImage: json["bImage"],
  );

  Map<String, dynamic> toMap() => {
    "sCArr": List<dynamic>.from(sCArr.map((x) => x.toMap())),
    "bImage": bImage,
  };
}

class SCArr {
  String childId;
  String link;
  String title;

  SCArr({
    this.childId,
    this.link,
    this.title,
  });

  factory SCArr.fromMap(Map<String, dynamic> json) => SCArr(
    childId: json["child_id"],
    link: json["link"],
    title: json["title"],
  );

  Map<String, dynamic> toMap() => {
    "child_id": childId,
    "link": link,
    "title": title,
  };
}
