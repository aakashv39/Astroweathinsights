// To parse this JSON data, do
//
//     final aiChatidModel = aiChatidModelFromJson(jsonString);

import 'dart:convert';

AiChatidModel aiChatidModelFromJson(String str) => AiChatidModel.fromJson(json.decode(str));

String aiChatidModelToJson(AiChatidModel data) => json.encode(data.toJson());

class AiChatidModel {
    dynamic userBalance;
    RecordList? recordList;
    Currency? currency;
    dynamic status;

    AiChatidModel({
        this.userBalance,
        this.recordList,
        this.currency,
        this.status,
    });

    factory AiChatidModel.fromJson(Map<String, dynamic> json) => AiChatidModel(
        userBalance: json["user_balance"],
        recordList: json["recordList"] == null ? null : RecordList.fromJson(json["recordList"]),
        currency: json["currency"] == null ? null : Currency.fromJson(json["currency"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user_balance": userBalance,
        "recordList": recordList?.toJson(),
        "currency": currency?.toJson(),
        "status": status,
    };
}

class Currency {
    int? id;
    String? valueType;
    String? name;
    String? value;
    int? isActive;
    int? isDelete;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? displayName;
    int? flagGroupId;
    String? description;
    int? parentId;
    int? viewenable;

    Currency({
        this.id,
        this.valueType,
        this.name,
        this.value,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.displayName,
        this.flagGroupId,
        this.description,
        this.parentId,
        this.viewenable,
    });

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        valueType: json["valueType"],
        name: json["name"],
        value: json["value"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        displayName: json["displayName"],
        flagGroupId: json["flagGroupId"],
        description: json["description"],
        parentId: json["parent_id"],
        viewenable: json["viewenable"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "valueType": valueType,
        "name": name,
        "value": value,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "displayName": displayName,
        "flagGroupId": flagGroupId,
        "description": description,
        "parent_id": parentId,
        "viewenable": viewenable,
    };
}

class RecordList {
    int? id;
    String? name;
    String? image;
    dynamic about;
    dynamic astrologerCategoryId;
    dynamic primarySkill;
    dynamic allSkills;
    String? chatCharge;
    String? chatChargeUsd;
    dynamic experience;
    String? systemIntruction;
    String? slug;
    String? type;
    dynamic referralCode;
    DateTime? createdAt;
    DateTime? updatedAt;

    RecordList({
        this.id,
        this.name,
        this.image,
        this.about,
        this.astrologerCategoryId,
        this.primarySkill,
        this.allSkills,
        this.chatCharge,
        this.chatChargeUsd,
        this.experience,
        this.systemIntruction,
        this.slug,
        this.type,
        this.referralCode,
        this.createdAt,
        this.updatedAt,
    });

    factory RecordList.fromJson(Map<String, dynamic> json) => RecordList(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        about: json["about"],
        astrologerCategoryId: json["astrologerCategoryId"],
        primarySkill: json["primary_skill"],
        allSkills: json["all_skills"],
        chatCharge: json["chat_charge"],
        chatChargeUsd: json["chat_charge_usd"],
        experience: json["experience"],
        systemIntruction: json["system_intruction"],
        slug: json["slug"],
        type: json["type"],
        referralCode: json["referral_code"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "about": about,
        "astrologerCategoryId": astrologerCategoryId,
        "primary_skill": primarySkill,
        "all_skills": allSkills,
        "chat_charge": chatCharge,
        "chat_charge_usd": chatChargeUsd,
        "experience": experience,
        "system_intruction": systemIntruction,
        "slug": slug,
        "type": type,
        "referral_code": referralCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
