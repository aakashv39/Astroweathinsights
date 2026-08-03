// To parse this JSON data, do
//
//     final doshaDetailsModel = doshaDetailsModelFromJson(jsonString);

import 'dart:convert';

DoshaDetailsModel doshaDetailsModelFromJson(String str) =>
    DoshaDetailsModel.fromJson(json.decode(str));

String doshaDetailsModelToJson(DoshaDetailsModel data) =>
    json.encode(data.toJson());

class DoshaDetailsModel {
  String? message;
  MangalDosh? mangalDosh;
  Dosh? kaalsarpDosh;
  ManglikDosh? manglikDosh;
  Dosh? pitraDosh;
  PapasamayaDosh? papasamayaDosh;
  int? status;

  DoshaDetailsModel({
    this.message,
    this.mangalDosh,
    this.kaalsarpDosh,
    this.manglikDosh,
    this.pitraDosh,
    this.papasamayaDosh,
    this.status,
  });

  factory DoshaDetailsModel.fromJson(Map<String, dynamic> json) =>
      DoshaDetailsModel(
        message: json["message"],
        mangalDosh: json["mangalDosh"] == null
            ? null
            : MangalDosh.fromJson(json["mangalDosh"]),
        kaalsarpDosh: json["kaalsarpDosh"] == null
            ? null
            : Dosh.fromJson(json["kaalsarpDosh"]),
        manglikDosh: json["manglikDosh"] == null
            ? null
            : ManglikDosh.fromJson(json["manglikDosh"]),
        pitraDosh:
            json["pitraDosh"] == null ? null : Dosh.fromJson(json["pitraDosh"]),
        papasamayaDosh: json["papasamayaDosh"] == null
            ? null
            : PapasamayaDosh.fromJson(json["papasamayaDosh"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "mangalDosh": mangalDosh?.toJson(),
        "kaalsarpDosh": kaalsarpDosh?.toJson(),
        "manglikDosh": manglikDosh?.toJson(),
        "pitraDosh": pitraDosh?.toJson(),
        "papasamayaDosh": papasamayaDosh?.toJson(),
        "status": status,
      };
}

class Dosh {
  int? status;
  KaalsarpDoshResponse? response;

  Dosh({
    this.status,
    this.response,
  });

  factory Dosh.fromJson(Map<String, dynamic> json) => Dosh(
        status: json["status"],
        response: json["response"] == null
            ? null
            : KaalsarpDoshResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class KaalsarpDoshResponse {
  bool? isDoshaPresent;
  String? botResponse;
  List<String>? remedies;
  List<String>? effects;

  KaalsarpDoshResponse({
    this.isDoshaPresent,
    this.botResponse,
    this.remedies,
    this.effects,
  });

  factory KaalsarpDoshResponse.fromJson(Map<String, dynamic> json) =>
      KaalsarpDoshResponse(
        isDoshaPresent: json["is_dosha_present"],
        botResponse: json["bot_response"],
        remedies: json["remedies"] == null
            ? []
            : List<String>.from(json["remedies"]!.map((x) => x)),
        effects: json["effects"] == null
            ? []
            : List<String>.from(json["effects"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "is_dosha_present": isDoshaPresent,
        "bot_response": botResponse,
        "remedies":
            remedies == null ? [] : List<dynamic>.from(remedies!.map((x) => x)),
        "effects":
            effects == null ? [] : List<dynamic>.from(effects!.map((x) => x)),
      };
}

class MangalDosh {
  int? status;
  MangalDoshResponse? response;

  MangalDosh({
    this.status,
    this.response,
  });

  factory MangalDosh.fromJson(Map<String, dynamic> json) => MangalDosh(
        status: json["status"],
        response: json["response"] == null
            ? null
            : MangalDoshResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class MangalDoshResponse {
  Factors? factors;
  bool? isDoshaPresentMarsFromLagna;
  bool? isDoshaPresentMarsFromMoon;
  bool? isDoshaPresent;
  bool? isAnshik;
  String? botResponse;
  int? score;
  Cancellation? cancellation;

  MangalDoshResponse({
    this.factors,
    this.isDoshaPresentMarsFromLagna,
    this.isDoshaPresentMarsFromMoon,
    this.isDoshaPresent,
    this.isAnshik,
    this.botResponse,
    this.score,
    this.cancellation,
  });

  factory MangalDoshResponse.fromJson(Map<String, dynamic> json) =>
      MangalDoshResponse(
        factors:
            json["factors"] == null ? null : Factors.fromJson(json["factors"]),
        isDoshaPresentMarsFromLagna: json["is_dosha_present_mars_from_lagna"],
        isDoshaPresentMarsFromMoon: json["is_dosha_present_mars_from_moon"],
        isDoshaPresent: json["is_dosha_present"],
        isAnshik: json["is_anshik"],
        botResponse: json["bot_response"],
        score: json["score"],
        cancellation: json["cancellation"] == null
            ? null
            : Cancellation.fromJson(json["cancellation"]),
      );

  Map<String, dynamic> toJson() => {
        "factors": factors?.toJson(),
        "is_dosha_present_mars_from_lagna": isDoshaPresentMarsFromLagna,
        "is_dosha_present_mars_from_moon": isDoshaPresentMarsFromMoon,
        "is_dosha_present": isDoshaPresent,
        "is_anshik": isAnshik,
        "bot_response": botResponse,
        "score": score,
        "cancellation": cancellation?.toJson(),
      };
}

class Cancellation {
  int? cancellationScore;
  List<dynamic>? cancellationReason;

  Cancellation({
    this.cancellationScore,
    this.cancellationReason,
  });

  factory Cancellation.fromJson(Map<String, dynamic> json) => Cancellation(
        cancellationScore: json["cancellationScore"],
        cancellationReason: json["cancellationReason"] == null
            ? []
            : List<dynamic>.from(json["cancellationReason"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cancellationScore": cancellationScore,
        "cancellationReason": cancellationReason == null
            ? []
            : List<dynamic>.from(cancellationReason!.map((x) => x)),
      };
}

class Factors {
  String? mars;
  String? venus;

  Factors({
    this.mars,
    this.venus,
  });

  factory Factors.fromJson(Map<String, dynamic> json) => Factors(
        mars: json["mars"],
        venus: json["venus"],
      );

  Map<String, dynamic> toJson() => {
        "mars": mars,
        "venus": venus,
      };
}

class ManglikDosh {
  int? status;
  ManglikDoshResponse? response;

  ManglikDosh({
    this.status,
    this.response,
  });

  factory ManglikDosh.fromJson(Map<String, dynamic> json) => ManglikDosh(
        status: json["status"],
        response: json["response"] == null
            ? null
            : ManglikDoshResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class ManglikDoshResponse {
  bool? manglikByMars;
  List<String>? factors;
  String? botResponse;
  bool? manglikBySaturn;
  bool? manglikByRahuketu;
  List<String>? aspects;
  int? score;

  ManglikDoshResponse({
    this.manglikByMars,
    this.factors,
    this.botResponse,
    this.manglikBySaturn,
    this.manglikByRahuketu,
    this.aspects,
    this.score,
  });

  factory ManglikDoshResponse.fromJson(Map<String, dynamic> json) =>
      ManglikDoshResponse(
        manglikByMars: json["manglik_by_mars"],
        factors: json["factors"] == null
            ? []
            : List<String>.from(json["factors"]!.map((x) => x)),
        botResponse: json["bot_response"],
        manglikBySaturn: json["manglik_by_saturn"],
        manglikByRahuketu: json["manglik_by_rahuketu"],
        aspects: json["aspects"] == null
            ? []
            : List<String>.from(json["aspects"]!.map((x) => x)),
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "manglik_by_mars": manglikByMars,
        "factors":
            factors == null ? [] : List<dynamic>.from(factors!.map((x) => x)),
        "bot_response": botResponse,
        "manglik_by_saturn": manglikBySaturn,
        "manglik_by_rahuketu": manglikByRahuketu,
        "aspects":
            aspects == null ? [] : List<dynamic>.from(aspects!.map((x) => x)),
        "score": score,
      };
}

class PapasamayaDosh {
  int? status;
  PapasamayaDoshResponse? response;

  PapasamayaDosh({
    this.status,
    this.response,
  });

  factory PapasamayaDosh.fromJson(Map<String, dynamic> json) => PapasamayaDosh(
        status: json["status"],
        response: json["response"] == null
            ? null
            : PapasamayaDoshResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class PapasamayaDoshResponse {
  int? rahuPapa;
  double? sunPapa;
  double? saturnPapa;
  int? marsPapa;

  PapasamayaDoshResponse({
    this.rahuPapa,
    this.sunPapa,
    this.saturnPapa,
    this.marsPapa,
  });

  factory PapasamayaDoshResponse.fromJson(Map<String, dynamic> json) =>
      PapasamayaDoshResponse(
        rahuPapa: json["rahu_papa"],
        sunPapa: json["sun_papa"]?.toDouble(),
        saturnPapa: json["saturn_papa"]?.toDouble(),
        marsPapa: json["mars_papa"],
      );

  Map<String, dynamic> toJson() => {
        "rahu_papa": rahuPapa,
        "sun_papa": sunPapa,
        "saturn_papa": saturnPapa,
        "mars_papa": marsPapa,
      };
}
