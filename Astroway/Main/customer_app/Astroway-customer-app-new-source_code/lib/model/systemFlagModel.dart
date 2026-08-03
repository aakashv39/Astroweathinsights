// To parse this JSON data, do
//
//     final systemFlag = systemFlagFromJson(jsonString);



class SystemFlag {
    dynamic id;
    ValueType? valueType;
    String? name;
    dynamic value;
    dynamic isActive;
    dynamic isDelete;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic displayName;
    dynamic flagGroupId;
    dynamic description;
    dynamic parentId;
    dynamic viewenable;

    SystemFlag({
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

    factory SystemFlag.fromJson(Map<String, dynamic> json) => SystemFlag(
        id: json["id"],
        valueType: valueTypeValues.map[json["valueType"]]!,
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
        "valueType": valueTypeValues.reverse[valueType],
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

enum ValueType {
    FILE,
    MULTI_SELECT,
    MULTI_SELECT_WEB_LANG,
    NUMBER,
    RADIO,
    SELECT_WALLET_TYPE,
    TEXT,
    VIDEO
}

final valueTypeValues = EnumValues({
    "File": ValueType.FILE,
    "MultiSelect": ValueType.MULTI_SELECT,
    "MultiSelectWebLang": ValueType.MULTI_SELECT_WEB_LANG,
    "Number": ValueType.NUMBER,
    "Radio": ValueType.RADIO,
    "SelectWalletType": ValueType.SELECT_WALLET_TYPE,
    "Text": ValueType.TEXT,
    "Video": ValueType.VIDEO
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
