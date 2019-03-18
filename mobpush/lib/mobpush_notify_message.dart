/**
 * MobPush通知消息实体
 */
class MobPushNotifyMessage {
  /**
   * 消息标题
   */
  String title;

  /**
   * 消息内容
   */
  String content;

  /**
   * 大段文本和大图模式的样式内容
   */
  String styleContent;

  /**
   * 消息Id
   */
  String messageId;

  /**
   * 收件箱样式的内容
   */
  List<String> inboxStyleContent;

  /**
   * 消息时间戳
   */
  int timestamp;

  /**
   * 通知样式 android:(0：普通样式；1：大段文本；2：大图样式；3：收件箱样式)
   */
  int style;

  /**
   * 推送通道：android:(0：mobPush；1：华为；2：小米；3：魅族；4：FCM；5：vivo)
   */
  int channel;

  /**
   * 消息附加数据
   */
  Map<String, dynamic> extrasMap;

  /**
   * 通知提示音
   */
  bool voice;

  /**
   * 通知震动
   */
  bool shake;

  /**
   * 通知呼吸灯
   */
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
