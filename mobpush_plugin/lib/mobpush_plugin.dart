import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'mobpush_local_notification.dart';

typedef void EventHandler(dynamic event);

class MobpushPlugin {
    // 标准: MethodChannel 统一命名：com.mob.项目xx.功能
	static const MethodChannel _channel = const MethodChannel('com.mob.mobpush.methodChannel');
	static EventChannel _channelReciever = const EventChannel('com.mob.mobpush.reciever');

	static Future<String> get getPlatformVersion async {
		return await _channel.invokeMethod('getPlatformVersion');
	}

	/*
	 *上传隐私协议.
	 */
	static Future<bool> updatePrivacyPermissionStatus(bool agree) async {
		return await _channel.invokeMethod('updatePrivacyPermissionStatus', {'status': agree});
	}

	/*
	 *获取SDK版本号.
	 */
	static Future<String> getSDKVersion() async {
		return await _channel.invokeMethod('getSDKVersion');
	}

	/*
	 *获取regId.
	 */
	static Future<Map<String, dynamic>> getRegistrationId() async {
		final Map ridMap = await _channel.invokeMethod('getRegistrationId');
		return Map<String, dynamic>.from(ridMap);
	}

	/*
	 *添加推送回调监听（接收自定义透传消息回调、接收通知消息回调、接收点击通知消息回调、接收别名或标签操作回调）.
	 */
	static Future<void> addPushReceiver(EventHandler onEvent, EventHandler onError) async {
		_channelReciever.receiveBroadcastStream().listen(onEvent, onError: onError);
	}

	/*
	 *移除推送回调监听.
	 */
	static Future<void> removePushReceiver() async {
		return await _channel.invokeMethod('removePushReceiver');
	}

	/*
	 *停止推送.
	 */
	static Future<void> stopPush() async {
		return await _channel.invokeMethod('stopPush');
	}

	/*
	 *重新打开推送服务.
	 */
	static Future<void> restartPush() async {
		return await _channel.invokeMethod('restartPush');
	}

	/*
	 *是否已停止接收推送.
	 */
	static Future<bool> isPushStopped() async {
		return await _channel.invokeMethod('isPushStopped');
	}

	/*
	 *设置别名.
	 */
	static Future<Map<String, dynamic>> setAlias(String alias) async {
		final Map resMap = await _channel.invokeMethod('setAlias', {'alias': alias});
		return Map<String, dynamic>.from(resMap);
	}

	/*
	 *获取别名.
	 */
	static Future<Map<String, dynamic>> getAlias() async {
		final Map ridMap = await _channel.invokeMethod('getAlias');
		return Map<String, dynamic>.from(ridMap);
	}

	/*
	 *删除别名.
	 */
	static Future<Map<String, dynamic>> deleteAlias() async {
		final Map ridMap = await _channel.invokeMethod('deleteAlias');
		return Map<String, dynamic>.from(ridMap);
	}

	/*
	 *添加标签.
	 */
	static Future<Map<String, dynamic>> addTags(List<String> tags) async {
		final Map resMap = await _channel.invokeMethod('addTags', {'tags': tags});
		return Map<String, dynamic>.from(resMap);
	}

	/*
	 *获取标签.
	 */
	static Future<Map<String, dynamic>> getTags() async {
		final Map ridMap = await _channel.invokeMethod('getTags');
		return Map<String, dynamic>.from(ridMap);
	}

	/*
	 *删除标签.
	 */
	static Future<Map<String, dynamic>> deleteTags(List<String> tags) async {
		final Map resMap = await _channel.invokeMethod('deleteTags', {'tags': tags});
		return Map<String, dynamic>.from(resMap);
	}

	/*
	 *清空标签.
	 */
	static Future<Map<String, dynamic>> cleanTags() async {
		final Map ridMap = await _channel.invokeMethod('cleanTags');
		return Map<String, dynamic>.from(ridMap);
	}

	/*
	 *发送本地通知.
	 */
	static Future<void> addLocalNotification(MobPushLocalNotification localNotification) async {
		return await _channel.invokeMethod('addLocalNotification', {'localNotification': json.encode(localNotification.toJson())});
	}

	/*
	 *绑定手机号.
	 */
	static Future<Map<String, dynamic>> bindPhoneNum(String phoneNum) async {
		final Map resMap = await _channel.invokeMethod('bindPhoneNum', {'phoneNum': phoneNum});
		return Map<String, dynamic>.from(resMap);
	}

	/*
	 *测试模拟推送，用于测试.
	 */
	static Future<Map<String, dynamic>> send(int type, String content, int space, String extras) async {
		final Map resMap = await _channel.invokeMethod('send', {
          'type': type,
          'content': content,
          'space': space,
          'extrasMap': extras
        });
		return Map<String, dynamic>.from(resMap);
	}

// IOS API
	/*
	 *设置远程推送，向用户授权(仅 iOS).
	 */
	static Future<void> setCustomNotification() async {
		return await _channel.invokeMethod('setCustomNotification');
	}

	/*
	 *设置远程推送环境 (仅 iOS).
	 */
	static Future<void> setAPNsForProduction(bool isPro) async {
		return await _channel.invokeMethod('setAPNsForProduction', {'isPro': isPro});
	}

	/*
	 *设置角标 (仅 iOS).
	 */
	static Future<void> setBadge(int badge) async {
		return await _channel.invokeMethod('setBadge', {'badge': badge});
	}

	/*
	 *清空角标，不清除通知栏消息记录 (仅 iOS).
	 */
	static Future<void> clearBadge() async {
		return await _channel.invokeMethod('clearBadge');
	}

	/*
	 *设置应用在前台有 Badge、Sound、Alert 三种类型
	 *默认3个选项都有
	 *iOS 10以上设置生效.(仅 iOS).
	 */
	static Future<void> setAPNsShowForegroundType(int type) async {
		return await _channel.invokeMethod('setAPNsShowForegroundType', {'type': type});
	}

	/*
	 *设置地区：regionId 默认0（国内），1:海外  (仅 iOS).
	 */
	static Future<void> setRegionId(int regionId) async {
		return await _channel.invokeMethod('setRegionId', {'regionId': regionId});
	}

	/*
	 *注册appkey和appsecret
	 * (仅 iOS).
	 */
	static Future<void> registerApp(String appKey, String appSecret) async {
		return await _channel.invokeMethod('registerApp', {'appKey': appKey, 'appSecret': appSecret});
	}

// Android API
	/*
	 *设置点击通知是否跳转默认页(仅andorid).
	 */
	static Future<void> setClickNotificationToLaunchMainActivity(bool enable) async {
		return await _channel.invokeMethod('setClickNotificationToLaunchMainActivity', {'enable': enable});
	}

	/*
	 *移除本地通知(仅andorid).
	 */
	static Future<bool> removeLocalNotification(int notificationId) async {
		return await _channel.invokeMethod('removeLocalNotification', {"notificationId": notificationId});
	}

	/*
	 *清空本地通知(仅andorid).
	 */
	static Future<bool> clearLocalNotifications() async {
		return await _channel.invokeMethod('clearLocalNotifications');
	}

	/*
	 *设置通知栏icon，不设置默认取应用icon(仅andorid).
	 */
	static Future<void> setNotifyIcon(String resId) async {
		return await _channel.invokeMethod('setNotifyIcon', {'iconRes': resId});
	}

	/*
	 *设置应用在前台时是否隐藏通知不进行显示，不设置默认不隐藏通知(仅andorid).
	 */
	static Future<void> setAppForegroundHiddenNotification(bool hidden) async {
		return await _channel.invokeMethod('setAppForegroundHiddenNotification', {'hidden': hidden});
	}

	/*
	 *设置是否显示角标(仅andorid).
	 */
	static Future<void> setShowBadge(bool show) async {
		return await _channel.invokeMethod('setShowBadge', {'show': show});
	}

	/*
	 *设置通知静音时段（推送选项）(仅andorid).
	 */
	static Future<void> setSilenceTime(int startHour, int startMinute, int endHour, int endMinute) async {
		return await _channel.invokeMethod('setSilenceTime', {
          'startHour': startHour,
          'startMinute': startMinute,
          'endHour': endHour,
          'endMinute': endMinute
        });
	}

}