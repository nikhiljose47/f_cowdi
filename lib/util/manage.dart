// To parse this JSON data, do
//
//     final managaorder = managaorderFromMap(jsonString);

import 'dart:convert';

Managaorder managaorderFromMap(String str) => Managaorder.fromMap(json.decode(str));

String managaorderToMap(Managaorder data) => json.encode(data.toMap());

class Managaorder {
  Managaorder({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  factory Managaorder.fromMap(Map<String, dynamic> json) => Managaorder(
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
  CommonArr({
    this.token,
  });

  String token;

  factory CommonArr.fromMap(Map<String, dynamic> json) => CommonArr(
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "token": token,
  };
}

class Content {
  Content({
    this.statusArr,
    this.mOrdersArr,
  });

  List<StatusArr> statusArr;
  List<MOrdersArr> mOrdersArr;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    statusArr: List<StatusArr>.from(json["statusArr"].map((x) => StatusArr.fromMap(x))),
    mOrdersArr: List<MOrdersArr>.from(json["mOrdersArr"].map((x) => MOrdersArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "statusArr": List<dynamic>.from(statusArr.map((x) => x.toMap())),
    "mOrdersArr": List<dynamic>.from(mOrdersArr.map((x) => x.toMap())),
  };
}

class MOrdersArr {
  MOrdersArr({
    this.orderId,
    this.orderDate,
    this.orderPrice,
    this.orderStatus,
    this.postTitle,
    this.postImage,
    this.sellerName,
    this.sellerImage,
  });

  String orderId;
  String orderDate;
  String orderPrice;
  String orderStatus;
  String postTitle;
  String postImage;
  String sellerName;
  String sellerImage;

  factory MOrdersArr.fromMap(Map<String, dynamic> json) => MOrdersArr(
    orderId: json["order_id"],
    orderDate: json["order_date"],
    orderPrice: json["order_price"],
    orderStatus: json["order_status"],
    postTitle: json["post_title"],
    postImage: json["post_image"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
  );

  Map<String, dynamic> toMap() => {
    "order_id": orderId,
    "order_date": orderDate,
    "order_price": orderPrice,
    "order_status": orderStatus,
    "post_title": postTitle,
    "post_image": postImage,
    "seller_name": sellerName,
    "seller_image": sellerImage,
  };
}

class StatusArr {
  StatusArr({
    this.status,
    this.count,
  });

  String status;
  String count;

  factory StatusArr.fromMap(Map<String, dynamic> json) => StatusArr(
    status: json["status"],
    count: json["count"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "count": count,
  };
}
