// To parse this JSON data, do
//
//     final profile = profileFromMap(jsonString);

import 'dart:convert';

Profile profileFromMap(String str) => Profile.fromMap(json.decode(str));

String profileToMap(Profile data) => json.encode(data.toMap());

class Profile {
  Profile({
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

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
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
    this.mProfile,
  });

  List<MProfile> mProfile;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    mProfile: List<MProfile>.from(json["mProfile"].map((x) => MProfile.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "mProfile": List<dynamic>.from(mProfile.map((x) => x.toMap())),
  };
}

class MProfile {
  MProfile({
    this.sellerName,
    this.sellerUserName,
    this.sellerImage,
    this.sellerSince,
    this.sellerRecentDelivery,
    this.sellerLevel,
    this.onlineStatus,
    this.sellerVerificationStatus,
    this.rating,
  });

  String sellerName;
  String sellerUserName;
  String sellerImage;
  String sellerSince;
  String sellerRecentDelivery;
  String sellerLevel;
  String onlineStatus;
  int sellerVerificationStatus;
  Rating rating;

  factory MProfile.fromMap(Map<String, dynamic> json) => MProfile(
    sellerName: json["seller_name"],
    sellerUserName: json["seller_user_name"],
    sellerImage: json["seller_image"],
    sellerSince: json["seller_since"],
    sellerRecentDelivery: json["seller_recent_delivery"],
    sellerLevel: json["seller_level"],
    onlineStatus: json["online_status"],
    sellerVerificationStatus: json["seller_verification_status"],
    rating: Rating.fromMap(json["rating"]),
  );

  Map<String, dynamic> toMap() => {
    "seller_name": sellerName,
    "seller_user_name": sellerUserName,
    "seller_image": sellerImage,
    "seller_since": sellerSince,
    "seller_recent_delivery": sellerRecentDelivery,
    "seller_level": sellerLevel,
    "online_status": onlineStatus,
    "seller_verification_status": sellerVerificationStatus,
    "rating": rating.toMap(),
  };
}

class Rating {
  Rating({
    this.averageRatting,
    this.totalReviews,
  });

  String averageRatting;
  String totalReviews;

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
    averageRatting: json["average_ratting"],
    totalReviews: json["total_reviews"],
  );

  Map<String, dynamic> toMap() => {
    "average_ratting": averageRatting,
    "total_reviews": totalReviews,
  };
}
