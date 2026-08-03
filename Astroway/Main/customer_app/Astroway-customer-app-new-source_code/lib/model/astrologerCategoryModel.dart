import 'package:AstrowayCustomer/model/astrologer_model.dart';


class AstrologerCategoryModel {
  AstrologerCategoryModel({
    this.id,
    required this.name,
    required this.image,
    this.astrologers,

  });
  int? id;
  String name;
  String image;
  List<AstrologerModel>? astrologers;

  factory AstrologerCategoryModel.fromJson(Map<String, dynamic> json) =>
      AstrologerCategoryModel(
        id: json["id"],
        name: json["name"] ?? "",
        image: json["image"] ?? "",
          astrologers: json["astrologers"] == null ? [] : List<AstrologerModel>.from(json["astrologers"]!.map((x) => AstrologerModel.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
