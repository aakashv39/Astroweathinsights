class AiChatHistoryModel {
  int? id;
  int? userId;
  int? aiAstrologerId;
  dynamic chatMin;
  int? chatRate;
  int? inrUsdConversionRate;
  int? deduction;
  String? chatDuration;
  bool? isFree;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? astrologerId;
  String? astrologerName;
  String? image;
  String? chatCharge;

  AiChatHistoryModel({
    this.id,
    this.userId,
    this.aiAstrologerId,
    this.chatMin,
    this.chatRate,
    this.inrUsdConversionRate,
    this.deduction,
    this.chatDuration,
    this.isFree,
    this.createdAt,
    this.updatedAt,
    this.astrologerId,
    this.astrologerName,
    this.image,
    this.chatCharge,
  });

  factory AiChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      AiChatHistoryModel(
        id: json["id"],
        userId: json["user_id"],
        aiAstrologerId: json["ai_astrologer_id"],
        chatMin: json["chat_min"],
        chatRate: json["chat_rate"],
        inrUsdConversionRate: json["inr_usd_conversion_rate"],
        deduction: json["deduction"],
        chatDuration: json["chat_duration"],
        isFree: json["is_free"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        astrologerId: json["astrologerId"],
        astrologerName: json["astrologerName"],
        image: json["image"],
        chatCharge: json["chat_charge"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "ai_astrologer_id": aiAstrologerId,
        "chat_min": chatMin,
        "chat_rate": chatRate,
        "inr_usd_conversion_rate": inrUsdConversionRate,
        "deduction": deduction,
        "chat_duration": chatDuration,
        "is_free": isFree,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "astrologerId": astrologerId,
        "astrologerName": astrologerName,
        "image": image,
        "chat_charge": chatCharge,
      };
}
