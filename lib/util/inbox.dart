// To parse this JSON data, do
//
//     final inbox = inboxFromJson(jsonString);

import 'dart:convert';

Inbox inboxFromJson(String str) => Inbox.fromMap(json.decode(str));

String inboxToJson(Inbox data) => json.encode(data.toMap());

class Inbox {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  Inbox({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Inbox.fromMap(Map<String, dynamic> json) => Inbox(
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
  List<FiltersArr> filtersArr;
  List<InboxArr> inboxArr;

  Content({
    this.filtersArr,
    this.inboxArr,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    filtersArr: List<FiltersArr>.from(json["filtersArr"].map((x) => FiltersArr.fromMap(x))),
    inboxArr: List<InboxArr>.from(json["inboxArr"].map((x) => InboxArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "filtersArr": List<dynamic>.from(filtersArr.map((x) => x.toMap())),
    "inboxArr": List<dynamic>.from(inboxArr.map((x) => x.toMap())),
  };
}

class FiltersArr {
  String status;

  FiltersArr({
    this.status,
  });

  factory FiltersArr.fromMap(Map<String, dynamic> json) => FiltersArr(
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
  };
}

class InboxArr {
  String messageId;
  String messageGroupId;
  String senderName;
  String senderImage;
  String senderMessage;
  String dateTime;
  String messageStatus;
  String onlineStatus;

  InboxArr({
    this.messageId,
    this.messageGroupId,
    this.senderName,
    this.senderImage,
    this.senderMessage,
    this.dateTime,
    this.messageStatus,
    this.onlineStatus,
  });

  factory InboxArr.fromMap(Map<String, dynamic> json) => InboxArr(
    messageId: json["message_id"],
    messageGroupId: json["message_group_id"],
    senderName: json["sender_name"],
    senderImage: json["sender_image"],
    senderMessage: json["sender_message"],
    dateTime: json["date_time"],
    messageStatus: json["message_status"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
  );

  Map<String, dynamic> toMap() => {
    "message_id": messageId,
    "message_group_id": messageGroupId,
    "sender_name": senderName,
    "sender_image": senderImage,
    "sender_message": senderMessage,
    "date_time": dateTime,
    "message_status": messageStatus,
    "online_status": onlineStatus == null ? null : onlineStatus,
  };
}
