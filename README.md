# MobPush For Flutter

这是一个基于  MobPush 功能的扩展的 Flutter 插件。使用此插件能够帮助您在使用 Flutter 开发应用时，快速地实现推送功能。

插件主页：https://pub.dartlang.org/packages/mobpush

Demo例子：https://github.com/MobClub/MobPush-for-Flutter

开始集成

1.参考 Flutter 官方插件集成文档

在pubspec.yaml文件中加入下面依赖

```
dependencies:
  mobpush:
```
然后执行：flutter packages get 导入package
在你的dart工程文件中，导入下面头文件，开始使用

```
import 'package:mobpush/mobpush.dart';
```

**iOS：**

平台配置参考[ iOS 集成文档](http://wiki.mob.com/mobpush-for-ios/)

实现 1. ：获取 appKey 和 appSecret
实现 5.1：配置 appkey 和 appSecret

**Android：**

导入 MobPush 相关依赖

在项目根目录的build.gradle中添加以下代码：

```
dependencies {
    classpath 'com.android.tools.build:gradle:3.2.1'
    classpath 'com.mob.sdk:MobSDK:+'
    classpath 'com.google.gms:google-services:4.0.1' //不需要FCM厂商推送无需配置
}
```
在 /android/app/build.gradle 中添加以下代码：

```
apply plugin: 'com.android.application'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
// 导入MobSDK
apply plugin: 'com.mob.sdk'

MobSDK {
    appKey "您的Mob平台appKey"
    appSecret "您的Mob平台appSecret"

	//配置MobPush
    MobPush {
    	//配置厂商推送（可选配置，不需要厂商推送可不配置，需要哪些厂商推送只需配置哪些厂商配置即可）
        devInfo {
        	//配置小米厂商推送
            XIAOMI {
                appId "您的小米平台appId"
                appKey "您的小米平台appKey"
            }

			//配置华为厂商推送
            HUAWEI {
                appId "您的华为平台appId"
            }

			//配置魅族厂商推送
            MEIZU {
                appId "您的魅族平台appId"
                appKey "您的魅族平台appKey"
            }

			//配置FCM厂商推送
            FCM {
                //设置默认推送通知显示图标
                iconRes "@mipmap/default_ic_launcher"
            }

            //配置OPPO厂商推送
            OPPO {
                appKey "您的OPPO平台appKey"
                appSecret "您的OPPO平台appSecret"
            }

            //配置VIVO厂商推送
            VIVO {
                appId "您的VIVO平台appId"
                appKey "您的VIVO平台appKey"
            }
        }
    }
}
```
3.  平台相关集成 在项目的/android/app中自定义Application继承自FlutterApplication并进行MobSDK初始化:


```
import com.mob.MobSDK;
import io.flutter.app.FlutterApplication;

public class CustomApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        //初始化MobSDK
        MobSDK.init(this);
    }
}
```
在项目的/android/app的AndroidManifest.xml文件中添加：

```
<application
        android:name=".CustomApplication"
        ... 
        >
        ...
</application>
```
 
**接口方法说明**

（1）设置远程推送环境，向用户授权（仅 iOS）：

setCustomNotification

```
if (Platform.isIOS) {
      Mobpush.setCustomNotification();
}
```

（2）设置远程推送环境  (仅 iOS)：

setAPNsForProduction

```
if (Platform.isIOS) {
     // 开发环境 false, 线上环境 true
      Mobpush.setAPNsForProduction(false)
}
```
（3）添加推送回调监听（接收自定义透传消息回调、接收通知消息回调、接收点击通知消息回调、接收别名或标签操作回调）

addPushReceiver

```
Mobpush.addPushReceiver(_onEvent, _onError);

void _onEvent(Object event) {

}

void _onError(Object event) {
    
}
```

（4）停止推送

stopPush

```
Mobpush.stopPush();
```

（5）重新打开推送服务

restartPush

```
Mobpush.restartPush();
```
（6）是否已停止接收推送

isPushStopped

```
Mobpush.isPushStopped();
```

（7）设置别名

setAlias

```
Mobpush.setAlias("别名");
```

（8）获取别名

getAlias

```
Mobpush.getAlias();
```

(9）删除别名

deleteAlias

```
Mobpush.deleteAlias("别名");
```

（10）添加标签

addTags

```
List tags = new List();
tags.add("tag1");
tags.add("tag2");
Mobpush.addTags(tags);
```

（11）获取标签

getTags

```
Mobpush.getTags();
```

（12）删除标签

deleteTags

```
List tags = new List();
tags.add("tag1");
tags.add("tag2");
Mobpush.deleteTags(tags);
```

（13）清空标签

cleanTags

```
Mobpush.cleanTags();
```

（14）发送本地通知

addLocalNotification

```
Mobpush.addLocalNotification();
```

（15）绑定手机号

bindPhoneNum

```
Mobpush.bindPhoneNum("110");
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
Mobpush.send(int type, String content, int space, String extras);
```

（17）设置点击通知是否跳转默认页 (仅andorid)

setClickNotificationToLaunchMainActivity

```
Mobpush.setClickNotificationToLaunchMainActivity (bool enable);
```

（18）移除本地通知(仅andorid)

removeLocalNotification

```
Mobpush.removeLocalNotification(int notificationId);
```

（19）清空本地通知(仅andorid)

clearLocalNotifications

```
Mobpush.clearLocalNotifications();
```

（20）设置通知栏icon，不设置默认取应用icon(仅andorid)

setNotifyIcon

```
Mobpush.setNotifyIcon(String resId);
```

（21）设置应用在前台时是否隐藏通知不进行显示，不设置默认不隐藏通知(仅andorid)

setAppForegroundHiddenNotification

```
Mobpush.setAppForegroundHiddenNotification(bool hidden);
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
Mobpush.setSilenceTime(int startHour, int startMinute, int endHour, int endMinute)
```

（23）设置角标 (仅 iOS)

setBadge


```
Mobpush.setBadge(int badge);
```

（25）清空角标，不清除通知栏消息记录 (仅 iOS)

clearBadge

```
Mobpush.clearBadge();
```


（26）获取注册Id

getRegistrationId

```
String regId = await Mobpush.getRegistrationId();
```


