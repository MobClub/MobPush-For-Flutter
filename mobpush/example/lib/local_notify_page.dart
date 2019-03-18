import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobpush/mobpush.dart';
import 'package:mobpush/mobpush_local_notification.dart';
import 'package:mobpush/mobpush_notify_message.dart';

class LocalNotifyPage extends StatefulWidget {
  @override
  _LocalNotifyPageState createState() {
    return new _LocalNotifyPageState();
  }
}

class _LocalNotifyPageState extends State<LocalNotifyPage> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  void _send() async {
    if (_controller.text.isNotEmpty) {
      MobPushLocalNotification localNotification = new MobPushLocalNotification(
          0,
          "本地通知",
          "测试本地通知内容",
          null,
          null,
          new DateTime.now().millisecondsSinceEpoch,
          0,
          0,
          null,
          true,
          true,
          null,
          true);
      await Mobpush.addLocalNotification(localNotification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('本地通知提醒测试'),
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(title: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "点击测试按钮后，在你设定的时间到了时将收到一条本地通知提醒",
                textAlign: TextAlign.left,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 30),
                child: TextField(
                  maxLines: 5,
                  maxLength: 35,
                  decoration: InputDecoration(
                      hintText: "填写推送内容（不超过35个字）",
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Color(0xFFe1e1e1),
                              width: 0.5,
                              style: BorderStyle.solid))),
                  controller: _controller,
                ),
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                      child: new RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFFFF7D00),
                    child: Text(
                      '点击测试',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: _send,
                  )),
                ],
              ),
            ],
          ),
        ));
  }
}
