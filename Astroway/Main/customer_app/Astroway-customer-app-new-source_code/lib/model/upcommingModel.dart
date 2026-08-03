// To parse this JSON data, do
//
//     final upcommingModel = upcommingModelFromJson(jsonString);

import 'dart:convert';

UpcommingModel upcommingModelFromJson(String str) => UpcommingModel.fromJson(json.decode(str));

String upcommingModelToJson(UpcommingModel data) => json.encode(data.toJson());

class UpcommingModel {
  bool? status;
  String? message;
  List<UpcommingListModel>? data;

  UpcommingModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpcommingModel.fromJson(Map<String, dynamic> json) => UpcommingModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<UpcommingListModel>.from(json["data"]!.map((x) => UpcommingListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UpcommingListModel {
  int? id;
  String? astrologerName;
  String? profileImage;
  String? statusLabel;
  DateTime? scheduleLiveDate;
  String? scheduleLiveTime;
  dynamic astrologerId;

  UpcommingListModel({
    this.id,
    this.astrologerName,
    this.profileImage,
    this.statusLabel,
    this.scheduleLiveDate,
    this.scheduleLiveTime,
    this.astrologerId,
  });

  factory UpcommingListModel.fromJson(Map<String, dynamic> json) => UpcommingListModel(
    id: json["id"],
    astrologerName: json["astrologerName"],
    profileImage: json["profileImage"],
    statusLabel: json["statusLabel"],
    scheduleLiveDate: json["schedule_live_date"] == null ? null : DateTime.parse(json["schedule_live_date"]),
    scheduleLiveTime: json["schedule_live_time"],
    astrologerId: json['astrologerId']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "astrologerName": astrologerName,
    "profileImage": profileImage,
    "statusLabel": statusLabel,
    "schedule_live_date": "${scheduleLiveDate!.year.toString().padLeft(4, '0')}-${scheduleLiveDate!.month.toString().padLeft(2, '0')}-${scheduleLiveDate!.day.toString().padLeft(2, '0')}",
    "schedule_live_time": scheduleLiveTime,
    "astrologerId": astrologerId,
  };
}
