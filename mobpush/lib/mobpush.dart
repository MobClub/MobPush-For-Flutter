import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'mobpush_local_notification.dart';

typedef void EventHandler(Object event);

class Mobpush {

  static MethodChannel _channel = const MethodChannel('mob.com/mobpush');
  
  static EventChannel _channelReciever = const EventChannel('mobpush_receiver');

  // 共用 API

  static Future<String> getRegistrationId() async {
    final String rid = await _channel.invokeMethod('getRegistrationId');
    return rid;
  }

  static addPushReceiver(EventHandler onEvent, EventHandler onError) {
      _channelReciever.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  static Future<void> removePushReceiver() async {
    await _channel.invokeMethod('removePushReceiver');
  }

  static Future<void> stopPush() async {
    await _channel.invokeMethod('stopPush');
  }

  static Future<void> restartPush() async {
    await _channel.invokeMethod('restartPush');
  }

  static Future<bool> isPushStopped() async {
    return await _channel.invokeMethod('isPushStopped');
  }

  static Future<void> setAlias (String alias) async {
    await _channel.invokeMethod('setAlias', {"alias":alias});
  }

  static Future<void> getAlias() async {
    await _channel.invokeMethod('getAlias');
  }

  static Future<void> deleteAlias() async {
    await _channel.invokeMethod('deleteAlias');
  }

  static Future<void> addTags (List tags) async {
    await _channel.invokeMethod('addTags', {"tags":tags});
  }

  static Future<void> getTags() async {
    await _channel.invokeMethod('getTags');
  }

  static Future<void> deleteTags (List tags) async {
    await _channel.invokeMethod('deleteTags', {"tags":tags});
  }

  static Future<void> cleanTags() async {
    await _channel.invokeMethod('cleanTags');
  }

  static Future<void> addLocalNotification(MobPushLocalNotification localNotification) async {
    await _channel.invokeMethod('addLocalNotification', {"localNotification":json.encode(localNotification.toJson())});
  }

  static Future<bool> bindPhoneNum (String phoneNum) async {
    final bool result = await _channel.invokeMethod('bindPhoneNum', {"phoneNum" : phoneNum});
    return result;
  }

  static Future<bool> send(int type, String content, int space, String extras) async {
   return await _channel.invokeMethod("send", {"type":type, "content":content, "space":space, "extras":extras});
  }

  // Android API
  static Future<void> setClickNotificationToLaunchMainActivity (bool enable) async {
      await _channel.invokeMethod('setClickNotificationToLaunchMainActivity', {"enable":enable});
  }

  static Future<bool> removeLocalNotification(int notificationId) async {
    final bool result = await _channel.invokeMethod('removeLocalNotification', {"notificationId":notificationId});
    return result;
  }

  static Future<bool> clearLocalNotifications() async {
    final bool result = await _channel.invokeMethod('clearLocalNotifications');
    return result;
  }

  static Future<void> setNotifyIcon(String resId) async {
   await _channel.invokeMethod('setNotifyIcon',{"iconRes":resId});
  }

  static Future<void> setAppForegroundHiddenNotification (bool hidden) async {
    await _channel.invokeMethod('setAppForegroundHiddenNotification', {"hidden" : hidden});
  }

  static Future<void> setSilenceTime(int startHour, int startMinute, int endHour, int endMinute) async {
   await _channel.invokeMethod('setSilenceTime',
        {"startHour":startHour, "startMinute":startMinute, "endHour":endHour, "endMinute":endMinute});
  }

  // iOS API

  static Future<void> setCustomNotification() async {
   await _channel.invokeMethod('setCustomNotification',
        );
  }

  static Future<void> setAPNsForProduction(bool isPro) async {
   await _channel.invokeMethod('setAPNsForProduction',
        {"isPro":isPro});
  }

  static Future<void> setBadge(int badge) async {
   await _channel.invokeMethod('setBadge',
        {"badge":badge});
  }

  static Future<void> clearBadge() async {
   await _channel.invokeMethod('clearBadge');
  }

}

