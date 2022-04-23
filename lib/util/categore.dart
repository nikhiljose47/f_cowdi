// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromMap(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toMap());

class Category {
  String responseCode;
  String message;
  String status;
  Content content;

  Category({
    this.responseCode,
    this.message,
    this.status,
    this.content,
  });

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    responseCode: json["response_code"],
    message: json["message"],
    status: json["status"],
    content: Content.fromMap(json["content"]),
  );

  Map<String, dynamic> toMap() => {
    "response_code": responseCode,
    "message": message,
    "status": status,
    "content": content.toMap(),
  };
}

class Content {
  List<CArr> cArr;

  Content({
    this.cArr,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    cArr: List<CArr>.from(json["cArr"].map((x) => CArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "cArr": List<dynamic>.from(cArr.map((x) => x.toMap())),
  };
}

class CArr {
  String link;
  String title;
  String image;
  List<SCArr> sCArr;

  CArr({
    this.link,
    this.title,
    this.image,
    this.sCArr,
  });

  factory CArr.fromMap(Map<String, dynamic> json) => CArr(
    link: json["link"],
    title: json["title"],
    image: json["image"],
    sCArr: List<SCArr>.from(json["sCArr"].map((x) => SCArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "link": link,
    "title": title,
    "image": image,
    "sCArr": List<dynamic>.from(sCArr.map((x) => x.toMap())),
  };
}

class SCArr {
  String subCategoryLink;
  String subCategoryTitle;

  SCArr({
    this.subCategoryLink,
    this.subCategoryTitle,
  });

  factory SCArr.fromMap(Map<String, dynamic> json) => SCArr(
    subCategoryLink: json["sub_category_link"],
    subCategoryTitle: json["sub_category_title"],
  );

  Map<String, dynamic> toMap() => {
    "sub_category_link": subCategoryLink,
    "sub_category_title": subCategoryTitle,
  };
}
