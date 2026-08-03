// To parse this JSON data, do
//
//     final allhistorydetailmodel = allhistorydetailmodelFromJson(jsonString);

// List<RecordList>.from(json["recordList"]!.map((x) => RecordList.fromJson(x))),
   

class Allhistorydetailmodel {
    int? id;
    String? name;
    String? contactNo;
    String? email;
    dynamic password;
    dynamic birthDate;
    dynamic birthTime;
    dynamic profile;
    dynamic birthPlace;
    dynamic addressLine1;
    dynamic addressLine2;
    String? country;
    dynamic location;
    dynamic pincode;
    dynamic gender;
    String? referralToken;
    int? referrerId;
    int? isActive;
    int? isDelete;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic fcmToken;
    dynamic token;
    dynamic expirationDate;
    String? countryCode;
    dynamic deletedAt;
    List<dynamic>? follower;
    Orders? orders;
    SendGifts? sendGifts;
    ChatRequest? chatRequest;
    CallRequest? callRequest;
    ReportRequest? reportRequest;
    WalletTransaction? walletTransaction;
    PaymentLogs? paymentLogs;
    PujaOrder? pujaOrder;
    List<dynamic>? notification;

    Allhistorydetailmodel({
        this.id,
        this.name,
        this.contactNo,
        this.email,
        this.password,
        this.birthDate,
        this.birthTime,
        this.profile,
        this.birthPlace,
        this.addressLine1,
        this.addressLine2,
        this.country,
        this.location,
        this.pincode,
        this.gender,
        this.referralToken,
        this.referrerId,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.fcmToken,
        this.token,
        this.expirationDate,
        this.countryCode,
        this.deletedAt,
        this.follower,
        this.orders,
        this.sendGifts,
        this.chatRequest,
        this.callRequest,
        this.reportRequest,
        this.walletTransaction,
        this.paymentLogs,
        this.pujaOrder,
        this.notification,
    });

    factory Allhistorydetailmodel.fromJson(Map<String, dynamic> json) => Allhistorydetailmodel(
        id: json["id"],
        name: json["name"],
        contactNo: json["contactNo"],
        email: json["email"],
        password: json["password"],
        birthDate: json["birthDate"],
        birthTime: json["birthTime"],
        profile: json["profile"],
        birthPlace: json["birthPlace"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        country: json["country"],
        location: json["location"],
        pincode: json["pincode"],
        gender: json["gender"],
        referralToken: json["referral_token"],
        referrerId: json["referrer_id"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        fcmToken: json["fcm_token"],
        token: json["token"],
        expirationDate: json["expirationDate"],
        countryCode: json["countryCode"],
        deletedAt: json["deleted_at"],
        follower: json["follower"] == null ? [] : List<dynamic>.from(json["follower"]!.map((x) => x)),
        orders: json["orders"] == null ? null : Orders.fromJson(json["orders"]),
        sendGifts: json["sendGifts"] == null ? null : SendGifts.fromJson(json["sendGifts"]),
        chatRequest: json["chatRequest"] == null ? null : ChatRequest.fromJson(json["chatRequest"]),
        callRequest: json["callRequest"] == null ? null : CallRequest.fromJson(json["callRequest"]),
        reportRequest: json["reportRequest"] == null ? null : ReportRequest.fromJson(json["reportRequest"]),
        walletTransaction: json["walletTransaction"] == null ? null : WalletTransaction.fromJson(json["walletTransaction"]),
        paymentLogs: json["paymentLogs"] == null ? null : PaymentLogs.fromJson(json["paymentLogs"]),
        pujaOrder: json["pujaOrder"] == null ? null : PujaOrder.fromJson(json["pujaOrder"]),
        notification: json["notification"] == null ? [] : List<dynamic>.from(json["notification"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contactNo": contactNo,
        "email": email,
        "password": password,
        "birthDate": birthDate,
        "birthTime": birthTime,
        "profile": profile,
        "birthPlace": birthPlace,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "country": country,
        "location": location,
        "pincode": pincode,
        "gender": gender,
        "referral_token": referralToken,
        "referrer_id": referrerId,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "fcm_token": fcmToken,
        "token": token,
        "expirationDate": expirationDate,
        "countryCode": countryCode,
        "deleted_at": deletedAt,
        "follower": follower == null ? [] : List<dynamic>.from(follower!.map((x) => x)),
        "orders": orders?.toJson(),
        "sendGifts": sendGifts?.toJson(),
        "chatRequest": chatRequest?.toJson(),
        "callRequest": callRequest?.toJson(),
        "reportRequest": reportRequest?.toJson(),
        "walletTransaction": walletTransaction?.toJson(),
        "paymentLogs": paymentLogs?.toJson(),
        "pujaOrder": pujaOrder?.toJson(),
        "notification": notification == null ? [] : List<dynamic>.from(notification!.map((x) => x)),
    };
}

class CallRequest {
    int? totalCount;
    List<dynamic>? callHistory;

    CallRequest({
        this.totalCount,
        this.callHistory,
    });

    factory CallRequest.fromJson(Map<String, dynamic> json) => CallRequest(
        totalCount: json["totalCount"],
        callHistory: json["callHistory"] == null ? [] : List<dynamic>.from(json["callHistory"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "callHistory": callHistory == null ? [] : List<dynamic>.from(callHistory!.map((x) => x)),
    };
}

class ChatRequest {
    int? totalCount;
    List<dynamic>? chatHistory;

    ChatRequest({
        this.totalCount,
        this.chatHistory,
    });

    factory ChatRequest.fromJson(Map<String, dynamic> json) => ChatRequest(
        totalCount: json["totalCount"],
        chatHistory: json["chatHistory"] == null ? [] : List<dynamic>.from(json["chatHistory"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "chatHistory": chatHistory == null ? [] : List<dynamic>.from(chatHistory!.map((x) => x)),
    };
}

class Orders {
    int? totalCount;
    List<dynamic>? order;

    Orders({
        this.totalCount,
        this.order,
    });

    factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        totalCount: json["totalCount"],
        order: json["order"] == null ? [] : List<dynamic>.from(json["order"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "order": order == null ? [] : List<dynamic>.from(order!.map((x) => x)),
    };
}

class PaymentLogs {
    int? totalCount;
    List<dynamic>? payment;

    PaymentLogs({
        this.totalCount,
        this.payment,
    });

    factory PaymentLogs.fromJson(Map<String, dynamic> json) => PaymentLogs(
        totalCount: json["totalCount"],
        payment: json["payment"] == null ? [] : List<dynamic>.from(json["payment"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "payment": payment == null ? [] : List<dynamic>.from(payment!.map((x) => x)),
    };
}

class PujaOrder {
    int? totalCount;
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
    int? totalCount;
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
    int? totalCount;
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
    int? totalCount;
    List<dynamic>? wallet;

    WalletTransaction({
        this.totalCount,
        this.wallet,
    });

    factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        totalCount: json["totalCount"],
        wallet: json["wallet"] == null ? [] : List<dynamic>.from(json["wallet"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "wallet": wallet == null ? [] : List<dynamic>.from(wallet!.map((x) => x)),
    };
}
