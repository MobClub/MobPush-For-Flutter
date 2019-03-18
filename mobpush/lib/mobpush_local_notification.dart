import 'mobpush_notify_message.dart';

class MobPushLocalNotification extends MobPushNotifyMessage {
  int notificationId;

  MobPushLocalNotification(
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
      light)
      : super(title, content, messageId, timestamp, style, channel, voice,
            shake, extrasMap, inboxStyleContent, styleContent, light);

  Map<String, dynamic> toJson() =>
      {
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
      };
}
