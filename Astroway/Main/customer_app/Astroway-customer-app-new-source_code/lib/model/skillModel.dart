class SkillModel {
  SkillModel({
    this.id,
    required this.name,
    this.isSelected,
  });
  int? id;
  String name;
  bool? isSelected = false;

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        id: json["id"],
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
