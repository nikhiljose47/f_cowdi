// To parse this JSON data, do
//
//     final cartpagesec = cartpagesecFromMap(jsonString);

import 'dart:convert';

Cartpagesec cartpagesecFromMap(String str) => Cartpagesec.fromMap(json.decode(str));

String cartpagesecToMap(Cartpagesec data) => json.encode(data.toMap());

class Cartpagesec {
  Cartpagesec({
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

  factory Cartpagesec.fromMap(Map<String, dynamic> json) => Cartpagesec(
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
    this.cartDetails,
    this.payments,
  });

  List<CartDetail> cartDetails;
  List<Payment> payments;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    cartDetails: List<CartDetail>.from(json["cartDetails"].map((x) => CartDetail.fromMap(x))),
    payments: List<Payment>.from(json["payments"].map((x) => Payment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "cartDetails": List<dynamic>.from(cartDetails.map((x) => x.toMap())),
    "payments": List<dynamic>.from(payments.map((x) => x.toMap())),
  };
}

class CartDetail {
  CartDetail({
    this.proposalId,
    this.proposalTitle,
    this.proposalImage,
    this.proposalQuantity,
    this.price,
  });

  String proposalId;
  String proposalTitle;
  String proposalImage;
  String proposalQuantity;
  String price;

  factory CartDetail.fromMap(Map<String, dynamic> json) => CartDetail(
    proposalId: json["proposal_id"],
    proposalTitle: json["proposal_title"],
    proposalImage: json["proposal_image"],
    proposalQuantity: json["proposal_quantity"],
    price: json["price"],
  );

  Map<String, dynamic> toMap() => {
    "proposal_id": proposalId,
    "proposal_title": proposalTitle,
    "proposal_image": proposalImage,
    "proposal_quantity": proposalQuantity,
    "price": price,
  };
}

class Payment {
  Payment({
    this.subTotalPrice,
    this.processingFee,
    this.totalPrice,
    this.paymentUrl,
  });

  String subTotalPrice;
  String processingFee;
  String totalPrice;
  String paymentUrl;

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
    subTotalPrice: json["subTotalPrice"],
    processingFee: json["processingFee"],
    totalPrice: json["totalPrice"],
    paymentUrl: json["paymentUrl"],
  );

  Map<String, dynamic> toMap() => {
    "subTotalPrice": subTotalPrice,
    "processingFee": processingFee,
    "totalPrice": totalPrice,
    "paymentUrl": paymentUrl,
  };
}
