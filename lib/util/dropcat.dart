// To parse this JSON data, do
//
//     final dropdowncat = dropdowncatFromJson(jsonString);

import 'dart:convert';

Dropdowncat dropdowncatFromJson(String str) => Dropdowncat.fromMap(json.decode(str));

String dropdowncatToJson(Dropdowncat data) => json.encode(data.toMap());

class Dropdowncat {
  String? responseCode;
  String? message;
  String? status;
  Content? content;
  CommonArr? commonArr;

  Dropdowncat({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Dropdowncat.fromMap(Map<String, dynamic> json) => Dropdowncat(
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
    "content": content!.toMap(),
    "commonArr": commonArr!.toMap(),
  };
}

class CommonArr {
  String? token;

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
  List<CArr>? cArr;

  Content({
    this.cArr,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    cArr: List<CArr>.from(json["cArr"].map((x) => CArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "cArr": List<dynamic>.from(cArr!.map((x) => x.toMap())),
  };
}

class CArr {
  String? catId;
  String? link;
  String? title;
  String? image;

  CArr({
    this.catId,
    this.link,
    this.title,
    this.image,
  });

  factory CArr.fromMap(Map<String, dynamic> json) => CArr(
    catId: json["cat_id"],
    link: json["link"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "cat_id": catId,
    "link": link,
    "title": title,
    "image": image,
  };
}

