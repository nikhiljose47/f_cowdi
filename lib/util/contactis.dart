// To parse this JSON data, do
//
//     final conactus = conactusFromMap(jsonString);

import 'dart:convert';

Conactus conactusFromMap(String str) => Conactus.fromMap(json.decode(str));

String conactusToMap(Conactus data) => json.encode(data.toMap());

class Conactus {
  Conactus({
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

  factory Conactus.fromMap(Map<String, dynamic> json) => Conactus(
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
    this.messageGroupId,
  });

  String messageGroupId;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    messageGroupId: json["message_group_id"],
  );

  Map<String, dynamic> toMap() => {
    "message_group_id": messageGroupId,
  };
}
