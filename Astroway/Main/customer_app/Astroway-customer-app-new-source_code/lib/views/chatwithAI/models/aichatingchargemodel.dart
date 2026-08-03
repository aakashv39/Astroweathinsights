// To parse this JSON data, do
//
//     final aiChatingChargeModel = aiChatingChargeModelFromJson(jsonString);

import 'dart:convert';

AiChatingChargeModel aiChatingChargeModelFromJson(String str) =>
    AiChatingChargeModel.fromJson(json.decode(str));

String aiChatingChargeModelToJson(AiChatingChargeModel data) =>
    json.encode(data.toJson());

class AiChatingChargeModel {
  String? balance;
  String message;
  int status;

  AiChatingChargeModel({
    this.balance,
    required this.message,
    required this.status,
  });

  factory AiChatingChargeModel.fromJson(Map<String, dynamic> json) =>
      AiChatingChargeModel(
        balance: json["balance"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "message": message,
        "status": status,
      };
}
