// To parse this JSON data, do
//
//     final homepage = homepageFromJson(jsonString);

import 'dart:convert';

Homepage homepageFromJson(String str) => Homepage.fromMap(json.decode(str));

String homepageToJson(Homepage data) => json.encode(data.toMap());

class Homepage {
  String responseCode;
  String message;
  String status;
  Content content;
  CommonArr commonArr;

  Homepage({
    this.responseCode,
    this.message,
    this.status,
    this.content,
    this.commonArr,
  });

  factory Homepage.fromMap(Map<String, dynamic> json) => Homepage(
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
  List<PService> pServices;
  List<MPlace> mPlaces;
  List<FProposal> fProposals;
  List<RView> rViews;
  List<ODetail> oDetails;

  Content({
    this.pServices,
    this.mPlaces,
    this.fProposals,
    this.rViews,
	this.oDetails,
  });

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    pServices: List<PService>.from(json["pServices"].map((x) => PService.fromMap(x))),
    mPlaces: List<MPlace>.from(json["mPlaces"].map((x) => MPlace.fromMap(x))),
    fProposals: List<FProposal>.from(json["fProposals"].map((x) => FProposal.fromMap(x))),
    rViews: List<RView>.from(json["rViews"].map((x) => RView.fromMap(x))),
	oDetails: List<ODetail>.from(json["oDetails"].map((x) => ODetail.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "pServices": List<dynamic>.from(pServices.map((x) => x.toMap())),
    "mPlaces": List<dynamic>.from(mPlaces.map((x) => x.toMap())),
    "fProposals": List<dynamic>.from(fProposals.map((x) => x.toMap())),
    "rViews": List<dynamic>.from(rViews.map((x) => x.toMap())),
	 "oDetails": List<dynamic>.from(oDetails.map((x) => x.toMap())),
  };
}

class FProposal {
  String title;
  String postImage;
  String price;
  String sellerName;
  String sellerImage;
  String onlineStatus;
  String sellerLevel;
  Rating rating;
  String link;
  int isFavourite;

  FProposal({
    this.title,
    this.postImage,
    this.price,
    this.sellerName,
    this.sellerImage,
    this.onlineStatus,
    this.sellerLevel,
    this.rating,
    this.link,
    this.isFavourite,
  });

  factory FProposal.fromMap(Map<String, dynamic> json) => FProposal(
    title: json["title"],
    postImage: json["post_image"],
    price: json["price"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
    sellerLevel: json["seller_level"],
    rating: Rating.fromMap(json["rating"]),
    link: json["link"],
     isFavourite: json["isFavourite"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "post_image": postImage,
    "price": price,
    "seller_name": sellerName,
    "seller_image": sellerImage,
    "online_status": onlineStatus == null ? null : onlineStatus,
    "seller_level": sellerLevel,
    "rating": rating.toMap(),
    "link": link,
    "isFavourite":isFavourite
  };
}
class MPlace {
  String link;
  String title;
  String description;
  String image;

  MPlace({
    this.link,
    this.title,
    this.description,
    this.image,
  });

  factory MPlace.fromMap(Map<String, dynamic> json) => MPlace(
    link: json["link"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "link": link,
    "title": title,
    "description": description,
    "image": image,
  };
}

class PService {
  String title;
  String image;
  String link;

  PService({
    this.title,
    this.image,
    this.link,
  });

  factory PService.fromMap(Map<String, dynamic> json) => PService(
    title: json["title"],
    image: json["image"],
    link: json["link"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "image": image,
    "link": link,
  };
}

class RView {
  String title;
  String postImage;
  String price;
  String sellerName;
  String sellerImage;
  String onlineStatus;
  String sellerLevel;
  Rating rating;
  String link;
  int isFavourite;

  RView({
    this.title,
    this.postImage,
    this.price,
    this.sellerName,
    this.sellerImage,
    this.onlineStatus,
    this.sellerLevel,
    this.rating,
    this.link,
    this.isFavourite,
  });

  factory RView.fromMap(Map<String, dynamic> json) => RView(
    title: json["title"],
    postImage: json["post_image"],
    price: json["price"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
    sellerLevel: json["seller_level"],
    rating: Rating.fromMap(json["rating"]),
    link: json["link"],
    isFavourite: json["isFavourite"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "post_image": postImage,
    "price": price,
    "seller_name": sellerName,
    "seller_image": sellerImage,
    "online_status": onlineStatus == null ? null : onlineStatus,
    "seller_level": sellerLevel,
    "rating": rating.toMap(),
    "link": link,
    "isFavourite":isFavourite
  };
}

class Rating {
  String averageRatting;
  String totalReviews;

  Rating({
    this.averageRatting,
    this.totalReviews,
  });

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
    averageRatting: json["average_ratting"],
    totalReviews: json["total_reviews"],
  );

  Map<String, dynamic> toMap() => {
    "average_ratting": averageRatting,
    "total_reviews": totalReviews,
  };
}
class ODetail {
    ODetail({
        this.requestId,
        this.offerId,
        this.offerImage,
        this.offerTitle,
        this.offerDescription,
        this.offerBudget,
        this.offerDuration,
        this.sellerid,
        this.sellerName,
        this.sellerImage,
        this.onlineStatus,
      this.messagegroupid,
      this.checkouturl,
    });

    String requestId;
    String offerId;
    String offerImage;
    String offerTitle;
    String offerDescription;
    String offerBudget;
    String offerDuration;
    String sellerid;
    String sellerName;
    String sellerImage;
    String onlineStatus;
    String messagegroupid;
    String checkouturl;


    factory ODetail.fromMap(Map<String, dynamic> json) => ODetail(
        requestId: json["request_id"],
        offerId: json["offer_id"],
        offerImage: json["offer_image"],
        offerTitle: json["offer_title"],
        offerDescription: json["offer_description"],
        offerBudget: json["offer_budget"],
        offerDuration: json["offer_duration"],
        sellerid: json["seller_id"],
        sellerName: json["seller_name"],
        sellerImage: json["seller_image"],
      messagegroupid: json["message_group_id"],
      checkouturl: json["checkout_url"],
      onlineStatus: json["online_status"] == null ? null : json["online_status"],
    );

    Map<String, dynamic> toMap() => {
        "request_id": requestId,
        "offer_id": offerId,
        "offer_image": offerImage,
        "offer_title": offerTitle,
        "offer_description": offerDescription,
        "offer_budget": offerBudget,
        "offer_duration": offerDuration,
        "seller_id": sellerid,
        "seller_name": sellerName,
        "seller_image": sellerImage,
      "checkout_url":checkouturl,
      "message_group_id": messagegroupid,
      "online_status": onlineStatus == null ? null : onlineStatus,
    };
}
