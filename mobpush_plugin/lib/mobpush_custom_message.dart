/*
 * MobPush自定义透传消息实体
 */
class MobPushCustomMessage {
  /*
   * 消息内容
   */
  String content;
  /*
   * 消息Id
   */
  String? messageId;
  /*
   * 消息时间戳
   */
  int? timestamp;
  /*
   * 消息附加数据
   */
  Map<String, dynamic>? extrasMap;

  MobPushCustomMessage(
      this.content, this.messageId, this.timestamp, this.extrasMap);

  factory MobPushCustomMessage.fromJson(Map<String, dynamic> json) {
    return MobPushCustomMessage(json['content'], json['messageId'],
        json['timeStamp'], json['extrasMap']);
  }
}
