# MobpushPlugin_example

Demonstrates how to use the MobpushPlugin plugin.

## Getting Started

**接口方法说明**

（1）设置远程推送环境，向用户授权（仅 iOS）：

setCustomNotification

```
if (Platform.isIOS) {
      MobpushPlugin.setCustomNotification();
}
```

（2）设置远程推送环境  (仅 iOS)：

setAPNsForProduction

```
if (Platform.isIOS) {
     // 开发环境 false, 线上环境 true
      MobpushPlugin.setAPNsForProduction(false)
}
```
（3）添加推送回调监听（接收自定义透传消息回调、接收通知消息回调、接收点击通知消息回调、接收别名或标签操作回调）

addPushReceiver

```
MobpushPlugin.addPushReceiver(_onEvent, _onError);

void _onEvent(Object event) {

}

void _onError(Object event) {
    
}
```

（4）停止推送

stopPush

```
MobpushPlugin.stopPush();
```

（5）重新打开推送服务

restartPush

```
MobpushPlugin.restartPush();
```
（6）是否已停止接收推送

isPushStopped

```
MobpushPlugin.isPushStopped();
```

（7）设置别名

setAlias

```
MobpushPlugin.setAlias("别名");
```

（8）获取别名

getAlias

```
MobpushPlugin.getAlias();
```

(9）删除别名

deleteAlias

```
MobpushPlugin.deleteAlias("别名");
```

（10）添加标签

addTags

```
List tags = new List();
tags.add("tag1");
tags.add("tag2");
MobpushPlugin.addTags(tags);
```

（11）获取标签

getTags

```
MobpushPlugin.getTags();
```

（12）删除标签

deleteTags

```
List tags = new List();
tags.add("tag1");
tags.add("tag2");
MobpushPlugin.deleteTags(tags);
```

（13）清空标签

cleanTags

```
MobpushPlugin.cleanTags();
```

（14）发送本地通知

addLocalNotification

```
MobpushPlugin.addLocalNotification();
```

（15）绑定手机号

bindPhoneNum

```
MobpushPlugin.bindPhoneNum("110");
```

（16）测试模拟推送，用于测试

send

```
/**
    * 测试模拟推送，用于测试
    * type：模拟消息类型，1、通知测试；2、内推测试；3、定时
    * content：模拟发送内容，500字节以内，UTF-8
    * space：仅对定时消息有效，单位分钟，默认1分钟
    * extras: 附加数据，json字符串
    */
MobpushPlugin.send(int type, String content, int space, String extras);
```

（17）设置点击通知是否跳转默认页 (仅andorid)

setClickNotificationToLaunchMainActivity

```
MobpushPlugin.setClickNotificationToLaunchMainActivity (bool enable);
```

（18）移除本地通知(仅andorid)

removeLocalNotification

```
MobpushPlugin.removeLocalNotification(int notificationId);
```

（19）清空本地通知(仅andorid)

clearLocalNotifications

```
MobpushPlugin.clearLocalNotifications();
```

（20）设置通知栏icon，不设置默认取应用icon(仅andorid)

setNotifyIcon

```
MobpushPlugin.setNotifyIcon(String resId);
```

（21）设置应用在前台时是否隐藏通知不进行显示，不设置默认不隐藏通知(仅andorid)

setAppForegroundHiddenNotification

```
MobpushPlugin.setAppForegroundHiddenNotification(bool hidden);
```

（22）设置通知静音时段（推送选项）(仅andorid)

setSilenceTime

```
/**
   * 设置通知静音时段（推送选项）(仅andorid)
   * @param startHour   开始时间[0~23] (小时)
   * @param startMinute 开始时间[0~59]（分钟）
   * @param endHour     结束时间[0~23]（小时）
   * @param endMinute   结束时间[0~59]（分钟）
   */
MobpushPlugin.setSilenceTime(int startHour, int startMinute, int endHour, int endMinute)
```

（23）设置角标 (仅 iOS)

setBadge


```
MobpushPlugin.setBadge(int badge);
```

（24）清空角标，不清除通知栏消息记录 (仅 iOS)

clearBadge

```
MobpushPlugin.clearBadge();
```

（25）设置应用在前台展示有 Badge、Sound、Alert 三种类型,默认3个选项都有,iOS 10以上设置生效. (仅 iOS)

> type: 0->None , 1->仅Badge, 2->仅Sound, 4->仅Alert, 5->Badge+Alert, 6->Sound+Alert, 7->Badge+Sound+Alert

setAPNsShowForegroundType

```
MobpushPlugin.setAPNsShowForegroundType(int type);
```

