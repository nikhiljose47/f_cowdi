// To parse this JSON data, do
//
//     final viewoffersec = viewoffersecFromMap(jsonString);

import 'dart:convert';

Viewoffersec viewoffersecFromMap(String str) => Viewoffersec.fromMap(json.decode(str));

String viewoffersecToMap(Viewoffersec data) => json.encode(data.toMap());

class Viewoffersec {
  Viewoffersec({
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

  factory Viewoffersec.fromMap(Map<String, dynamic> json) => Viewoffersec(
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
    this.rDetails,
    this.oDetails,
  });

  List<RDetail> rDetails;
  List<ODetail> oDetails;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    rDetails: List<RDetail>.from(json["rDetails"].map((x) => RDetail.fromMap(x))),
    oDetails: List<ODetail>.from(json["oDetails"].map((x) => ODetail.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "rDetails": List<dynamic>.from(rDetails.map((x) => x.toMap())),
    "oDetails": List<dynamic>.from(oDetails.map((x) => x.toMap())),
  };
}

class ODetail {
  ODetail({
    this.offerId,
    this.offerImage,
    this.offerTitle,
    this.offerDescription,
    this.offerBudget,
    this.offerDuration,
    this.sellerName,
    this.sellerImage,
  });

  String offerId;
  String offerImage;
  String offerTitle;
  String offerDescription;
  String offerBudget;
  String offerDuration;
  String sellerName;
  String sellerImage;

  factory ODetail.fromMap(Map<String, dynamic> json) => ODetail(
    offerId: json["offer_id"],
    offerImage: json["offer_image"],
    offerTitle: json["offer_title"],
    offerDescription: json["offer_description"],
    offerBudget: json["offer_budget"],
    offerDuration: json["offer_duration"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
  );

  Map<String, dynamic> toMap() => {
    "offer_id": offerId,
    "offer_image": offerImage,
    "offer_title": offerTitle,
    "offer_description": offerDescription,
    "offer_budget": offerBudget,
    "offer_duration": offerDuration,
    "seller_name": sellerName,
    "seller_image": sellerImage,
  };
}

class RDetail {
  RDetail({
    this.requestId,
    this.requestTitle,
    this.requestDescription,
    this.requestBudget,
    this.requestDate,
    this.requestDuration,
    this.requestCategory,
  });

  String requestId;
  String requestTitle;
  String requestDescription;
  String requestBudget;
  String requestDate;
  String requestDuration;
  String requestCategory;

  factory RDetail.fromMap(Map<String, dynamic> json) => RDetail(
    requestId: json["request_id"],
    requestTitle: json["request_title"],
    requestDescription: json["request_description"],
    requestBudget: json["request_budget"],
    requestDate: json["request_date"],
    requestDuration: json["request_duration"],
    requestCategory: json["request_category"],
  );

  Map<String, dynamic> toMap() => {
    "request_id": requestId,
    "request_title": requestTitle,
    "request_description": requestDescription,
    "request_budget": requestBudget,
    "request_date": requestDate,
    "request_duration": requestDuration,
    "request_category": requestCategory,
  };
}
