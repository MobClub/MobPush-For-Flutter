import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'mobpush_local_notification.dart';

typedef void EventHandler(dynamic event);

class MobpushPlugin {
  static const MethodChannel _channel = const MethodChannel('mob.com/mobpush_plugin');
  static EventChannel _channelReciever = const EventChannel('mobpush_receiver');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // 公共 API

  /*
   * 上传隐私协议许可
   */
  static Future<bool> updatePrivacyPermissionStatus(bool agree) async {
    return await _channel.invokeMethod("updatePrivacyPermissionStatus",{"status":agree});
  }

  /*
   * 获取 SDK 版本号
   */
  static Future<String> getSDKVersion() async {
    final String ver = await _channel.invokeMethod('getSDKVersion');
    return ver;
  }

  /*
   * 获取regId
   */
  static Future<Map<String, dynamic>> getRegistrationId() async {
    final Map ridMap = await _channel.invokeMethod('getRegistrationId');
    Map<String, dynamic> resMap = Map<String, dynamic>.from(ridMap);
    return resMap;
  }
  
  /*
   * 添加推送回调监听（接收自定义透传消息回调、接收通知消息回调、接收点击通知消息回调、接收别名或标签操作回调）
   */
  static addPushReceiver(EventHandler onEvent, EventHandler onError) {
      _channelReciever.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  /*
   * 移除推送回调监听
   */
  static Future<void> removePushReceiver() async {
    await _channel.invokeMethod('removePushReceiver');
  }

  /*
   * 停止推送
   */
  static Future<void> stopPush() async {
    await _channel.invokeMethod('stopPush');
  }

  /*
   * 重新打开推送服务
   */
  static Future<void> restartPush() async {
    await _channel.invokeMethod('restartPush');
  }

  /*
   * 是否已停止接收推送
   */
  static Future<bool> isPushStopped() async {
    return await _channel.invokeMethod('isPushStopped'); 
  }

  /*
   * 设置别名
   */
  static Future<Map<String, dynamic>> setAlias (String alias) async {
    final Map aliasMap = await _channel.invokeMethod('setAlias', {"alias": alias});
    Map<String, dynamic> resMap = Map<String, dynamic>.from(aliasMap);
    return resMap;
  }

  /*
   * 获取别名
   */
  static Future<Map<String, dynamic>> getAlias() async {
    final Map aliasMap = await _channel.invokeMethod('getAlias');
    Map<String, dynamic> resMap = Map<String, dynamic>.from(aliasMap);
    return resMap;
  }

  /*
   * 删除别名
   */
  static Future<Map<String, dynamic>> deleteAlias() async {
    final Map aliasMap = await _channel.invokeMethod('deleteAlias');
    Map<String, dynamic> resMap = Map<String, dynamic>.from(aliasMap);
    return resMap;
  }

  /*
   * 添加标签
   */
  static Future<Map<String, dynamic>> addTags (List<String> tags) async {
    final Map tagsMap = await _channel.invokeMethod('addTags', {"tags": tags});
    Map<String, dynamic> resMap = Map<String, dynamic>.from(tagsMap);
    return resMap;
  }

  /*
   * 获取标签
   */
  static Future<Map<String, dynamic>> getTags() async {
    final Map tagsMap = await _channel.invokeMethod('getTags');
    Map<String, dynamic> resMap = Map<String, dynamic>.from(tagsMap);
    return resMap;
  }

  /*
   * 删除标签
   */
  static Future<Map<String, dynamic>> deleteTags (List<String> tags) async {
    final Map tagsMap = await _channel.invokeMethod('deleteTags', {"tags": tags});
    Map<String, dynamic> resMap = Map<String, dynamic>.from(tagsMap);
    return resMap;
  }

  /*
   * 清空标签
   */
  static Future<Map<String, dynamic>> cleanTags() async {
    final Map tagsMap = await _channel.invokeMethod('cleanTags');
    Map<String, dynamic> resMap = Map<String, dynamic>.from(tagsMap);
    return resMap;
  }

  /*
   * 发送本地通知
   */
  static Future<void> addLocalNotification(MobPushLocalNotification localNotification) async {
    await _channel.invokeMethod('addLocalNotification', {"localNotification":json.encode(localNotification.toJson())});
  }

  /*
   * 绑定手机号
   */
  static Future<Map<String, dynamic>> bindPhoneNum (String phoneNum) async {
    final Map phoneMap = await _channel.invokeMethod('bindPhoneNum', {"phoneNum": phoneNum});
    Map<String, dynamic> resMap = Map<String, dynamic>.from(phoneMap);
    return resMap;
  }

  /*
   * 测试模拟推送，用于测试
   * type：模拟消息类型，1、通知测试；2、内推测试；3、定时
   * content：模拟发送内容，500字节以内，UTF-8
   * space：仅对定时消息有效，单位分钟，默认1分钟
   * extras: 附加数据，json字符串
   */
  static Future<Map<String, dynamic>> send(int type, String content, int space, String extras) async {
    final Map sendMap = await _channel.invokeMethod("send", {"type": type, "content": content, "space": space, "extrasMap": extras});
    Map<String, dynamic> resMap = Map<String, dynamic>.from(sendMap);
    return resMap;
  }

  // Android API
  /*
   * 设置点击通知是否跳转默认页(仅andorid)
   */
  static Future<void> setClickNotificationToLaunchMainActivity (bool enable) async {
      await _channel.invokeMethod('setClickNotificationToLaunchMainActivity', {"enable": enable});
  }

  /*
   * 移除本地通知(仅andorid)
   */
  static Future<bool> removeLocalNotification(int notificationId) async {
    final bool result = await _channel.invokeMethod('removeLocalNotification', {"notificationId": notificationId});
    return result;
  }

  /*
   * 清空本地通知(仅andorid)
   */
  static Future<bool> clearLocalNotifications() async {
    final bool result = await _channel.invokeMethod('clearLocalNotifications');
    return result;
  }

  /*
   * 设置通知栏icon，不设置默认取应用icon(仅andorid)
   */
  static Future<void> setNotifyIcon(String resId) async {
   await _channel.invokeMethod('setNotifyIcon',{"iconRes": resId});
  }

  /*
   * 设置应用在前台时是否隐藏通知不进行显示，不设置默认不隐藏通知(仅andorid)
   */
  static Future<void> setAppForegroundHiddenNotification (bool hidden) async {
    await _channel.invokeMethod('setAppForegroundHiddenNotification', {"hidden": hidden});
  }

  /*
   * 设置是否显示角标(仅andorid)
   */
  static Future<void> setShowBadge (bool show) async {
    await _channel.invokeMethod('setShowBadge', {"show": show});
  }

  /*
   * 设置通知静音时段（推送选项）(仅andorid)
   * @param startHour   开始时间[0~23] (小时)
   * @param startMinute 开始时间[0~59]（分钟）
   * @param endHour     结束时间[0~23]（小时）
   * @param endMinute   结束时间[0~59]（分钟）
   */
  static Future<void> setSilenceTime(int startHour, int startMinute, int endHour, int endMinute) async {
   await _channel.invokeMethod('setSilenceTime',
        {"startHour": startHour, "startMinute": startMinute, "endHour": endHour, "endMinute": endMinute});
  }

  // iOS API
  
  /*
   * 设置远程推送，向用户授权(仅 iOS)
   */
  static Future<void> setCustomNotification() async {
    await _channel.invokeMethod('setCustomNotification');
  }
  
  /*
   * 设置远程推送环境 (仅 iOS)
   * @param isPro  开发环境 false, 线上环境 true
   */
  static Future<void> setAPNsForProduction(bool isPro) async {
    await _channel.invokeMethod('setAPNsForProduction', {"isPro": isPro});
  }

  /*
   * 设置角标 (仅 iOS)
   * @param badge  角标数量
   */
  static Future<void> setBadge(int badge) async {
    await _channel.invokeMethod('setBadge', {"badge": badge});
  }

  /*
   * 清空角标，不清除通知栏消息记录 (仅 iOS)
   */
  static Future<void> clearBadge() async {
    await _channel.invokeMethod('clearBadge');
  }

  /*
   * 设置应用在前台有 Badge、Sound、Alert 三种类型,默认3个选项都有,iOS 10以上设置生效.(仅 iOS)
   * type: 0->None , 1->仅Badge, 2->仅Sound, 4->仅Alert, 5->Badge+Alert, 6->Sound+Alert, 7->Badge+Sound+Alert
  */
  static Future<void> setAPNsShowForegroundType(int type) async {
    await _channel.invokeMethod('setAPNsShowForegroundType', {'type': type});
  }

  /*
  * 设置地区：regionId 默认0（国内），1:海外  (仅 iOS)
  * */
  static Future<void> setRegionId(int regionId) async {
    await _channel.invokeMethod('setRegionId', {'regionId': regionId});
  }

  /*
  * 注册appkey和appsecret, (仅 iOS)
  * */
  static Future<void> registerApp(String appKey, String appSecret) async {
    await _channel.invokeMethod('registerApp', {'appKey': appKey, 'appSecret': appSecret});
  }
}
