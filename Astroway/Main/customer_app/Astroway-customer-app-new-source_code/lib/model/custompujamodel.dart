
class CustomPujaModel {
    int? id;
    int? categoryId;
    dynamic subCategoryId;
    String? pujaTitle;
    String? slug;
    dynamic pujaSubtitle;
    String? pujaPlace;
    String? longDescription;
    dynamic pujaBenefits;
    dynamic pujaImages;
    DateTime? pujaStartDatetime;
    DateTime? pujaEndDatetime;
    dynamic packageId;
    int? pujaStatus;
    int? astrologerId;
    String? pujaPrice;
    String? isAdminApproved;
    String? createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? astrologername;
    String? astrologerslug;
    int? pujaSuggestedId;

    CustomPujaModel({
        this.id,
        this.categoryId,
        this.subCategoryId,
        this.pujaTitle,
        this.slug,
        this.pujaSubtitle,
        this.pujaPlace,
        this.longDescription,
        this.pujaBenefits,
        this.pujaImages,
        this.pujaStartDatetime,
        this.pujaEndDatetime,
        this.packageId,
        this.pujaStatus,
        this.astrologerId,
        this.pujaPrice,
        this.isAdminApproved,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.astrologername,
        this.astrologerslug,
        this.pujaSuggestedId,
    });

    factory CustomPujaModel.fromJson(Map<String, dynamic> json) => CustomPujaModel(
        id: json["id"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        pujaTitle: json["puja_title"],
        slug: json["slug"],
        pujaSubtitle: json["puja_subtitle"],
        pujaPlace: json["puja_place"],
        longDescription: json["long_description"],
        pujaBenefits: json["puja_benefits"],
        pujaImages: json["puja_images"] == null ? [] : List<String>.from(json["puja_images"]!.map((x) => x)),
        pujaStartDatetime: json["puja_start_datetime"] == null ? null : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null ? null : DateTime.parse(json["puja_end_datetime"]),
        packageId: json["package_id"],
        pujaStatus: json["puja_status"],
        astrologerId: json["astrologerId"],
        pujaPrice: json["puja_price"],
        isAdminApproved: json["isAdminApproved"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        astrologername: json["astrologername"],
        astrologerslug: json["astrologerslug"],
        pujaSuggestedId: json["puja_suggested_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "puja_title": pujaTitle,
        "slug": slug,
        "puja_subtitle": pujaSubtitle,
        "puja_place": pujaPlace,
        "long_description": longDescription,
        "puja_benefits": pujaBenefits,
        "puja_images": pujaImages == null ? [] : List<dynamic>.from(pujaImages!.map((x) => x)),
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "package_id": packageId,
        "puja_status": pujaStatus,
        "astrologerId": astrologerId,
        "puja_price": pujaPrice,
        "isAdminApproved": isAdminApproved,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "astrologername": astrologername,
        "astrologerslug": astrologerslug,
        "puja_suggested_id": pujaSuggestedId,
    };
}
