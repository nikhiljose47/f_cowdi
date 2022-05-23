// To parse this JSON data, do
//
//     final infoapp = infoappFromMap(jsonString);

import 'dart:convert';

Infoapp infoappFromMap(String str) => Infoapp.fromMap(json.decode(str));

String infoappToMap(Infoapp data) => json.encode(data.toMap());

class Infoapp {
  Infoapp({
    this.responseCode,
    this.message,
    this.status,
    this.content,
  });

  String? responseCode;
  String? message;
  String? status;
  Content? content;

  factory Infoapp.fromMap(Map<String, dynamic> json) => Infoapp(
    responseCode: json["response_code"],
    message: json["message"],
    status: json["status"],
    content: Content.fromMap(json["content"]),
  );

  Map<String, dynamic> toMap() => {
    "response_code": responseCode,
    "message": message,
    "status": status,
    "content": content!.toMap(),
  };
}

class Content {
  Content({
    this.appInfo,
  });

  List<AppInfo>? appInfo;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    appInfo: List<AppInfo>.from(json["app_info"].map((x) => AppInfo.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "app_info": List<dynamic>.from(appInfo!.map((x) => x.toMap())),
  };
}

class AppInfo {
  AppInfo({
    this.appName,
    this.appTitle,
    this.appLogo,
    this.invitePrice,
    this.applink
  });

  String? appName;
  String? appTitle;
  String? appLogo;
  String? invitePrice;
  String? applink;

  factory AppInfo.fromMap(Map<String, dynamic> json) => AppInfo(
    appName: json["app_name"],
    appTitle: json["app_title"],
    appLogo: json["app_logo"],
    invitePrice: json["invite_price"],
    applink: json["app_link"],
  );

  Map<String, dynamic> toMap() => {
    "app_name": appName,
    "app_title": appTitle,
    "app_logo": appLogo,
    "invite_price": invitePrice,
    "app_link": applink,
  };
}
