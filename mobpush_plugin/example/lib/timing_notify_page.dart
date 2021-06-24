import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

class TimingNotifyPage extends StatefulWidget {
  @override
  _TimingNotifyPageState createState() {
    return new _TimingNotifyPageState();
  }
}

class _TimingNotifyPageState extends State<TimingNotifyPage> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // MobpushPlugin.addPushReceiver(_onEvent, _onError);
  }

  // void _onEvent(Object event) {
  //   setState(() {
  //     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>setStateONEvent:' + event.toString());
  //   });
  // }

  // void _onError(Object event) {
  //   setState(() {
  //     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>setStateonError:' + event.toString());
  //   });
  // }

  void _send() async {
    if (_controller.text.isNotEmpty) {
      //发送消息类型为3的自延迟推送通知消息，推送内容时输入框输入的内容，延迟推送时间为1分钟（1分钟后推送），附加数据为空
      MobpushPlugin.send(3, _controller.text, 1, "").then((Map<String, dynamic> sendMap){
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
        title: Text('定时通知测试'),
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
              "点击测试按钮后，在你设定的时间到了时将收到一条测试通知",
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
                  //   color: Color(0xFF29C18B),
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
