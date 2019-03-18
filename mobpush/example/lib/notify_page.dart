import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobpush/mobpush.dart';
import 'package:mobpush/mobpush_notify_message.dart';

class NotifyPage extends StatefulWidget {
  @override
  _NotifyPageState createState() {
    return new _NotifyPageState();
  }
}

class _NotifyPageState extends State<NotifyPage> {
  TextEditingController _controller = new TextEditingController();

  void _send() async {
    if (_controller.text.isNotEmpty) {
      await Mobpush.send(1, _controller.text, 0, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('通知测试'),
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
                "点击测试按钮后，你将收到一条测试通知",
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
