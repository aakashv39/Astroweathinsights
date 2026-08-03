import 'package:AstrowayCustomer/model/availableTimes_model.dart';

import 'availability_model.dart';
//astro_video : "public/storage/astrologer_videos/astrovideo_1077_1760179842.mp4"
class AstrologerModel {
  AstrologerModel({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.mobileNo,
    this.gender,
    this.birthDate,
    this.primarySkill,
    this.allSkill,
    this.languageKnown,
    this.profileImage,
    this.charge,
    this.experienceInYears,
    this.dailyContribution,
    this.hearAboutAstroguru,
    this.isWorkingOnAnotherPlatform,
    this.whyOnBoard,
    this.interviewSuitableTime,
    this.currentCity,
    this.mainSourceOfBusiness,
    this.highestQualification,
    this.degree,
    this.college,
    this.learnAstrology,
    this.astrologerCategoryId,
    this.instaProfileLink,
    this.facebookProfileLink,
    this.linkedInProfileLink,
    this.youtubeChannelLink,
    this.websiteProfileLink,
    this.isAnyBodyRefer,
    this.minimumEarning,
    this.maximumEarning,
    this.loginBio,
    this.noofforeignCountriesTravel,
    this.currentlyworkingfulltimejob,
    this.goodQuality,
    this.biggestChallenge,
    this.whatwillDo,
    this.totalOrder,
    this.isFollow,
    this.isBlock,
    this.isTimeSlotAvailable,
    this.createdAt,
    this.chatStatus,
    this.callStatus,
    this.availability,
    this.availableTimes,
    this.callWaitTime,
    this.chatWaitTime,
    this.chatMin,
    this.callMin,
    this.astrologerRating,
    this.astorlogerId,
    this.reportRate,
    this.isFreeAvailable,
    this.similiarConsultant,
    this.isBoosted,
    this.videoCallRate,
    this.courseBadges,
    this.astrologerCategory,
    this.pujas,
    this.isDiscountedPrice,
    this.audio_discounted_rate,
    this.video_discounted_rate,
    this.chat_discounted_rate,
    this.channelName,
    this.astro_video,
    this.fcmToken,
  });

  dynamic id;
  dynamic isBoosted;
  dynamic userId;
  String? name;
  String? email;
  dynamic mobileNo;
  String? gender;
  DateTime? birthDate;
  String? primarySkill;
  String? allSkill;
  String? languageKnown;
  String? profileImage;
  dynamic charge;
  dynamic experienceInYears;
  dynamic dailyContribution;
  String? hearAboutAstroguru;
  dynamic isWorkingOnAnotherPlatform;
  String? whyOnBoard;
  String? interviewSuitableTime;
  String? currentCity;
  String? mainSourceOfBusiness;
  String? highestQualification;
  bool? isTimeSlotAvailable = false;
  String? degree;
  String? college;
  String? learnAstrology;
  String? astrologerCategoryId;
  String? instaProfileLink;
  String? facebookProfileLink;
  String? linkedInProfileLink;
  String? youtubeChannelLink;
  String? websiteProfileLink;
  dynamic isAnyBodyRefer;
  dynamic minimumEarning;
  dynamic maximumEarning;
  String? loginBio;
  String? noofforeignCountriesTravel;
  String? currentlyworkingfulltimejob;
  String? goodQuality;
  String? biggestChallenge;
  String? whatwillDo;
  dynamic totalOrder;
  bool? isFollow;
  bool? isBlock;
  dynamic chatMin;
  dynamic callMin;
  Rating? astrologerRating;
  double? rating;
  DateTime? createdAt;
  List<Availability>? availability = [];
  List<AvailableTimes>? availableTimes = [];
  String? chatStatus;
  String? callStatus;
  DateTime? chatWaitTime;
  DateTime? callWaitTime;
  dynamic astorlogerId;
  dynamic reportRate;
  bool? isFreeAvailable;
  dynamic call_sections;
  dynamic chat_sections;
  dynamic live_sections;
  List<SimiliarConsultant>? similiarConsultant;
  dynamic videoCallRate;
  List<CourseBadge>? courseBadges;
  String? astrologerCategory;
  List<Puja>? pujas;
  dynamic isDiscountedPrice;
  dynamic video_discounted_rate;
  dynamic audio_discounted_rate;
  dynamic chat_discounted_rate;
  dynamic channelName;
  String? astro_video;
  String? fcmToken;

  AstrologerModel.fromJson(Map<String, dynamic> json) {
    astro_video = json['astro_video'];
    videoCallRate = json["videoCallRate"];
    isBoosted = json["is_boosted"];
    id = json["id"];
    userId = json["userId"];
    name = json["name"] ?? "";
    email = json["email"] ?? "";
    mobileNo = json["mobileNo"];
    gender = json["gender"] ?? "";
    birthDate =
        DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
    chatWaitTime = json["chatWaitTime"] != null
        ? DateTime.parse(
            json["chatWaitTime"] ?? DateTime.now().toIso8601String())
        : DateTime.now();
    callWaitTime = json["callWaitTime"] != null
        ? DateTime.parse(
            json["callWaitTime"] ?? DateTime.now().toIso8601String())
        : DateTime.now();
    primarySkill = json["primarySkill"] ?? "";
    allSkill = json["allSkill"] ?? "";
    languageKnown = json["languageKnown"] ?? "";
    chatStatus = json['chatStatus'] ?? "Online";
    callStatus = json['callStatus'] ?? "Online";
    profileImage = json["profileImage"] ?? "";
    charge = json["charge"] ?? 0;
    experienceInYears = json["experienceInYears"] ?? 0;
    dailyContribution = json["dailyContribution"] ?? 0;
    hearAboutAstroguru = json["hearAboutAstroguru"] ?? "";
    isWorkingOnAnotherPlatform = json["isWorkingOnAnotherPlatform"] ?? 0;
    whyOnBoard = json["whyOnBoard"] ?? "";
    interviewSuitableTime = json["interviewSuitableTime"] ?? "";
    currentCity = json["currentCity"] ?? "";
    mainSourceOfBusiness = json["mainSourceOfBusiness"] ?? "";
    highestQualification = json["highestQualification"] ?? "";
    degree = json["degree"] ?? "";
    college = json["college"] ?? "";
    learnAstrology = json["learnAstrology"] ?? "";
    astrologerCategoryId = json["astrologerCategoryId"] ?? "";
    instaProfileLink = json["instaProfileLink"] ?? "";
    facebookProfileLink = json["facebookProfileLink"] ?? "";
    linkedInProfileLink = json["linkedInProfileLink"] ?? "";
    youtubeChannelLink = json["youtubeChannelLink"] ?? "";
    websiteProfileLink = json["websiteProfileLink"] ?? "";
    isAnyBodyRefer = json["isAnyBodyRefer"] ?? 0;
    minimumEarning = json["minimumEarning"] ?? 0;
    maximumEarning = json["maximumEarning"] ?? 0;
    loginBio = json["loginBio"] ?? "";
    noofforeignCountriesTravel = json["NoofforeignCountriesTravel"] ?? "";
    currentlyworkingfulltimejob = json["currentlyworkingfulltimejob"] ?? "";
    goodQuality = json["goodQuality"] ?? "";
    biggestChallenge = json["biggestChallenge"] ?? "";
    whatwillDo = json["whatwillDo"] ?? "";
    totalOrder = json["totalOrder"] ?? 0;
    isFollow = json["isFollow"] ?? false;
    isBlock = json["isBlock"] ?? false;
    chatMin = json["chatMin"] ?? 0;
    callMin = json["callMin"] ?? 0;
    astorlogerId = json["astorlogerId"] ?? 0;
    reportRate = json["reportRate"] ?? 0;
    astrologerRating = Rating.fromMap(json["astrologerRating"] ?? {});
    rating =
        json["rating"] != null ? double.parse(json["rating"].toString()) : 0;
    createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at'].toString())
        : null;
    availability = json['availability'] != null
        ? List<Availability>.from(
            json['availability'].map((p) => Availability.fromJson(p)))
        : [];
    isFreeAvailable = json['isFreeAvailable'];
    call_sections = json['call_sections'];
    chat_sections = json['chat_sections'];
    live_sections = json['live_sections'];
    similiarConsultant = json['similiarConsultant'] != null
        ? List<SimiliarConsultant>.from(json["similiarConsultant"]
            .map((x) => SimiliarConsultant.fromJson(x)))
        : [];
    courseBadges = json["courseBadges"] == null
        ? []
        : List<CourseBadge>.from(
            json["courseBadges"]!.map((x) => CourseBadge.fromJson(x)));
    astrologerCategory = json["astrologerCategory"];
    isDiscountedPrice = json["isDiscountedPrice"];
    video_discounted_rate = json["video_discounted_rate"];
    audio_discounted_rate = json["audio_discounted_rate"];
    chat_discounted_rate = json["chat_discounted_rate"];
    channelName = json["channelName"];
    pujas= json["pujas"] == null ? [] : List<Puja>.from(json["pujas"]!.map((x) => Puja.fromJson(x)));
    fcmToken = json["fcmToken"];
  }

  Map<String, dynamic> toJson() => {
        'astro_video': astro_video,
        'videoCallRate': videoCallRate,
        "is_boosted": isBoosted,
        "id": id,
        "userId": userId,
        "name": name,
        "email": email,
        "mobileNo": mobileNo,
        "gender": gender,
        "birthDate": birthDate,
        "primarySkill": primarySkill,
        "allSkill": allSkill,
        "languageKnown": languageKnown,
        "profileImage": profileImage,
        "charge": charge,
        "experienceInYears": experienceInYears,
        "dailyContribution": dailyContribution,
        "hearAboutAstroguru": hearAboutAstroguru,
        "isWorkingOnAnotherPlatform": isWorkingOnAnotherPlatform,
        "whyOnBoard": whyOnBoard,
        "interviewSuitableTime": interviewSuitableTime,
        "currentCity": currentCity,
        "mainSourceOfBusiness": mainSourceOfBusiness,
        "highestQualification": highestQualification,
        "degree": degree,
        "college": college,
        "learnAstrology": learnAstrology,
        "astrologerCategoryId": astrologerCategoryId,
        "instaProfileLink": instaProfileLink,
        "facebookProfileLink": facebookProfileLink,
        "linkedInProfileLink": linkedInProfileLink,
        "youtubeChannelLink": youtubeChannelLink,
        "websiteProfileLink": websiteProfileLink,
        "isAnyBodyRefer": isAnyBodyRefer,
        "minimumEarning": minimumEarning,
        "maximumEarning": maximumEarning,
        "loginBio": loginBio,
        "NoofforeignCountriesTravel": noofforeignCountriesTravel,
        "currentlyworkingfulltimejob": currentlyworkingfulltimejob,
        "goodQuality": goodQuality,
        "biggestChallenge": biggestChallenge,
        "whatwillDo": whatwillDo,
        "totalOrder": totalOrder ?? 0,
        "isFollow": isFollow ?? false,
        "isBlock": isBlock ?? false,
        "chatMin": chatMin,
        "callMin": callMin,
        "reportRate": reportRate,
        "astrologerRating": astrologerRating!.toMap(),
        "rating": rating,
        "isFreeAvailable": isFreeAvailable,
        "call_sections": call_sections,
        "chat_sections": chat_sections,
        "live_sections": live_sections,
        "similiarConsultant": similiarConsultant != null
            ? List<dynamic>.from(similiarConsultant!.map((x) => x.toJson()))
            : null,
        "courseBadges": courseBadges == null
            ? []
            : List<dynamic>.from(courseBadges!.map((x) => x.toJson())),
        "astrologerCategory": astrologerCategory,
    "pujas": pujas == null ? [] : List<dynamic>.from(pujas!.map((x) => x.toJson())),
    "isDiscountedPrice":isDiscountedPrice,
    "video_discounted_rate":video_discounted_rate,
    "audio_discounted_rate":audio_discounted_rate,
    "chat_discounted_rate":chat_discounted_rate,
    "channelName":channelName,
    "fcmToken": fcmToken,
      };
}

class CourseBadge {
  String? courseBadge;

  CourseBadge({
    this.courseBadge,
  });

  factory CourseBadge.fromJson(Map<String, dynamic> json) => CourseBadge(
        courseBadge: json["course_badge"],
      );

  Map<String, dynamic> toJson() => {
        "course_badge": courseBadge,
      };
}

class Rating {
  Rating({
    this.oneStarRating,
    this.twoStarRating,
    this.threeStarRating,
    this.fourStarRating,
    this.fiveStarRating,
  });

  double? oneStarRating;
  double? twoStarRating;
  double? threeStarRating;
  double? fourStarRating;
  double? fiveStarRating;

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        oneStarRating: json["oneStarRating"] != null
            ? double.parse(json["oneStarRating"].toString())
            : 0,
        twoStarRating: json["twoStarRating"] != null
            ? double.parse(json["twoStarRating"].toString())
            : 0,
        threeStarRating: json["threeStarRating"] != null
            ? double.parse(json["threeStarRating"].toString())
            : 0,
        fourStarRating: json["fourStarRating"] != null
            ? double.parse(json["fourStarRating"].toString())
            : 0,
        fiveStarRating: json["fiveStarRating"] != null
            ? double.parse(json["fiveStarRating"].toString())
            : 0,
      );

  Map<String, dynamic> toMap() => {
        "oneStarRating": oneStarRating ?? 0,
        "twoStarRating": twoStarRating ?? 0,
        "threeStarRating": threeStarRating ?? 0,
        "fourStarRating": fourStarRating ?? 0,
        "fiveStarRating": fiveStarRating ?? 0,
      };
}

class SimiliarConsultant {
  String? profileImage;
  String? name;
  dynamic charge;
  String? primarySkill;
  dynamic id;

  SimiliarConsultant({
    this.profileImage,
    this.name,
    this.charge,
    this.primarySkill,
    this.id,
  });

  factory SimiliarConsultant.fromJson(Map<String, dynamic> json) =>
      SimiliarConsultant(
        profileImage: json["profileImage"] ?? "",
        name: json["name"] ?? "",
        charge: json["charge"] ?? 0,
        primarySkill: json["primarySkill"] ?? "",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "profileImage": profileImage,
        "name": name,
        "charge": charge,
        "primarySkill": primarySkill,
        "id": id,
      };
}

class Puja {
  dynamic id;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic pujaTitle;
  dynamic slug;
  dynamic pujaSubtitle;
  dynamic pujaPlace;
  dynamic longDescription;
  dynamic pujaBenefits;
  List<String>? pujaImages;
  DateTime? pujaStartDatetime;
  DateTime? pujaEndDatetime;
  dynamic pujaDuration;
  dynamic packageId;
  dynamic pujaStatus;
  dynamic astrologerId;
  dynamic pujaPrice;
  dynamic isAdminApproved;
  dynamic isPujaEnded;
  dynamic actualPujaEndtime;
  dynamic createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Puja({
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
    this.pujaDuration,
    this.packageId,
    this.pujaStatus,
    this.astrologerId,
    this.pujaPrice,
    this.isAdminApproved,
    this.isPujaEnded,
    this.actualPujaEndtime,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Puja.fromJson(Map<String, dynamic> json) => Puja(
    id: json["id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    pujaTitle: json["puja_title"],
    slug: json["slug"],
    pujaSubtitle: json["puja_subtitle"],
    pujaPlace: json["puja_place"],
    longDescription: json["long_description"],
    pujaBenefits: json["puja_benefits"],
    pujaImages: json["puja_images"] == null ? [] : List<String>.from(json["puja_images"]!.map((x) => x)),  pujaStartDatetime: json["puja_start_datetime"] == null ? null : DateTime.parse(json["puja_start_datetime"]),
    pujaEndDatetime: json["puja_end_datetime"] == null ? null : DateTime.parse(json["puja_end_datetime"]),
    pujaDuration: json["puja_duration"],
    packageId: json["package_id"],
    pujaStatus: json["puja_status"],
    astrologerId: json["astrologerId"],
    pujaPrice: json["puja_price"],
    isAdminApproved: json["isAdminApproved"],
    isPujaEnded: json["isPujaEnded"],
    actualPujaEndtime: json["actual_puja_endtime"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "puja_duration": pujaDuration,
    "package_id": packageId,
    "puja_status": pujaStatus,
    "astrologerId": astrologerId,
    "puja_price": pujaPrice,
    "isAdminApproved": isAdminApproved,
    "isPujaEnded": isPujaEnded,
    "actual_puja_endtime": actualPujaEndtime,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
