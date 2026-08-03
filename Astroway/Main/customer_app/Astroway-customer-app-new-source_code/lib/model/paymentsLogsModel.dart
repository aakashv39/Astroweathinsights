
class PaymentsLogsModel {
    dynamic id;
    String? paymentMode;
    String? paymentFor;
    String? paymentReference;
    dynamic amount;
    dynamic userId;
    String? paymentStatus;
    dynamic signature;
    String? orderId;
    dynamic cashbackAmount;
    dynamic paymentOrderInfo;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic createdBy;
    dynamic modifiedBy;

    PaymentsLogsModel({
        this.id,
        this.paymentMode,
        this.paymentFor,
        this.paymentReference,
        this.amount,
        this.userId,
        this.paymentStatus,
        this.signature,
        this.orderId,
        this.cashbackAmount,
        this.paymentOrderInfo,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.modifiedBy,
    });

    factory PaymentsLogsModel.fromJson(Map<String, dynamic> json) => PaymentsLogsModel(
        id: json["id"],
        paymentMode: json["paymentMode"],
        paymentFor: json["payment_for"],
        paymentReference: json["paymentReference"],
        amount: json["amount"],
        userId: json["userId"],
        paymentStatus: json["paymentStatus"],
        signature: json["signature"],
        orderId: json["orderId"],
        cashbackAmount: json["cashback_amount"],
        paymentOrderInfo: json["payment_order_info"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "paymentMode": paymentMode,
        "payment_for": paymentFor,
        "paymentReference": paymentReference,
        "amount": amount,
        "userId": userId,
        "paymentStatus": paymentStatus,
        "signature": signature,
        "orderId": orderId,
        "cashback_amount": cashbackAmount,
        "payment_order_info": paymentOrderInfo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
    };
}

