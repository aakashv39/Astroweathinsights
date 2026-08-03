

class RecommendedPujaListModel {
    int? id;
    int? categoryId;
    dynamic subCategoryId;
    String? pujaTitle;
    String? slug;
    String? pujaSubtitle;
    String? pujaPlace;
    String? longDescription;
    List<PujaBenefit>? pujaBenefits;
    List<String>? pujaImages;
    DateTime? pujaStartDatetime;
    DateTime? pujaEndDatetime;
    List<String>? packageId;
    int? pujaStatus;
    DateTime? createdAt;
    DateTime? updatedAt;
    DateTime? recommDateTime;
    dynamic pujaPackageId;
    int? recommendId;
    String? astrologerName;
    List<Package>? packages;
    dynamic isPurchased;

    RecommendedPujaListModel({
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
        this.createdAt,
        this.updatedAt,
        this.recommDateTime,
        this.pujaPackageId,
        this.recommendId,
        this.astrologerName,
        this.packages,
        this.isPurchased,
    });

    factory RecommendedPujaListModel.fromJson(Map<String, dynamic> json) => RecommendedPujaListModel(
        id: json["id"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        pujaTitle: json["puja_title"],
        slug: json["slug"],
        pujaSubtitle: json["puja_subtitle"],
        pujaPlace: json["puja_place"],
        longDescription: json["long_description"],
        pujaBenefits: json["puja_benefits"] == null ? [] : List<PujaBenefit>.from(json["puja_benefits"]!.map((x) => PujaBenefit.fromJson(x))),
        pujaImages: json["puja_images"] == null ? [] : List<String>.from(json["puja_images"]!.map((x) => x)),
        pujaStartDatetime: json["puja_start_datetime"] == null ? null : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null ? null : DateTime.parse(json["puja_end_datetime"]),
        packageId: json["package_id"] == null ? [] : List<String>.from(json["package_id"]!.map((x) => x)),
        pujaStatus: json["puja_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        recommDateTime: json["recommDateTime"] == null ? null : DateTime.parse(json["recommDateTime"]),
        pujaPackageId: json["puja_package_id"],
        recommendId: json["recommend_id"],
        astrologerName: json["astrologerName"],
        isPurchased: json["isPurchased"],
        packages: json["packages"] == null ? [] : List<Package>.from(json["packages"]!.map((x) => Package.fromJson(x))),
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
        "puja_benefits": pujaBenefits == null ? [] : List<dynamic>.from(pujaBenefits!.map((x) => x.toJson())),
        "puja_images": pujaImages == null ? [] : List<dynamic>.from(pujaImages!.map((x) => x)),
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "package_id": packageId == null ? [] : List<dynamic>.from(packageId!.map((x) => x)),
        "puja_status": pujaStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "recommDateTime": recommDateTime?.toIso8601String(),
        "puja_package_id": pujaPackageId,
        "recommend_id": recommendId,
        "astrologerName": astrologerName,
        "isPurchased": isPurchased,
        "packages": packages == null ? [] : List<dynamic>.from(packages!.map((x) => x.toJson())),
    };
}

class Package {
    int? id;
    String? title;
    String? person;
    String? packagePrice;
    String? packagePriceUsd;
    List<String>? description;
    int? packageStatus;
    DateTime? createdAt;
    DateTime? updatedAt;

    Package({
        this.id,
        this.title,
        this.person,
        this.packagePrice,
        this.packagePriceUsd,
        this.description,
        this.packageStatus,
        this.createdAt,
        this.updatedAt,
    });

    factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        title: json["title"],
        person: json["person"],
        packagePrice: json["package_price"],
        packagePriceUsd: json["package_price_usd"],
        description: json["description"] == null ? [] : List<String>.from(json["description"]!.map((x) => x)),
        packageStatus: json["package_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "person": person,
        "package_price": packagePrice,
        "package_price_usd": packagePriceUsd,
        "description": description == null ? [] : List<dynamic>.from(description!.map((x) => x)),
        "package_status": packageStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class PujaBenefit {
    String? title;
    String? description;

    PujaBenefit({
        this.title,
        this.description,
    });

    factory PujaBenefit.fromJson(Map<String, dynamic> json) => PujaBenefit(
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
    };
}
