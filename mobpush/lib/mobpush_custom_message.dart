class MobPushCustomMessage {
  String content;
  String messageId;
  int timestamp;
  Map<String, dynamic> extrasMap;

  MobPushCustomMessage(
      {this.content, this.messageId, this.timestamp, this.extrasMap});

  factory MobPushCustomMessage.fromJson(Map<String, dynamic> json) {
    return MobPushCustomMessage(
        content: json['content'],
        messageId: json['messageId'],
        timestamp: json['timestamp'],
        extrasMap: json['extrasMap']);
  }
}
