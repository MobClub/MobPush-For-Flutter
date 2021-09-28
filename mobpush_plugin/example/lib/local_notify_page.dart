import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:mobpush_plugin/mobpush_local_notification.dart';

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
      if (Platform.isIOS) {    // iOS
        MobPushLocalNotification localNotification = new MobPushLocalNotification(
          title: "正标题",//本地通知标题
          content: _controller.text, //本地通知内容
          timestamp: 0, //本地通知时间戳, 0立刻通知。其余为时间间隔
          badge: 1, //  ios角标
          sound: "default", // ios声音
          subTitle: "副标题",
          extrasMap: {"extra":"testExtra"} // ios副标题
          );// ios副标题
        await MobpushPlugin.addLocalNotification(localNotification);
      } else { // Android
        MobPushLocalNotification localNotification = new MobPushLocalNotification(
          notificationId: 0,//notificationId
          title: "本地通知",//本地通知标题
          content: _controller.text,//本地通知内容
          messageId: null,//消息id
          inboxStyleContent: null,//收件箱样式的内容
          timestamp: new DateTime.now().millisecondsSinceEpoch,//本地通知时间戳
          style: 0,//通知样式
          channel: 0,//消息通道
          extrasMap: null,//附加数据
          voice: true,//声音
          shake: true,//真的
          styleContent: null,//大段文本和大图模式的样式内容
          light: true,//呼吸灯
          );
        await MobpushPlugin.addLocalNotification(localNotification);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('本地通知提醒测试'),
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
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
                      style: BorderStyle.solid
                    )
                  )
                ),
                controller: _controller,
              ),
            ),
            Row(
              children: <Widget>[
                new Expanded(
                  child: new ElevatedButton(
                    child: Text(
                      '点击测试',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: _send,
                  ),
                  // child: new RaisedButton(
                  //   padding: EdgeInsets.symmetric(vertical: 12),
                  //   color: Color(0xFFFF7D00),
                  //   child: Text(
                  //     '点击测试',
                  //     style: new TextStyle(color: Colors.white),
                  //   ),
                  //   onPressed: _send,
                  // )
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
