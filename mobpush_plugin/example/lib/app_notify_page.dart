import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

class AppNotifyPage extends StatefulWidget {
  @override
  _AppNotifyPageState createState() {
    return new _AppNotifyPageState();
  }
}

class _AppNotifyPageState extends State<AppNotifyPage> {
  TextEditingController _controller = new TextEditingController();

  void _send() async {
    if (_controller.text.isNotEmpty) {
      //发送消息类型为2的自定义透传消息，推送内容时输入框输入的内容，延迟推送时间为0（立即推送），附加数据为空
      MobpushPlugin.send(2, _controller.text, 0, '').then((Map<String, dynamic> sendMap){
        String res = sendMap['res'];
        String error = sendMap['error'];
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>> send -> res: $res error: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App内推送测试'),
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
              '点击测试按钮后，你将立即收到一条App内推送',
              textAlign: TextAlign.left,
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 30),
              child: TextField(
                maxLines: 5,
                maxLength: 35,
                decoration: InputDecoration(
                  hintText: '推送内容（不超过35个字）',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFe1e1e1),
                      width: 0.5,
                      style: BorderStyle.solid,
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
                  //   color: Color(0xFF7B91FF),
                  //   child: Text(
                  //     '点击测试',
                  //     style: new TextStyle(color: Colors.white),
                  //   ),
                  //   onPressed: _send,
                  // ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  
}