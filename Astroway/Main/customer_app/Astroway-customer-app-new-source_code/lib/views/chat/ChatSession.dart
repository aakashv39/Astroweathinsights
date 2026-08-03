class ChatSession {
  final String sessionId;
  final int customerId;
  final int astrologerId;
  final String fireBasechatId;
  final String customerName;
  final String customerProfile;
  final String chatduration;
  final dynamic astrouserID;
  final dynamic subscriptionId;
  final String? lastSaved;

  ChatSession({
    required this.sessionId,
    required this.customerId,
    required this.astrologerId,
    required this.fireBasechatId,
    required this.customerName,
    required this.customerProfile,
    required this.chatduration,
    required this.astrouserID,
    required this.subscriptionId,
    this.lastSaved,
  });

  /// Convert JSON (Map) → ChatSession
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json["chatId"] ?? "",
      customerId: json["customerId"] ?? "",
      astrologerId: json["astrologerId"] ?? "",
      fireBasechatId: json["fireBasechatId"] ?? "",
      customerName: json["customerName"] ?? "",
      customerProfile: json["customerProfile"] ?? "",
      chatduration: json["chatDuration"] ?? "0",
      astrouserID: json["astroUserId"] ?? "",
      subscriptionId: json["subscriptionId"] ?? "",
      lastSaved: json["lastSaved"] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatId": sessionId,
      "customerId": customerId,
      "astrologerId": astrologerId,
      "fireBasechatId": fireBasechatId,
      "customerName": customerName,
      "customerProfile": customerProfile,
      "chatDuration": chatduration,
      "astroUserId": astrouserID,
      "subscriptionId": subscriptionId,
      "lastSaved": lastSaved ?? DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return "ChatSession(sessionId: $sessionId, customerId: $customerId, astrologerId: $astrologerId, duration: $chatduration, lastSaved: $lastSaved)";
  }
}
