import 'dart:convert';

Formsupport formsupportFromMap(String str) => Formsupport.fromMap(json.decode(str));

String formsupportToMap(Formsupport data) => json.encode(data.toMap());

class Formsupport {
  Formsupport({
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

  factory Formsupport.fromMap(Map<String, dynamic> json) => Formsupport(
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
    this.typesArr,
  });

  List<TypesArr> typesArr;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
    typesArr: List<TypesArr>.from(json["typesArr"].map((x) => TypesArr.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "typesArr": List<dynamic>.from(typesArr.map((x) => x.toMap())),
  };
}

class TypesArr {
  TypesArr({
    this.enquiryType,
    this.enquiryTitle,
    this.fields,
  });

  String enquiryType;
  String enquiryTitle;
  List<String> fields;

  factory TypesArr.fromMap(Map<String, dynamic> json) => TypesArr(
    enquiryType: json["enquiry_type"],
    enquiryTitle: json["enquiry_title"],
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "enquiry_type": enquiryType,
    "enquiry_title": enquiryTitle,
    "fields": List<dynamic>.from(fields.map((x) => x)),
  };
}
