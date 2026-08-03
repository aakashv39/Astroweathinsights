import 'device_info_login_model.dart';

class LoginModel {
  LoginModel({
    this.contactNo,
    this.username,
    this.deviceInfo,
    this.countryCode,
    this.email,
    this.country,
    this.referalCode,
  });

  String? contactNo;
  String? username;
  String? email;
  String? countryCode;
  String? country;
  DeviceInfoLoginModel? deviceInfo = DeviceInfoLoginModel();
  dynamic referalCode;
  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        contactNo: json["contactNo"],
        countryCode: json["countryCode"],
        email: json["email"],
        username: json["name"],
        country: json["country"],
        referalCode: json["referral_token"],
      );

  Map<String, dynamic> toJson() => {
        "contactNo": contactNo,
        "userDeviceDetails": deviceInfo,
        "countryCode": countryCode,
        "email": email,
        "name": username,
        "country": country,
        "referral_token": referalCode
      };
}
