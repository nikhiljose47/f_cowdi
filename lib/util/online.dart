// To parse this JSON data, do
//
//     final onlinstat = onlinstatFromJson(jsonString);

import 'dart:convert';

Onlinstat onlinstatFromJson(String str) => Onlinstat.fromMap(json.decode(str));

String onlinstatToJson(Onlinstat data) => json.encode(data.toMap());

class Onlinstat {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  Onlinstat({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Onlinstat.fromMap(Map<String, dynamic> json) => Onlinstat(
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
  String sellerStatus;

  Content({
    this.sellerStatus,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    sellerStatus: json["seller_status"],
  );

  Map<String, dynamic> toMap() => {
    "seller_status": sellerStatus,
  };
}
