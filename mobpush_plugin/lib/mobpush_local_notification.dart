import 'mobpush_notify_message.dart';

class MobPushLocalNotification extends MobPushNotifyMessage {
  int? notificationId;

  MobPushLocalNotification(
      {this.notificationId,
      title,
      content,
      timestamp,
      subTitle,
      sound,
      badge,
      styleContent,
      messageId,
      inboxStyleContent,
      style,
      channel,
      extrasMap,
      voice,
      shake,
      light})
      : super(
            title: title,
            content: content,
            timestamp: timestamp,
            subTitle: subTitle,
            sound: sound,
            badge: badge,
            styleContent: styleContent,
            messageId: messageId,
            inboxStyleContent: inboxStyleContent,
            style: style,
            channel: channel,
            extrasMap: extrasMap,
            voice: voice,
            shake: shake,
            light: light);

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
