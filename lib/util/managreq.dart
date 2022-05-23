// To parse this JSON data, do
//
//     final managreq = managreqFromMap(jsonString);

import 'dart:convert';

Managreq managreqFromMap(String str) => Managreq.fromMap(json.decode(str));

String managreqToMap(Managreq data) => json.encode(data.toMap());

class Managreq {
  Managreq({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  String? responseCode;
  String? message;
  String? status;
  Content? content;
  CommonArr? commonArr;

  factory Managreq.fromMap(Map<String, dynamic> json) => Managreq(
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
  CommonArr({
    this.token,
  });

  String? token;

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
    this.mRequestsArr,
  });

  List<StatusArr>? statusArr;
  List<MRequestsArr>? mRequestsArr;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    statusArr: List<StatusArr>.from(json["statusArr"].map((x) => StatusArr.fromMap(x))),
    mRequestsArr: List<MRequestsArr>.from(json["mRequestsArr"].map((x) => MRequestsArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "statusArr": List<dynamic>.from(statusArr!.map((x) => x.toMap())),
    "mRequestsArr": List<dynamic>.from(mRequestsArr!.map((x) => x.toMap())),
  };
}

class MRequestsArr {
  MRequestsArr({
    this.requestId,
    this.requestTitle,
    this.requestDescription,
    this.requestDate,
    this.requestOffers,
    this.requestBudget,
    this.requestStatus,
    this.deliveryDuration,
  });

  String? requestId;
  String? requestTitle;
  String? requestDescription;
  String? requestDate;
  String? requestOffers;
  String? requestBudget;
  String? requestStatus;
  String? deliveryDuration;

  factory MRequestsArr.fromMap(Map<String, dynamic> json) => MRequestsArr(
    requestId: json["request_id"],
    requestTitle: json["request_title"],
    requestDescription: json["request_description"],
    requestDate: json["request_date"],
    requestOffers: json["request_offers"],
    requestBudget: json["request_budget"],
    requestStatus: json["request_status"],
    deliveryDuration: json["delivery_duration"],
  );

  Map<String, dynamic> toMap() => {
    "request_id": requestId,
    "request_title": requestTitle,
    "request_description": requestDescription,
    "request_date": requestDate,
    "request_offers": requestOffers,
    "request_budget": requestBudget,
    "request_status": requestStatus,
    "delivery_duration": deliveryDuration,
  };
}

class StatusArr {
  StatusArr({
    this.requestStatus,
    this.count,
  });

  String? requestStatus;
  String? count;

  factory StatusArr.fromMap(Map<String, dynamic> json) => StatusArr(
    requestStatus: json["request_status"],
    count: json["count"],
  );

  Map<String, dynamic> toMap() => {
    "request_status": requestStatus,
    "count": count,
  };
}
