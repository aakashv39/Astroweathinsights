// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  List<FaqList>? recordList;
  int? status;

  FaqModel({
    this.recordList,
    this.status,
  });

  FaqModel copyWith({
    List<FaqList>? recordList,
    int? status,
  }) =>
      FaqModel(
        recordList: recordList ?? this.recordList,
        status: status ?? this.status,
      );

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        recordList: json["recordList"] == null
            ? []
            : List<FaqList>.from(
                json["recordList"]!.map((x) => FaqList.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "recordList": recordList == null
            ? []
            : List<dynamic>.from(recordList!.map((x) => x.toJson())),
        "status": status,
      };
}

class FaqList {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  FaqList({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  FaqList copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      FaqList(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory FaqList.fromJson(Map<String, dynamic> json) => FaqList(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
