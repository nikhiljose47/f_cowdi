// To parse this JSON data, do
//
//     final mailContent = mailContentFromJson(jsonString);

import 'dart:convert';

MailContent mailContentFromJson(String str) => MailContent.fromMap(json.decode(str));

String mailContentToJson(MailContent data) => json.encode(data.toMap());

class MailContent {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  MailContent({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory MailContent.fromMap(Map<String, dynamic> json) => MailContent(
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
  List<NotificationsArr> notificationsArr;

  Content({
    this.notificationsArr,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    notificationsArr: List<NotificationsArr>.from(json["notificationsArr"].map((x) => NotificationsArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "notificationsArr": List<dynamic>.from(notificationsArr.map((x) => x.toMap())),
  };
}

class NotificationsArr {
  String notificationId;
  String senderName;
  String senderImage;
  String onlineStatus;
  String message;
  String status;
  String dateTime;

  NotificationsArr({
    this.notificationId,
    this.senderName,
    this.senderImage,
    this.onlineStatus,
    this.message,
    this.status,
    this.dateTime,
  });

  factory NotificationsArr.fromMap(Map<String, dynamic> json) => NotificationsArr(
    notificationId: json["notification_id"],
    senderName: json["sender_name"],
    senderImage: json["sender_image"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
    message: json["message"],
    status: json["status"],
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toMap() => {
    "notification_id": notificationId,
    "sender_name": senderName,
    "sender_image": senderImage,
    "online_status": onlineStatus == null ? null : onlineStatus,
    "message": message,
    "status": status,
    "date_time": dateTime,
  };
}
