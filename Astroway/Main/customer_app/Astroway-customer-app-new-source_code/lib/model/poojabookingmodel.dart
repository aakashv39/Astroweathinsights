
class PujaHistory {
    dynamic id;
    dynamic astrologerId;
    dynamic astrologerJoinedAt;
    dynamic userId;
    dynamic pujaId;
    dynamic pujaName;
    DateTime? pujaStartDatetime;
    DateTime? pujaEndDatetime;
    dynamic packageId;
    dynamic packageName;
    dynamic packagePerson;
    dynamic addressId;
    dynamic addressName;
    dynamic addressCountryCode;
    dynamic addressNumber;
    dynamic addressFlatno;
    dynamic addressLocality;
    dynamic addressCity;
    dynamic addressState;
    dynamic addressCountry;
    dynamic addressPincode;
    dynamic inrUsdConversionRate;
    double? orderPrice;
    dynamic orderGstAmount;
    double? orderTotalPrice;
    dynamic paymentType;
    dynamic paymentId;
    dynamic addressLandmark;
    dynamic pujaOrderStatus;
    dynamic pujaVideo;
    dynamic isPujaApproved;
    dynamic puja_refund_status;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic astrologerName;
    dynamic pujaLink;
    dynamic puja_duration;

    PujaHistory({
        this.id,
        this.astrologerId,
        this.astrologerJoinedAt,
        this.userId,
        this.pujaId,
        this.pujaName,
        this.pujaStartDatetime,
        this.pujaEndDatetime,
        this.packageId,
        this.packageName,
        this.packagePerson,
        this.addressId,
        this.addressName,
        this.addressCountryCode,
        this.addressNumber,
        this.addressFlatno,
        this.addressLocality,
        this.addressCity,
        this.addressState,
        this.addressCountry,
        this.addressPincode,
        this.inrUsdConversionRate,
        this.orderPrice,
        this.orderGstAmount,
        this.orderTotalPrice,
        this.paymentType,
        this.paymentId,
        this.addressLandmark,
        this.pujaOrderStatus,
        this.pujaVideo,
        this.isPujaApproved,
        this.createdAt,
        this.updatedAt,
        this.astrologerName,
        this.pujaLink,
        this.puja_duration,
        this.puja_refund_status,
    });

    factory PujaHistory.fromJson(Map<String, dynamic> json) => PujaHistory(
        id: json["id"],
        astrologerId: json["astrologer_id"],
        astrologerJoinedAt: json["astrologer_joined_at"],
        userId: json["user_id"],
        pujaId: json["puja_id"],
        pujaName: json["puja_name"],
        pujaStartDatetime: json["puja_start_datetime"] == null ? null : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null ? null : DateTime.parse(json["puja_end_datetime"]),
        packageId: json["package_id"],
        packageName: json["package_name"],
        packagePerson: json["package_person"],
        addressId: json["address_id"],
        addressName: json["address_name"],
        addressCountryCode: json["addressCountryCode"],
        addressNumber: json["address_number"],
        addressFlatno: json["address_flatno"],
        addressLocality: json["address_ locality"],
        addressCity: json["address_city"],
        addressState: json["address_state"],
        addressCountry: json["address_country"],
        addressPincode: json["address_pincode"],
        inrUsdConversionRate: json["inr_usd_conversion_rate"],
        orderPrice: json["order_price"]?.toDouble(),
        orderGstAmount: json["order_gst_amount"],
        orderTotalPrice: json["order_total_price"]?.toDouble(),
        paymentType: json["payment_type"],
        paymentId: json["payment_id"],
        addressLandmark: json["address_landmark"],
        pujaOrderStatus: json["puja_order_status"],
        pujaVideo: json["puja_video"],
        isPujaApproved: json["is_puja_approved"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        astrologerName: json["astrologer_name"],
        pujaLink: json["pujaLink"],
        puja_duration: json['puja_duration'],
        puja_refund_status: json['puja_refund_status'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_id": astrologerId,
        "astrologer_joined_at": astrologerJoinedAt,
        "user_id": userId,
        "puja_id": pujaId,
        "puja_name": pujaName,
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "package_id": packageId,
        "package_name": packageName,
        "package_person": packagePerson,
        "address_id": addressId,
        "address_name": addressName,
        "addressCountryCode": addressCountryCode,
        "address_number": addressNumber,
        "address_flatno": addressFlatno,
        "address_ locality": addressLocality,
        "address_city": addressCity,
        "address_state": addressState,
        "address_country": addressCountry,
        "address_pincode": addressPincode,
        "inr_usd_conversion_rate": inrUsdConversionRate,
        "order_price": orderPrice,
        "order_gst_amount": orderGstAmount,
        "order_total_price": orderTotalPrice,
        "payment_type": paymentType,
        "payment_id": paymentId,
        "address_landmark": addressLandmark,
        "puja_order_status": pujaOrderStatus,
        "puja_video": pujaVideo,
        "is_puja_approved": isPujaApproved,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "astrologer_name": astrologerName,
        "pujaLink": pujaLink,
        "puja_duration": puja_duration,
        "puja_refund_status": puja_refund_status
    };
}