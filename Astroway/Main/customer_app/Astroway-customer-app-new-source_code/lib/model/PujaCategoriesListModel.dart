// To parse this JSON data, do
//
//     final pujaCategoriesListModel = pujaCategoriesListModelFromJson(jsonString);




class PujaCategoriesListModel {
    dynamic id;
    dynamic name;
    dynamic image;
    dynamic isActive;
    dynamic isDelete;
    DateTime? createdAt;
    DateTime? updatedAt;

    PujaCategoriesListModel({
        this.id,
        this.name,
        this.image,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
    });

    factory PujaCategoriesListModel.fromJson(Map<String, dynamic> json) => PujaCategoriesListModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
