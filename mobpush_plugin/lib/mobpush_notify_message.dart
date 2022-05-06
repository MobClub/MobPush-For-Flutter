
class MobPushNotifyMessage {
// iOS Properties
	String? subTitle;
	String? sound;
	int? badge;
// Android Properties
	String? styleContent;
	String? messageId;
	List<String>? inboxStyleContent;
	int? style;
	int? channel;
	Map<String, dynamic>? extrasMap;
	bool? voice;
	bool? shake;
	bool? light;
	String? title;
	String content;
	int? timestamp;

	MobPushNotifyMessage({this.title, required this.content, this.timestamp, this.subTitle, this.sound, this.badge, this.styleContent, required this.messageId, this.inboxStyleContent, this.style, this.channel, this.extrasMap, this.voice, this.shake, this.light});

	factory MobPushNotifyMessage.fromJson(Map<String, dynamic> json) {
		return MobPushNotifyMessage(
                  title: json['title'],
                  content: json['content'],
                  messageId: json['messageId'],
                  timestamp: json['timestamp'],
                  style: json['style'],
                  channel: json['channel'],
                  voice: json['voice'],
                  shake: json['shake'],
                  extrasMap: json['extrasMap'],
                  inboxStyleContent: json['inboxStyleContent'],
                  styleContent: json['styleContent'],
                  light: json['light'],
                  badge: json['badge'],
                  sound: json['sound'],
                  subTitle: json['subTitle']);
	}

}