

class AstroMallHistoryModel {
    dynamic id;
    dynamic userId;
    dynamic astrologerId;
    dynamic orderType;
    dynamic courseId;
    dynamic pujaId;
    dynamic packageId;
    dynamic productCategoryId;
    dynamic productId;
    dynamic orderAddressId;
    dynamic inrUsdConversionRate;
    double? payableAmount;
    dynamic walletBalanceDeducted;
    dynamic gstPercent;
    double? totalPayable;
    dynamic couponCode;
    dynamic paymentMethod;
    dynamic orderStatus;
    dynamic totalMin;
    dynamic isActive;
    dynamic isDelete;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic chatId;
    dynamic callId;
    dynamic giftId;
    dynamic productCategory;
    dynamic productImage;
    dynamic productAmount;
    dynamic description;
    dynamic orderAddressName;
    dynamic phoneNumber;
    dynamic flatNo;
    dynamic locality;
    dynamic landmark;
    dynamic city;
    dynamic state;
    dynamic country;
    dynamic pincode;
    dynamic productName;
    dynamic invoiceLink;

    AstroMallHistoryModel({
        this.id,
        this.userId,
        this.astrologerId,
        this.orderType,
        this.courseId,
        this.pujaId,
        this.packageId,
        this.productCategoryId,
        this.productId,
        this.orderAddressId,
        this.inrUsdConversionRate,
        this.payableAmount,
        this.walletBalanceDeducted,
        this.gstPercent,
        this.totalPayable,
        this.couponCode,
        this.paymentMethod,
        this.orderStatus,
        this.totalMin,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.chatId,
        this.callId,
        this.giftId,
        this.productCategory,
        this.productImage,
        this.productAmount,
        this.description,
        this.orderAddressName,
        this.phoneNumber,
        this.flatNo,
        this.locality,
        this.landmark,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.productName,
        this.invoiceLink,
    });

    factory AstroMallHistoryModel.fromJson(Map<String, dynamic> json) => AstroMallHistoryModel(
        id: json["id"],
        userId: json["userId"],
        astrologerId: json["astrologerId"],
        orderType: json["orderType"],
        courseId: json["course_id"],
        pujaId: json["puja_id"],
        packageId: json["package_id"],
        productCategoryId: json["productCategoryId"],
        productId: json["productId"],
        orderAddressId: json["orderAddressId"],
        inrUsdConversionRate: json["inr_usd_conversion_rate"],
        payableAmount: json["payableAmount"]?.toDouble(),
        walletBalanceDeducted: json["walletBalanceDeducted"],
        gstPercent: json["gstPercent"],
        totalPayable: json["totalPayable"]?.toDouble(),
        couponCode: json["couponCode"],
        paymentMethod: json["paymentMethod"],
        orderStatus: json["orderStatus"],
        totalMin: json["totalMin"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        chatId: json["chatId"],
        callId: json["callId"],
        giftId: json["giftId"],
        productCategory: json["productCategory"],
        productImage: json["productImage"],
        productAmount: json["productAmount"],
        description: json["description"],
        orderAddressName: json["orderAddressName"],
        phoneNumber: json["phoneNumber"],
        flatNo: json["flatNo"],
        locality: json["locality"],
        landmark: json["landmark"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        productName: json["productName"],
        invoiceLink: json["invoice_link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "astrologerId": astrologerId,
        "orderType": orderType,
        "course_id": courseId,
        "puja_id": pujaId,
        "package_id": packageId,
        "productCategoryId": productCategoryId,
        "productId": productId,
        "orderAddressId": orderAddressId,
        "inr_usd_conversion_rate": inrUsdConversionRate,
        "payableAmount": payableAmount,
        "walletBalanceDeducted": walletBalanceDeducted,
        "gstPercent": gstPercent,
        "totalPayable": totalPayable,
        "couponCode": couponCode,
        "paymentMethod": paymentMethod,
        "orderStatus": orderStatus,
        "totalMin": totalMin,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "chatId": chatId,
        "callId": callId,
        "giftId": giftId,
        "productCategory": productCategory,
        "productImage": productImage,
        "productAmount": productAmount,
        "description": description,
        "orderAddressName": orderAddressName,
        "phoneNumber": phoneNumber,
        "flatNo": flatNo,
        "locality": locality,
        "landmark": landmark,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "productName": productName,
        "invoice_link": invoiceLink,
    };
}

class PaymentLogs {
    dynamic totalCount;
    List<Payment>? payment;

    PaymentLogs({
        this.totalCount,
        this.payment,
    });

    factory PaymentLogs.fromJson(Map<String, dynamic> json) => PaymentLogs(
        totalCount: json["totalCount"],
        payment: json["payment"] == null ? [] : List<Payment>.from(json["payment"]!.map((x) => Payment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "payment": payment == null ? [] : List<dynamic>.from(payment!.map((x) => x.toJson())),
    };
}

class Payment {
    dynamic id;
    dynamic paymentMode;
    dynamic paymentFor;
    dynamic paymentReference;
    dynamic amount;
    dynamic userId;
    dynamic paymentStatus;
    dynamic signature;
    dynamic orderId;
    dynamic cashbackAmount;
    dynamic paymentOrderInfo;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic createdBy;
    dynamic modifiedBy;

    Payment({
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

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
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

class PujaOrder {
    dynamic totalCount;
    List<dynamic>? pujaHistory;

    PujaOrder({
        this.totalCount,
        this.pujaHistory,
    });

    factory PujaOrder.fromJson(Map<String, dynamic> json) => PujaOrder(
        totalCount: json["totalCount"],
        pujaHistory: json["pujaHistory"] == null ? [] : List<dynamic>.from(json["pujaHistory"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "pujaHistory": pujaHistory == null ? [] : List<dynamic>.from(pujaHistory!.map((x) => x)),
    };
}

class ReportRequest {
    dynamic totalCount;
    List<dynamic>? reportHistory;

    ReportRequest({
        this.totalCount,
        this.reportHistory,
    });

    factory ReportRequest.fromJson(Map<String, dynamic> json) => ReportRequest(
        totalCount: json["totalCount"],
        reportHistory: json["reportHistory"] == null ? [] : List<dynamic>.from(json["reportHistory"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "reportHistory": reportHistory == null ? [] : List<dynamic>.from(reportHistory!.map((x) => x)),
    };
}

class SendGifts {
    dynamic totalCount;
    List<dynamic>? gifts;

    SendGifts({
        this.totalCount,
        this.gifts,
    });

    factory SendGifts.fromJson(Map<String, dynamic> json) => SendGifts(
        totalCount: json["totalCount"],
        gifts: json["gifts"] == null ? [] : List<dynamic>.from(json["gifts"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "gifts": gifts == null ? [] : List<dynamic>.from(gifts!.map((x) => x)),
    };
}

class WalletTransaction {
    dynamic totalCount;
    List<Wallet>? wallet;

    WalletTransaction({
        this.totalCount,
        this.wallet,
    });

    factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        totalCount: json["totalCount"],
        wallet: json["wallet"] == null ? [] : List<Wallet>.from(json["wallet"]!.map((x) => Wallet.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "wallet": wallet == null ? [] : List<dynamic>.from(wallet!.map((x) => x.toJson())),
    };
}

class Wallet {
    dynamic id;
    dynamic inrUsdConversionRate;
    dynamic amount;
    dynamic userId;
    dynamic transactionType;
    dynamic orderId;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic createdBy;
    dynamic modifiedBy;
    dynamic isCredit;
    dynamic astrologerId;
    dynamic name;
    dynamic totalMin;

    Wallet({
        this.id,
        this.inrUsdConversionRate,
        this.amount,
        this.userId,
        this.transactionType,
        this.orderId,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.modifiedBy,
        this.isCredit,
        this.astrologerId,
        this.name,
        this.totalMin,
    });

    factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        inrUsdConversionRate: json["inr_usd_conversion_rate"],
        amount: json["amount"],
        userId: json["userId"],
        transactionType: json["transactionType"],
        orderId: json["orderId"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        isCredit: json["isCredit"],
        astrologerId: json["astrologerId"],
        name: json["name"],
        totalMin: json["totalMin"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "inr_usd_conversion_rate": inrUsdConversionRate,
        "amount": amount,
        "userId": userId,
        "transactionType": transactionType,
        "orderId": orderId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isCredit": isCredit,
        "astrologerId": astrologerId,
        "name": name,
        "totalMin": totalMin,
    };
}
