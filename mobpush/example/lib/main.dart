import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mobpush/mobpush.dart';
import 'package:mobpush_example/app_notify_page.dart';
import 'package:mobpush_example/local_notify_page.dart';
import 'package:mobpush_example/notify_page.dart';
import 'package:mobpush_example/open_act_page.dart';
import 'package:mobpush_example/open_url_page.dart';
import 'package:mobpush_example/other_api_page.dart';
import 'package:mobpush_example/timing_notify_page.dart';
import 'package:mobpush_example/click_container.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget{
  @override
  _MainAppState createState() {
    // TODO: implement createState
    return _MainAppState();
  }

}

class _MainAppState extends State<MainApp> {
//  String _platformVersion = 'Unknown';
//  String _registrationId = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String registrationId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Mobpush.getPlatformVersion();
      registrationId = await Mobpush.getRegistrationId();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
//      _platformVersion = platformVersion;
//      _registrationId = registrationId;
    });
  }

  void _onAppNotifyPageTap(){
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new AppNotifyPage()),
      );
    });
  }

  void _onNotifyPageTap(){
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new NotifyPage()),
      );
    });
  }

  void _onTimingNotifyPageTap(){
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new TimingNotifyPage()),
      );
    });
  }

  void _onLocalNotifyPageTap(){
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new LocalNotifyPage()),
      );
    });
  }

  void _onOpenUrlPageTap(){
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new OpenUrlPage()),
      );
    });
  }

  void _onOpenActPageTap(){
    setState(() {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new OpenActPage()),
      );
    });
  }

  void _onOtherAPITap(){
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
                            onTap: _onAppNotifyPageTap
                            )
                    ),
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
                          content: "推送打开指定链接页面",
                          res: "assets/images/ic_item_media.png",
                          left: 15.0,
                          top: 7.5,
                          right: 7.5,
                          bottom: 15.0,
                          onTap: _onOpenUrlPageTap)),
                  Expanded(
                      child: clickcontainer(
                          content: "推送打开应用内指定页面",
                          res: "assets/images/ic_item_open_act.png",
                          left: 7.5,
                          top: 7.5,
                          right: 15.0,
                          bottom: 15.0,
                          onTap: _onOpenActPageTap))
                ],
              )),
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
