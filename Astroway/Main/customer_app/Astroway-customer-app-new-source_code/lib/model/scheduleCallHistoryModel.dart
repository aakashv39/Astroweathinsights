
class ApoinmentCallHistory {
  dynamic id;
  dynamic userId;
  dynamic astrologerId;
  dynamic callStatus;
  dynamic channelName;
  dynamic token;
  dynamic totalMin;
  dynamic inrUsdConversionRate;
  dynamic callRate;
  dynamic deduction;
  dynamic callDuration;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deductionFromAstrologer;
  dynamic sId;
  dynamic sId1;
  dynamic chatId;
  dynamic isFreeSession;
  dynamic callType;
  dynamic callMethod;
  dynamic validatedTill;
  dynamic isEmergency;
  dynamic isSchedule;
  DateTime scheduleDate;
  dynamic scheduleTime;
  String? astrologerName;
  dynamic contactNo;
  dynamic profileImage;
  dynamic charge;

  ApoinmentCallHistory({
    this.id,
    this.userId,
    this.astrologerId,
    this.callStatus,
    this.channelName,
    this.token,
    this.totalMin,
    this.inrUsdConversionRate,
    this.callRate,
    this.deduction,
    this.callDuration,
    this.createdAt,
    this.updatedAt,
    this.deductionFromAstrologer,
    this.sId,
    this.sId1,
    this.chatId,
    this.isFreeSession,
    this.callType,
    this.callMethod,
    this.validatedTill,
    this.isEmergency,
    this.isSchedule,
    required this.scheduleDate,
    this.scheduleTime,
    this.astrologerName,
    this.contactNo,
    this.profileImage,
    this.charge,
  });

  factory ApoinmentCallHistory.fromJson(Map<String, dynamic> json) => ApoinmentCallHistory(
    id: json["id"],
    userId: json["userId"],
    astrologerId: json["astrologerId"],
    callStatus: json["callStatus"],
    channelName: json["channelName"],
    token: json["token"],
    totalMin: json["totalMin"],
    inrUsdConversionRate: json["inr_usd_conversion_rate"],
    callRate: json["callRate"],
    deduction: json["deduction"],
    callDuration: json["call_duration"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deductionFromAstrologer: json["deductionFromAstrologer"],
    sId: json["sId"],
    sId1: json["sId1"],
    chatId: json["chatId"],
    isFreeSession: json["isFreeSession"],
    callType: json["call_type"],
    callMethod: json["call_method"],
    validatedTill: json["validated_till"],
    isEmergency: json["is_emergency"],
    isSchedule: json["IsSchedule"],
    scheduleDate:  DateTime.parse(json["schedule_date"]),
    scheduleTime: json["schedule_time"],
    astrologerName: json["astrologerName"],
    contactNo: json["contactNo"],
    profileImage: json["profileImage"],
    charge: json["charge"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "astrologerId": astrologerId,
    "callStatus": callStatus,
    "channelName": channelName,
    "token": token,
    "totalMin": totalMin,
    "inr_usd_conversion_rate": inrUsdConversionRate,
    "callRate": callRate,
    "deduction": deduction,
    "call_duration": callDuration,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deductionFromAstrologer": deductionFromAstrologer,
    "sId": sId,
    "sId1": sId1,
    "chatId": chatId,
    "isFreeSession": isFreeSession,
    "call_type": callType,
    "call_method": callMethod,
    "validated_till": validatedTill,
    "is_emergency": isEmergency,
    "IsSchedule": isSchedule,
    "schedule_date": "${scheduleDate.year.toString().padLeft(4, '0')}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}",
    "schedule_time": scheduleTime,
    "astrologerName": astrologerName,
    "contactNo": contactNo,
    "profileImage": profileImage,
    "charge": charge,
  };
}