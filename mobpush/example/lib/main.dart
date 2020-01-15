import 'package:flutter/material.dart';
import './app_notify_page.dart';
import './local_notify_page.dart';
import './notify_page.dart';
import './other_api_page.dart';
import './timing_notify_page.dart';
import './click_container.dart';
import 'package:mobpush/mobpush.dart';
import 'package:mobpush/mobpush_notify_message.dart';
import 'package:mobpush/mobpush_custom_message.dart';
import 'dart:convert';
import 'dart:io';

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
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      Mobpush.setCustomNotification();
      Mobpush.setAPNsForProduction(false);
    }
    Mobpush.addPushReceiver(_onEvent, _onError);
  }

  void _onEvent(Object event) {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onEvent:' + event.toString());
    setState(() {
      Map<String, dynamic> eventMap = json.decode(event);
      String result = eventMap['result'];
      int action = eventMap['action'];

      switch (action) {
        case 0:
          MobPushCustomMessage message =
              new MobPushCustomMessage.fromJson(json.decode(result));
          showDialog(
              context: context,
              child: AlertDialog(
                content: Text(message.content),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("确定"),
                  )
                ],
              ));
          break;
        case 1:
          MobPushNotifyMessage message =
              new MobPushNotifyMessage.fromJson(json.decode(result));
          break;
        case 2:
          MobPushNotifyMessage message =
              new MobPushNotifyMessage.fromJson(json.decode(result));
          break;
        case 3:
          List tags = eventMap['tags'];
          int operation = eventMap['operation'];
          int errorCode = eventMap['errorCode'];
          print("tag:>>>>>$tags");
          print("tags callback: ${operation == 0? "获取":operation==1?"设置":"删除"}别名${errorCode==0?"成功":"失败"}");
          break;
        case 4:
          String alias = eventMap['alias'];
          int operation = eventMap['operation'];
          int errorCode = eventMap['errorCode'];
          print("alias:>>>>>$alias");
          print("alias callback: ${operation == 0? "获取":operation==1?"设置":"删除"}别名${errorCode==0?"成功":"失败"}");
          break;
      }
    });
  }

  void _onError(Object event) {
    setState(() {
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onError:' + event.toString());
    });
  }

  void _onAppNotifyPageTap() {
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new AppNotifyPage()),
      );
    });
  }

  void _onNotifyPageTap() {
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new NotifyPage()),
      );
    });
  }

  void _onTimingNotifyPageTap() {
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new TimingNotifyPage()),
      );
    });
  }

  void _onLocalNotifyPageTap() {
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new LocalNotifyPage()),
      );
    });
  }

  void _onOtherAPITap() {
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new OtherApiPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: clickcontainer(
                            content: "App内推送",
                            res: "assets/images/ic_item_app_nitify.png",
                            left: 15.0,
                            top: 15.0,
                            right: 7.5,
                            bottom: 7.5,
                            onTap: _onAppNotifyPageTap)),
                    Expanded(
                        child: clickcontainer(
                            content: "通知",
                            res: "assets/images/ic_item_notify.png",
                            left: 7.5,
                            top: 15.0,
                            right: 15.0,
                            bottom: 7.5,
                            onTap: _onNotifyPageTap)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: clickcontainer(
                            content: "定时推送",
                            res: "assets/images/ic_item_timing.png",
                            left: 15.0,
                            top: 7.5,
                            right: 7.5,
                            bottom: 15.0,
                            onTap: _onTimingNotifyPageTap)),
                    Expanded(
                        child: clickcontainer(
                            content: "本地通知",
                            res: "assets/images/ic_item_local.png",
                            left: 7.5,
                            top: 7.5,
                            right: 15.0,
                            bottom: 7.5,
                            onTap: _onLocalNotifyPageTap)),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Expanded(
                      child: clickcontainer(
                          content: "其他API接口",
                          res: "assets/images/ic_item_media.png",
                          left: 15.0,
                          top: 7.5,
                          right: 7.5,
                          bottom: 15.0,
                          onTap: _onOtherAPITap))
                ],
              )),
            ],
          )),
    );
  }
}
