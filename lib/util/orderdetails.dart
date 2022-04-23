// To parse this JSON data, do
//
//     final orderdetails = orderdetailsFromJson(jsonString);

import 'dart:convert';

Orderdetails orderdetailsFromJson(String str) => Orderdetails.fromMap(json.decode(str));

String orderdetailsToJson(Orderdetails data) => json.encode(data.toMap());

class Orderdetails {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  Orderdetails({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Orderdetails.fromMap(Map<String, dynamic> json) => Orderdetails(
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
  List<ODetail> oDetails;
  List<ConversationArr> conversationArr;

  Content({
    this.oDetails,
    this.conversationArr,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    oDetails: List<ODetail>.from(json["oDetails"].map((x) => ODetail.fromMap(x))),
    conversationArr: List<ConversationArr>.from(json["conversationArr"].map((x) => ConversationArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "oDetails": List<dynamic>.from(oDetails.map((x) => x.toMap())),
    "conversationArr": List<dynamic>.from(conversationArr.map((x) => x.toMap())),
  };
}

class ConversationArr {
  String senderName;
  String senderImage;
  String message;
  String file;
  String filetype;
  String filename;
  String dateTime;

  ConversationArr({
    this.senderName,
    this.senderImage,
    this.message,
    this.file,
    this.filetype,
    this.filename,
    this.dateTime,
  });

  factory ConversationArr.fromMap(Map<String, dynamic> json) => ConversationArr(
    senderName: json["sender_name"],
    senderImage: json["sender_image"],
    message: json["message"],
    file: json["file"],
    filetype: json["file_type"],
    filename: json["file_name"],
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toMap() => {
    "sender_name": senderName,
    "sender_image": senderImage,
    "message": message,
    "file": file,
    "file_type": filetype,
    "file_name": filename,
    "date_time": dateTime,
  };
}

class ODetail {
  String orderId;
  String orderNumber;
  String status;
  String orderDate;
  String dueDate;
  String orderDuration;
  String orderActive;
  String orderQty;
  String itemPrice;
  String orderFee;
  String orderPrice;
  String postTitle;
  String postImage;
  String sellerName;
  String sellerImage;

  ODetail({
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.dueDate,
    this.orderDuration,
    this.orderActive,
    this.orderQty,
    this.itemPrice,
    this.orderFee,
    this.orderPrice,
    this.postTitle,
    this.postImage,
    this.sellerName,
    this.sellerImage,
  });

  factory ODetail.fromMap(Map<String, dynamic> json) => ODetail(
    orderId: json["order_id"],
    orderNumber: json["order_number"],
    status: json["status"],
    orderDate: json["order_date"],
    dueDate: json["due_date"],
    orderDuration: json["order_duration"],
    orderActive: json["order_active"],
    orderQty: json["order_qty"],
    itemPrice: json["item_price"],
    orderFee: json["order_fee"],
    orderPrice: json["order_price"],
    postTitle: json["post_title"],
    postImage: json["post_image"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
  );

  Map<String, dynamic> toMap() => {
    "order_id": orderId,
    "order_number": orderNumber,
    "status": status,
    "order_date": orderDate,
    "due_date": dueDate,
    "order_duration": orderDuration,
    "order_active": orderActive,
    "order_qty": orderQty,
    "item_price": itemPrice,
    "order_fee": orderFee,
    "order_price": orderPrice,
    "post_title": postTitle,
    "post_image": postImage,
    "seller_name": sellerName,
    "seller_image": sellerImage,
  };
}
