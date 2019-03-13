import 'dart:async';
import 'package:flutter/services.dart';

typedef void EventHandler(Object event);

class Mobpush {
  static MethodChannel _channel = const MethodChannel('mobpush');
  static EventChannel _channelReciever = const EventChannel('mobpush_receiver');

  static Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getRegistrationId() async {
    final String rid = await _channel.invokeMethod('getRegistrationId');
    return rid;
  }

  static addPushReceiver(EventHandler onEvent, EventHandler onError) {
      _channelReciever.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  static void removePushReceiver() {
    _channel.invokeMethod('removePushReceiver');
  }

  static void setClickNotificationToLaunchMainActivity (bool enable) {
    _channel.invokeMethod('setClickNotificationToLaunchMainActivity', {"enable":enable});
  }

  static void stopPush() {
    _channel.invokeMethod('stopPush');
  }

  static void restartPush() {
    _channel.invokeMethod('restartPush');
  }

  static Future<bool> isPushStopped() async {
    return await _channel.invokeMethod('isPushStopped');
  }

  static void setAlias (String alias) {
    _channel.invokeMethod('setAlias', {"alias":alias});
  }

  static void getAlias() {
    _channel.invokeMethod('getAlias');
  }

  static void deleteAlias() {
    _channel.invokeMethod('deleteAlias');
  }

  static void addTags (List tags) {
    _channel.invokeMethod('addTags', {"tags":tags});
  }

  static void getTags() {
    _channel.invokeMethod('getTags');
  }

  static void deleteTags (List tags) {
    _channel.invokeMethod('deleteTags', {"tags":tags});
  }

  static void cleanTags() {
    _channel.invokeMethod('cleanTags');
  }

  static void setSilenceTime(int startHour, int startMinute, int endHour, int endMinute) {
   _channel.invokeMethod('setSilenceTime',
        {"startHour":startHour, "startMinute":startMinute, "endHour":endHour, "endMinute":endMinute});
  }

  static void addLocalNotification() {
    _channel.invokeMethod('addLocalNotification');
  }

  static Future<bool> removeLocalNotification() async {
    final bool result = await _channel.invokeMethod('removeLocalNotification');
    return result;
  }

  static Future<bool> clearLocalNotifications() async {
    final bool result = await _channel.invokeMethod('clearLocalNotifications');
    return result;
  }

  static void setNotifyIcon(String resId) {
    _channel.invokeMethod('setNotifyIcon',{"iconRes":resId});
  }

  static void setAppForegroundHiddenNotification (bool hidden) {
    _channel.invokeMethod('setAppForegroundHiddenNotification', {"hidden" : hidden});
  }

  static Future<bool> bindPhoneNum (String phoneNum) async {
    final bool result =await _channel.invokeMethod('bindPhoneNum', {"phoneNum" : phoneNum});
    return result;
  }

  static Future<bool> send(int type, String content, int space, String extras) async{
   return await _channel.invokeMethod("send", {"type":type, "content":content, "space":space, "extras":extras});
  }
}
