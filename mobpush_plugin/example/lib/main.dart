import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:mobpush_plugin/mobpush_custom_message.dart';
import 'package:mobpush_plugin/mobpush_notify_message.dart';
import 'app_notify_page.dart';
import 'click_container.dart';
import 'local_notify_page.dart';
import 'notify_page.dart';
import 'other_api_page.dart';
import 'timing_notify_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  String _sdkVersion = 'Unknown';
  String _registrationId = 'Unknown';

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      //设置地区：regionId 默认0（国内），1:海外
      MobpushPlugin.setRegionId(1);
      MobpushPlugin.registerApp("3276d3e413040", "4280a3a6df667cfce37528dec03fd9c3");
    }

    initPlatformState();

    if (Platform.isIOS) {
      MobpushPlugin.setCustomNotification();
      MobpushPlugin.setAPNsForProduction(true);
    }
    MobpushPlugin.addPushReceiver(_onEvent, _onError);

    //上传隐私协议许可
    MobpushPlugin.updatePrivacyPermissionStatus(true).then((value) {
      print(">>>>>>>>>>>>>>>>>>>updatePrivacyPermissionStatus:" +
          value.toString());
    });
  }

  void _onEvent(dynamic event) {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onEvent:' + event.toString());
    setState(() {
      Map<String, dynamic> eventMap = json.decode(event as String);
      Map<String, dynamic> result = eventMap['result'];
      int action = eventMap['action'];

      switch (action) {
        case 0:
          MobPushCustomMessage message =
              new MobPushCustomMessage.fromJson(result);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(message.content),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("确定")
                    )
                  ],
                );
          });
          break;
        case 1:
          MobPushNotifyMessage message =
              new MobPushNotifyMessage.fromJson(result);
          break;
        case 2:
          MobPushNotifyMessage message =
              new MobPushNotifyMessage.fromJson(result);
          break;
      }
    });
  }

  void _onError(dynamic event) {
    setState(() {
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onError:' + event.toString());
    });
  }

  void _onAppNotifyPageTap() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new AppNotifyPage()));
    });
  }

  void _onNotifyPageTap() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new NotifyPage()));
    });
  }

  void _onTimingNotifyPageTap() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new TimingNotifyPage()));
    });
  }

  void _onLocalNotifyPageTap() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new LocalNotifyPage()));
    });
  }

  void _onOtherAPITap() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new OtherApiPage()));
    });
  }

  Future<void> initPlatformState() async {
    String sdkVersion;
    try {
      sdkVersion = await MobpushPlugin.getSDKVersion();
    } on PlatformException {
      sdkVersion = 'Failed to get platform version.';
    }
    try {
      MobpushPlugin.getRegistrationId().then((Map<String, dynamic> ridMap) {
        print(ridMap);
        setState(() {
          _registrationId = ridMap['res'].toString();
          print('------>#### registrationId: ' + _registrationId);
        });
      });
    } on PlatformException {
      _registrationId = 'Failed to get registrationId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  // 复制到剪切板
  void _onCopyButtonClicked() {
    // 写入剪切板
    Clipboard.setData(ClipboardData(text: _registrationId));
    // 验证是否写入成功
    Clipboard.getData(Clipboard.kTextPlain).then((data) {
      if (data != null) {
        String? text = data.text;
        print('------>#### copyed registrationId: $text');
        if (text == _registrationId) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("恭喜🎉"),
                  content: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 30),
                    child: Text('复制成功！'),
                  ),
                  actions: <Widget>[
                    new TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("OK"))
                  ],
                );
              }
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MobPushPlugin Demo'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ClickContainer(
                      content: 'App内推送',
                      res: 'assets/images/ic_item_app_nitify.png',
                      left: 15.0,
                      top: 15.0,
                      right: 7.5,
                      bottom: 7.5,
                      onTap: _onAppNotifyPageTap,
                    ),
                  ),
                  Expanded(
                    child: ClickContainer(
                      content: '通知',
                      res: 'assets/images/ic_item_notify.png',
                      left: 7.5,
                      top: 15.0,
                      right: 15.0,
                      bottom: 7.5,
                      onTap: _onNotifyPageTap,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ClickContainer(
                      content: '定时推送',
                      res: 'assets/images/ic_item_timing.png',
                      left: 15.0,
                      top: 7.5,
                      right: 7.5,
                      bottom: 7.5,
                      onTap: _onTimingNotifyPageTap,
                    ),
                  ),
                  Expanded(
                    child: ClickContainer(
                      content: '本地通知',
                      res: 'assets/images/ic_item_local.png',
                      left: 7.5,
                      top: 7.5,
                      right: 15.0,
                      bottom: 7.5,
                      onTap: _onLocalNotifyPageTap,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ClickContainer(
                      content: '其他API接口',
                      res: 'assets/images/ic_item_media.png',
                      left: 15.0,
                      top: 7.5,
                      right: 15.0,
                      bottom: 7.5,
                      onTap: _onOtherAPITap,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'SDK Version: $_sdkVersion\nRegistrationId: $_registrationId',
                    style: TextStyle(fontSize: 12),
                  ),
                  ElevatedButton(
                    child: Text('复制'),
                    onPressed: _onCopyButtonClicked,
                  )
                  // RaisedButton(
                  //   child: Text('复制'),
                  //   onPressed: _onCopyButtonClicked,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
