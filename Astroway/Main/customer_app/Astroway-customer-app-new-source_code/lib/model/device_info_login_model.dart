class DeviceInfoLoginModel {
  DeviceInfoLoginModel({
    this.userId,
    this.appId,
    this.appVersion,
    this.deviceId,
    this.deviceLocation,
    this.deviceManufacturer,
    this.deviceModel,
    this.fcmToken,
    this.onesignalSubscriptionID,
  });

  String? userId;
  String? appId;
  String? deviceId;
  String? fcmToken;
  String? deviceLocation;
  String? deviceManufacturer;
  String? deviceModel;
  String? appVersion;
  String? onesignalSubscriptionID;

  factory DeviceInfoLoginModel.fromJson(Map<String, dynamic> json) =>
      DeviceInfoLoginModel();

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "appId": appId,
        "deviceId": deviceId,
        "fcmToken": fcmToken,
        "deviceLocation": deviceLocation ?? "",
        "deviceManufacturer": deviceManufacturer,
        "deviceModel": deviceModel,
        "appVersion": appVersion,
        "subscription_id": onesignalSubscriptionID,
      };
}
