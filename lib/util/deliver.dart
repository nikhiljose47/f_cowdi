// To parse this JSON data, do
//
//     final delivertime = delivertimeFromMap(jsonString);

import 'dart:convert';

Delivertime delivertimeFromMap(String str) => Delivertime.fromMap(json.decode(str));

String delivertimeToMap(Delivertime data) => json.encode(data.toMap());

class Delivertime {
  Delivertime({
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

  factory Delivertime.fromMap(Map<String, dynamic> json) => Delivertime(
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
    this.deliveryArr,
    this.currencyArr,
  });

  List<DeliveryArr>? deliveryArr;
  List<CurrencyArr>? currencyArr;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    deliveryArr: List<DeliveryArr>.from(json["deliveryArr"].map((x) => DeliveryArr.fromMap(x))),
    currencyArr: List<CurrencyArr>.from(json["currencyArr"].map((x) => CurrencyArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "deliveryArr": List<dynamic>.from(deliveryArr!.map((x) => x.toMap())),
    "currencyArr": List<dynamic>.from(currencyArr!.map((x) => x.toMap())),
  };
}

class CurrencyArr {
  CurrencyArr({
    this.id,
    this.name,
    this.symbol,
  });

  String? id;
  String? name;
  String? symbol;

  factory CurrencyArr.fromMap(Map<String, dynamic> json) => CurrencyArr(
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "symbol": symbol,
  };
}

class DeliveryArr {
  DeliveryArr({
    this.deliveryId,
    this.deliveryTitle,
    this.deliveryProposalTitle,
  });

  String? deliveryId;
  String? deliveryTitle;
  String? deliveryProposalTitle;

  factory DeliveryArr.fromMap(Map<String, dynamic> json) => DeliveryArr(
    deliveryId: json["delivery_id"],
    deliveryTitle: json["delivery_title"],
    deliveryProposalTitle: json["delivery_proposal_title"],
  );

  Map<String, dynamic> toMap() => {
    "delivery_id": deliveryId,
    "delivery_title": deliveryTitle,
    "delivery_proposal_title": deliveryProposalTitle,
  };
}
