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
      this.title,
      this.content,
      this.messageId,
      this.timestamp,
      this.style,
      this.channel,
      this.voice,
      this.shake,
      this.extrasMap,
      this.inboxStyleContent,
      this.styleContent,
      this.light);

  factory MobPushNotifyMessage.fromJson(Map<String, dynamic> json) {
    return MobPushNotifyMessage(
        json['title'],
        json['content'],
        json['messageId'],
        json['timestamp'],
        json['style'],
        json['channel'],
        json['voice'],
        json['shake'],
        json['extrasMap'],
        json['inboxStyleContent'],
        json['styleContent'],
        json['light']);
  }
}
