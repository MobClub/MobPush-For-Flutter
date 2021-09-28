import 'mobpush_notify_message.dart';

/*
 * MobPush本地通知实体
 */
class MobPushLocalNotification extends MobPushNotifyMessage {
  /*
   * 本地通知id，仅 Android 属性
   */
  int? notificationId;

  MobPushLocalNotification({
      this.notificationId,
      title,
      content,
      messageId,
      inboxStyleContent,
      timestamp,
      style,
      channel,
      extrasMap,
      voice,
      shake,
      styleContent,
      light,
      badge,
      sound,
      subTitle})
      : super(title: title, content: content, messageId: messageId, timestamp: timestamp, style: style, channel: channel, voice: voice,
            shake: shake, extrasMap: extrasMap, inboxStyleContent: inboxStyleContent, styleContent: styleContent, light: light, badge: badge, sound: sound, subTitle: subTitle);

  // MobPushLocalNotification(title, content, timestamp, badge, sound, subTitle);

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
        'title': title,
        'content': content,
        'messageId': messageId,
        'inboxStyleContent': inboxStyleContent,
        'timestamp': timestamp,
        'style': style,
        'channel': channel,
        'extrasMap': extrasMap,
        'voice': voice,
        'shake': shake,
        'styleContent': styleContent,
        'light': light,
        'badge': badge,
        'sound': sound,
        'subTitle': subTitle
      };
}
