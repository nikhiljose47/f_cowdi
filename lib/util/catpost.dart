// To parse this JSON data, do
//
//     final catpost = catpostFromJson(jsonString);

import 'dart:convert';

Catpost catpostFromJson(String str) => Catpost.fromMap(json.decode(str));

String catpostToJson(Catpost data) => json.encode(data.toMap());

class Catpost {
  String? responseCode;
  String? message;
  String? status;
  Content? content;
  CommonArr? commonArr;

  Catpost({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Catpost.fromMap(Map<String, dynamic> json) => Catpost(
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
  List<PList>? pList;

  Content({
    this.pList,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    pList: List<PList>.from(json["pList"].map((x) => PList.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "pList": List<dynamic>.from(pList!.map((x) => x.toMap())),
  };
}

class PList {
  String? title;
  String? postImage;
  String? price;
  String? sellerName;
  String? sellerImage;
  String? sellerLevel;
  Rating? rating;
  String? link;
  int? isFavourite;

  PList({
    this.title,
    this.postImage,
    this.price,
    this.sellerName,
    this.sellerImage,
    this.sellerLevel,
    this.rating,
    this.link,
    this.isFavourite,
  });

  factory PList.fromMap(Map<String, dynamic> json) => PList(
    title: json["title"],
    postImage: json["post_image"],
    price: json["price"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
    sellerLevel: json["seller_level"],
    rating: Rating.fromMap(json["rating"]),
    link: json["link"],
    isFavourite: json["isFavourite"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "post_image": postImage,
    "price": price,
    "seller_name": sellerName,
    "seller_image": sellerImage,
    "seller_level": sellerLevel,
    "rating": rating!.toMap(),
    "link":link,
    "isFavourite":isFavourite
  };
}

class Rating {
  String? averageRatting;
  String? totalReviews;

  Rating({
    this.averageRatting,
    this.totalReviews,
  });

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
    averageRatting: json["average_ratting"],
    totalReviews: json["total_reviews"],
  );

  Map<String, dynamic> toMap() => {
    "average_ratting": averageRatting,
    "total_reviews": totalReviews,
  };
}

