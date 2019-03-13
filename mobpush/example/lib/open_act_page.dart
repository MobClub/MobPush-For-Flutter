import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobpush/mobpush.dart';
import 'package:mobpush/mobpush_notify_message.dart';

class OpenActPage extends StatefulWidget {
  @override
  _OpenActPageState createState() {
    return new _OpenActPageState();
  }
}

class _OpenActPageState extends State<OpenActPage> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Mobpush.addPushReceiver(_onEvent, _onError);
  }

  void _onEvent(Object event) {
    setState(() {
      MobPushNotifyMessage message =
      new MobPushNotifyMessage.fromJson(json.decode(event));

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
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>setStateONEvent:' + event.toString());
    });
  }

  void _onError(Object event) {
    setState(() {
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>setStateonError:' + event.toString());
    });
  }

  void _send() async {
    if (_controller.text.isNotEmpty) {
      await Mobpush.send(3, _controller.text, 2, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('打开应用内指定页面测试'),
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
                "点击测试按钮后，你将收到一条推送消息，点击后可跳转至指定的应用内界面",
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
                        color: Color(0xFF29C18B),
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
