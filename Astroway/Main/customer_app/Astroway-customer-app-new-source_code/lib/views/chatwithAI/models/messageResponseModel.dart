// To parse this JSON data, do
//
//     final messageResponseModel = messageResponseModelFromJson(jsonString);

import 'dart:convert';

MessageResponseModel messageResponseModelFromJson(String str) =>
    MessageResponseModel.fromJson(json.decode(str));

String messageResponseModelToJson(MessageResponseModel data) =>
    json.encode(data.toJson());

class MessageResponseModel {
  String message;
  int status;

  MessageResponseModel({
    required this.message,
    required this.status,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) =>
      MessageResponseModel(
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
      };
}
