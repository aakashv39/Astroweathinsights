// To parse this JSON data, do
//
//     final referalModel = referalModelFromJson(jsonString);

class ReferalModel {
    int? id;
    String? name;
    dynamic contactNo;
    String? email;
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
    dynamic referrerId;
    int? isActive;
    int? isDelete;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic fcmToken;
    dynamic token;
    dynamic expirationDate;
    dynamic countryCode;
    dynamic deletedAt;

    ReferalModel({
        this.id,
        this.name,
        this.contactNo,
        this.email,
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
    });

    factory ReferalModel.fromJson(Map<String, dynamic> json) => ReferalModel(
        id: json["id"],
        name: json["name"],
        contactNo: json["contactNo"],
        email: json["email"],
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contactNo": contactNo,
        "email": email,
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
    };
}
