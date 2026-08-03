// To parse this JSON data, do
//
//     final blockKeywordModel = blockKeywordModelFromJson(jsonString);

// import 'dart:convert';

// BlockKeywordModel blockKeywordModelFromJson(String str) => BlockKeywordModel.fromJson(json.decode(str));

// String blockKeywordModelToJson(BlockKeywordModel data) => json.encode(data.toJson());

// class BlockKeywordModel {
//     String? message;
//     int? status;
//     RecordList? recordList;

//     BlockKeywordModel({
//         this.message,
//         this.status,
//         this.recordList,
//     });

//     factory BlockKeywordModel.fromJson(Map<String, dynamic> json) => BlockKeywordModel(
//         message: json["message"],
//         status: json["status"],
//         recordList: json["recordList"] == null ? null : RecordList.fromJson(json["recordList"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "message": message,
//         "status": status,
//         "recordList": recordList?.toJson(),
//     };
// }

class BlockKeywordModel {
    int? customerId;
    int? astroUserId;
    List<Keyword>? keywords;

    BlockKeywordModel({
        this.customerId,
        this.astroUserId,
        this.keywords,
    });

    factory BlockKeywordModel.fromJson(Map<String, dynamic> json) => BlockKeywordModel(
        customerId: json["customerId"],
        astroUserId: json["astroUserId"],
        keywords: json["keywords"] == null ? [] : List<Keyword>.from(json["keywords"]!.map((x) => Keyword.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "astroUserId": astroUserId,
        "keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x.toJson())),
    };
}

class Keyword {
    String? type;
    String? pattern;

    Keyword({
        this.type,
        this.pattern,
    });

    factory Keyword.fromJson(Map<String, dynamic> json) => Keyword(
        type: json["type"],
        pattern: json["pattern"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "pattern": pattern,
    };
}
