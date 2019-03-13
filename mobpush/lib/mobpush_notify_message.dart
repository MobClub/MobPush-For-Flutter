class MobPushNotifyMessage {
  String title;
  String content;
  String styleContent;
  String messageId;
  List<String> inboxStyleContent;
  int timestamp;
  int style;
  int channel;
  Map<String, dynamic> extrasMap;
  bool voice;
  bool shake;
  bool light;

  MobPushNotifyMessage(
      {this.title,
      this.content,
      this.styleContent,
      this.messageId,
      this.inboxStyleContent,
      this.timestamp,
      this.style,
      this.channel,
      this.extrasMap,
      this.voice,
      this.shake,
      this.light});

  factory MobPushNotifyMessage.fromJson(Map<String, dynamic> json) {
    return MobPushNotifyMessage(
        title: json['title'],
        content: json['content'],
        styleContent: json['styleContent'],
        messageId: json['messageId'],
        inboxStyleContent: json['inboxStyleContent'],
        timestamp: json['timestamp'],
        style: json['style'],
        channel: json['channel'],
        extrasMap: json['extrasMap'],
        voice: json['voice'],
        shake: json['shake'],
        light: json['light']);
  }
}
