# MobPush For Flutter

这是一个基于  MobPush 功能的扩展的 Flutter 插件。使用此插件能够帮助您在使用 Flutter 开发应用时，快速地实现推送功能。

插件主页：https://pub.dartlang.org/packages/mobpush

Demo 例子：https://github.com/MobClub/MobPush-for-Flutter

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
}
```
在 /android/app/build.gradle 中添加以下代码：

```
apply plugin: 'com.android.application'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
// 导入MobSDK
apply plugin: 'com.mob.sdk'
```
3.  平台相关集成 在项目的/android/app/build.gradle中添加:


```
android {
    // lines skipped
    dependencies {
        provided rootProject.findProject(":mobsms")
    }
}
```
这样就可以在你的project/android/src下的类中import cn.smssdk.flutter.MobsmsPlugin并使用MobsmsPlugin中的api了。

添加代码

在MainActivity的onCreate中添加以下代码：

```
 @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    // 注册SMSSDK Flutter插件
    MobsmsPlugin.registerWith(registrarFor(MobsmsPlugin.CHANNEL));
    // 初始化SMSSDK
    MobSDK.init(this, MOB_APPKEY, MOB_APPSECRET);
  }
```
在MainActivity的onDestory中添加以下代码：

```
@Override
	protected void onDestroy() {
		super.onDestroy();
		// 执行回收操作
		MobsmsPlugin.recycle();
	}
```



