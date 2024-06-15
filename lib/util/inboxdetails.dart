// To parse this JSON data, do
//
//     final inboxdetails = inboxdetailsFromJson(jsonString);

import 'dart:convert';

Inboxdetails inboxdetailsFromJson(String str) => Inboxdetails.fromMap(json.decode(str));

String inboxdetailsToJson(Inboxdetails data) => json.encode(data.toMap());

class Inboxdetails {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  Inboxdetails({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Inboxdetails.fromMap(Map<String, dynamic> json) => Inboxdetails(
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
  List<ConversationArr> conversationArr;

  Content({
    this.conversationArr,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    conversationArr: List<ConversationArr>.from(json["conversationArr"].map((x) => ConversationArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "conversationArr": List<dynamic>.from(conversationArr.map((x) => x.toMap())),
  };
}

class ConversationArr {
  String messageId;
  String messageGroupId;
  String senderName;
  String senderImage;
  String message;
  String messageFile;
  String dateTime;
  String filetype;
  String filename;
  MessageStatus messageStatus;

  ConversationArr({
     this.messageId,
     this.messageGroupId,
     this.senderName,
     this.senderImage,
     this.message,
     this.messageFile,
     this.dateTime,
     this.filetype,
     this.filename,
     this.messageStatus,
  });

  factory ConversationArr.fromMap(Map<String, dynamic> json) => ConversationArr(
    messageId: json["message_id"],
    messageGroupId: json["message_group_id"],
    senderName: json["sender_name"],
    senderImage: json["sender_image"],
    message: json["message"],
    messageFile: json["message_file"],
    dateTime: json["date_time"],
    filetype: json["file_type"],
    filename: json["file_name"],
    messageStatus: messageStatusValues.map[json["message_status"]],
  );

  Map<String, dynamic> toMap() => {
    "message_id": messageId,
    "message_group_id": messageGroupId,
    "sender_name": senderName,
    "sender_image": senderImage,
    "message": message,
    "message_file": messageFile,
    "date_time":filetype,
    "file_name": filename,
    "date_time": dateTime,
    "message_status": messageStatusValues.reverse[messageStatus],
  };
}

enum MessageStatus { READ, UNREAD }

final messageStatusValues = EnumValues({
  "read": MessageStatus.READ,
  "unread": MessageStatus.UNREAD
});

enum SenderName { ME, SELLER }

final senderNameValues = EnumValues({
  "Me": SenderName.ME,
  "seller": SenderName.SELLER
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return reverseMap;
  }
}
