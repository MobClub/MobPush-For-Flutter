import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobpush/mobpush.dart';
import 'package:mobpush/mobpush_local_notification.dart';
import 'package:mobpush/mobpush_notify_message.dart';
import 'dart:io';

class LocalNotifyPage extends StatefulWidget {
  @override
  _LocalNotifyPageState createState() {
    return new _LocalNotifyPageState();
  }
}

class _LocalNotifyPageState extends State<LocalNotifyPage> {
  TextEditingController _controller = new TextEditingController();

  
  void _send() async {
    if (_controller.text.isNotEmpty) {
      
      if (Platform.isIOS) {
        MobPushLocalNotification localNotification = new MobPushLocalNotification(
          0,//notificationId
          "本地通知",//本地通知标题
          _controller.text,//本地通知内容
          null,//消息id
          null,//收件箱样式的内容
          0,//本地通知时间戳, 0马上通知。其余为时间间隔
          0,//通知样式
          0,//消息通道
          null,//附加数据
          false,//声音
          false,//真的
          null,//大段文本和大图模式的样式内容
          false,//呼吸灯
          1,  // ios角标
          'default', // ios声音
          '副标题');// ios副标题
        await Mobpush.addLocalNotification(localNotification);
      } else {
        MobPushLocalNotification localNotification = new MobPushLocalNotification(
          0,//notificationId
          "本地通知",//本地通知标题
          _controller.text,//本地通知内容
          null,//消息id
          null,//收件箱样式的内容
          new DateTime.now().millisecondsSinceEpoch,//本地通知时间戳
          0,//通知样式
          0,//消息通道
          null,//附加数据
          true,//声音
          true,//真的
          null,//大段文本和大图模式的样式内容
          true,//呼吸灯
          0, // ios角标
          null, // ios声音
          null);// ios副标题
        await Mobpush.addLocalNotification(localNotification);
      }
      
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
