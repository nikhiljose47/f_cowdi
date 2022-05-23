// To parse this JSON data, do
//
//     final subcategory = subcategoryFromJson(jsonString);

import 'dart:convert';

Subcategory subcategoryFromJson(String str) => Subcategory.fromMap(json.decode(str));

String subcategoryToJson(Subcategory data) => json.encode(data.toMap());

class Subcategory {
  String? responseCode;
  String? message;
  String? status;
  Content? content;

  Subcategory({
    this.responseCode,
    this.message,
    this.status,
    this.content,
  });

  factory Subcategory.fromMap(Map<String, dynamic> json) => Subcategory(
    responseCode: json["response_code"],
    message: json["message"],
    status: json["status"],
    content: Content.fromMap(json["content"]),
  );

  Map<String, dynamic> toMap() => {
    "response_code": responseCode,
    "message": message,
    "status": status,
    "content": content!.toMap(),
  };
}

class Content {
  List<SCArr>? sCArr;
  String? bImage;

  Content({
    this.sCArr,
    this.bImage,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    sCArr: List<SCArr>.from(json["sCArr"].map((x) => SCArr.fromMap(x))),
    bImage: json["bImage"],
  );

  Map<String, dynamic> toMap() => {
    "sCArr": List<dynamic>.from(sCArr!.map((x) => x.toMap())),
    "bImage": bImage,
  };
}

class SCArr {
  String? link;
  String? title;

  SCArr({
    this.link,
    this.title,
  });

  factory SCArr.fromMap(Map<String, dynamic> json) => SCArr(
    link: json["link"],
    title: json["title"],
  );

  Map<String, dynamic> toMap() => {
    "link": link,
    "title": title,
  };
}
