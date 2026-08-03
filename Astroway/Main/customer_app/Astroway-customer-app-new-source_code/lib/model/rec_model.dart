class RecModel {
  int? id;
  int? productId;
  int? userId;
  int? astrologerId;
  DateTime? recommDateTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? astrologerName;
  String? productName;
  String? productImage;
  int? amount;

  RecModel({
    this.id,
    this.productId,
    this.userId,
    this.astrologerId,
    this.recommDateTime,
    this.createdAt,
    this.updatedAt,
    this.astrologerName,
    this.productName,
    this.productImage,
    this.amount,
  });

  /// Factory method to create an empty instance of RecommendedModel
  factory RecModel.empty() {
    return RecModel(
      id: 0,
      productId: 0,
      userId: 0,
      astrologerId: 0,
      recommDateTime: null,
      createdAt: null,
      updatedAt: null,
      astrologerName: "",
      productName: "",
      productImage: "",
      amount: 0,
    );
  }
  factory RecModel.fromJson(Map<String, dynamic> json) => RecModel(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        astrologerId: json["astrologerId"],
        recommDateTime: json["recommDateTime"] == null
            ? null
            : DateTime.parse(json["recommDateTime"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        astrologerName: json["astrologerName"],
        productName: json["productName"],
        productImage: json["productImage"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
        "astrologerId": astrologerId,
        "recommDateTime": recommDateTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "astrologerName": astrologerName,
        "productName": productName,
        "productImage": productImage,
        "amount": amount,
      };
}
