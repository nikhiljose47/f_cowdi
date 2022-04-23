// To parse this JSON data, do
//
//     final proposal = proposalFromMap(jsonString);

import 'dart:convert';

Proposal proposalFromMap(String str) => Proposal.fromMap(json.decode(str));

String proposalToMap(Proposal data) => json.encode(data.toMap());

class Proposal {
  Proposal({
    this.responseCode,
    this.message,
    this.status,
    this.content,
  });

  String responseCode;
  String message;
  String status;
  Content content;

  factory Proposal.fromMap(Map<String, dynamic> json) => Proposal(
    responseCode: json["response_code"],
    message: json["message"],
    status: json["status"],
    content: Content.fromMap(json["content"]),
  );

  Map<String, dynamic> toMap() => {
    "response_code": responseCode,
    "message": message,
    "status": status,
    "content": content.toMap(),
  };
}

class Content {
  Content({
    this.pDetails,
  });

  List<PDetail> pDetails;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    pDetails: List<PDetail>.from(json["pDetails"].map((x) => PDetail.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "pDetails": List<dynamic>.from(pDetails.map((x) => x.toMap())),
  };
}

class PDetail {
  PDetail({
    this.proposalId,
    this.title,
    this.seller,
    this.images,
    this.pPackages,
    this.description,
    this.rating,
    this.reviews,
    this.proposalTags,
    this.faqs,
    this.sellersProposals,
  });

  String proposalId;
  String title;
  Seller seller;
  List<String> images;
  List<PPackage> pPackages;
  String description;
  Rating rating;
  List<Review> reviews;
  List<String> proposalTags;
  List<Faq> faqs;
  List<SellersProposal> sellersProposals;

  factory PDetail.fromMap(Map<String, dynamic> json) => PDetail(
    proposalId: json["proposal_id"],
    title: json["title"],
    seller: Seller.fromMap(json["seller"]),
    images: List<String>.from(json["images"].map((x) => x)),
    pPackages: List<PPackage>.from(json["pPackages"].map((x) => PPackage.fromMap(x))),
    description: json["description"],
    rating: Rating.fromMap(json["rating"]),
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromMap(x))),
    proposalTags: List<String>.from(json["proposal_tags"].map((x) => x)),
    faqs: List<Faq>.from(json["faqs"].map((x) => Faq.fromMap(x))),
    sellersProposals: List<SellersProposal>.from(json["sellers_proposals"].map((x) => SellersProposal.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "proposal_id": proposalId,
    "title": title,
    "seller": seller.toMap(),
    "images": List<dynamic>.from(images.map((x) => x)),
    "pPackages": List<dynamic>.from(pPackages.map((x) => x.toMap())),
    "description": description,
    "rating": rating.toMap(),
    "reviews": List<dynamic>.from(reviews.map((x) => x.toMap())),
    "proposal_tags": List<dynamic>.from(proposalTags.map((x) => x)),
    "faqs": List<dynamic>.from(faqs.map((x) => x.toMap())),
    "sellers_proposals": List<dynamic>.from(sellersProposals.map((x) => x.toMap())),
  };
}

class Faq {
  Faq({
    this.question,
    this.answer,
  });

  String question;
  String answer;

  factory Faq.fromMap(Map<String, dynamic> json) => Faq(
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toMap() => {
    "question": question,
    "answer": answer,
  };
}

class PPackage {
  PPackage({
    this.packageId,
    this.packageName,
    this.description,
    this.revisions,
    this.deliveryTime,
    this.price,
  });

  String packageId;
  String packageName;
  String description;
  String revisions;
  String deliveryTime;
  String price;

  factory PPackage.fromMap(Map<String, dynamic> json) => PPackage(
    packageId: json["package_id"],
    packageName: json["package_name"],
    description: json["description"],
    revisions: json["revisions"],
    deliveryTime: json["delivery_time"],
    price: json["price"],
  );

  Map<String, dynamic> toMap() => {
    "package_id": packageId,
    "package_name": packageName,
    "description": description,
    "revisions": revisions,
    "delivery_time": deliveryTime,
    "price": price,
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

class Review {
  Review({
    this.buyerName,
    this.buyerImage,
    this.buyerReview,
    this.buyerRating,
    this.reviewDate,
    this.sellerName,
    this.sellerImage,
    this.onlineStatus,
    this.sellerReview,
    this.sellerRating,
  });

  String buyerName;
  String buyerImage;
  String buyerReview;
  String buyerRating;
  String reviewDate;
  String sellerName;
  String sellerImage;
  String onlineStatus;
  String sellerReview;
  String sellerRating;

  factory Review.fromMap(Map<String, dynamic> json) => Review(
    buyerName: json["buyer_name"],
    buyerImage: json["buyer_image"],
    buyerReview: json["buyer_review"],
    buyerRating: json["buyer_rating"],
    reviewDate: json["review_date"],
    sellerName: json["seller_name"] == null ? null : json["seller_name"],
    sellerImage: json["seller_image"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
    sellerReview: json["seller_review"] == null ? null : json["seller_review"],
    sellerRating: json["seller_rating"] == null ? null : json["seller_rating"],
  );

  Map<String, dynamic> toMap() => {
    "buyer_name": buyerName,
    "buyer_image": buyerImage,
    "buyer_review": buyerReview,
    "buyer_rating": buyerRating,
    "review_date": reviewDate,
    "seller_name": sellerName == null ? null : sellerName,
    "seller_image": sellerImage,
    "online_status": onlineStatus == null ? null : onlineStatus,
    "seller_review": sellerReview == null ? null : sellerReview,
    "seller_rating": sellerRating == null ? null : sellerRating,
  };
}

class Seller {
  Seller({
    this.sellerId,
    this.messagegroupid,
    this.sellerName,
    this.sellerImage,
    this.onlineStatus,
    this.sellerCountry,
    this.sellerDescription,
    this.recentDelivery,
    this.positiveReview,
    this.sellerSince,
    this.sellerLastActivity,
    this.sellerLevel,
    this.sellerLanguages,
  });

  String sellerId;
  String messagegroupid;
  String sellerName;
  String sellerImage;
  String onlineStatus;
  String sellerCountry;
  String sellerDescription;
  String recentDelivery;
  String positiveReview;
  String sellerSince;
  String sellerLastActivity;
  String sellerLevel;
  List<dynamic> sellerLanguages;

  factory Seller.fromMap(Map<String, dynamic> json) => Seller(
    sellerId: json["seller_id"],
    messagegroupid: json["message_group_id"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
    sellerCountry: json["seller_country"],
    sellerDescription: json["seller_description"],
    recentDelivery: json["recent_delivery"],
    positiveReview: json["positive_review"],
    sellerSince: json["seller_since"],
    sellerLastActivity: json["seller_last_activity"],
    sellerLevel: json["seller_level"],
    sellerLanguages: List<dynamic>.from(json["seller_languages"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "seller_id": sellerId,
    "message_group_id": messagegroupid,
    "seller_name": sellerName,
    "seller_image": sellerImage,
    "online_status": onlineStatus == null ? null : onlineStatus,
    "seller_country": sellerCountry,
    "seller_description": sellerDescription,
    "recent_delivery": recentDelivery,
    "positive_review": positiveReview,
    "seller_since": sellerSince,
    "seller_last_activity": sellerLastActivity,
    "seller_level": sellerLevel,
    "seller_languages": List<dynamic>.from(sellerLanguages.map((x) => x)),
  };
}

class SellersProposal {
  SellersProposal({
    this.title,
    this.postImage,
    this.price,
    this.sellerName,
    this.sellerImage,
    this.onlineStatus,
    this.sellerLevel,
    this.rating,
    this.link,
  });

  String title;
  String postImage;
  String price;
  String sellerName;
  String sellerImage;
  String onlineStatus;
  String sellerLevel;
  Rating rating;
  String link;

  factory SellersProposal.fromMap(Map<String, dynamic> json) => SellersProposal(
    title: json["title"],
    postImage: json["post_image"],
    price: json["price"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
    onlineStatus: json["online_status"] == null ? null : json["online_status"],
    sellerLevel: json["seller_level"],
    rating: Rating.fromMap(json["rating"]),
    link: json["link"],
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
  };
}
