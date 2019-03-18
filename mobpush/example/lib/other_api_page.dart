import 'package:flutter/material.dart';
import 'package:mobpush/mobpush.dart';

class OtherApiPage extends StatefulWidget {
  @override
  _OtherApiPageState createState() {
    return new _OtherApiPageState();
  }
}

class _OtherApiPageState extends State<OtherApiPage> {
  TextEditingController _controller = new TextEditingController();
  bool hiddenNotify = false;
  bool launchMain = true;

  void _restartPush() async {
    await Mobpush.restartPush();
  }

  void _stopPush() async {
    await Mobpush.stopPush();
  }

  void _isPushStopped() async {
    bool isStop = await Mobpush.isPushStopped();
    print('>>>>>>>>>>>>>>>>>Push stop state:$isStop');
  }

  void _setAlias() async {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("别名"),
          content: Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: "请填写别名",
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
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Mobpush.setAlias(_controller.text);
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void _getAlias() async {
    await Mobpush.getAlias();
  }

  void _deleteAlias() async {
    await Mobpush.deleteAlias();
  }

  void _addTags() async {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("标签"),
          content: Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: "请填写标签",
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
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                List tags = new List();
                tags.add(_controller.text);
                tags.add(_controller.text + "1");
                Mobpush.addTags(tags);
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void _getTags() async {
    await Mobpush.getTags();
  }

  void _deleteTags() async {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("标签"),
          content: Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: "请填写删除的标签",
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
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                List tags = new List();
                tags.add(_controller.text);
                Mobpush.deleteTags(tags);
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void _cleanTags() async {
    await Mobpush.cleanTags();
  }

  void _setSilenceTime() async {
    await Mobpush.setSilenceTime(20, 0, 8, 0);
  }

  void _removeLocalNotification() async {
    await Mobpush.removeLocalNotification(0);
  }

  void _clearLocalNotifications() async {
    await Mobpush.clearLocalNotifications();
  }

  void _setAppForegroundHiddenNotification() async {
    setState(() {
      hiddenNotify = !hiddenNotify;
    });
    await Mobpush.setAppForegroundHiddenNotification(hiddenNotify);
  }

  void _bindPhoneNum() async {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("绑定手机号"),
          content: Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: "请填写绑定的手机号",
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
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Mobpush.bindPhoneNum(_controller.text);
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void _setNotifyIcon() async {
    await Mobpush.setNotifyIcon("ic_launcher");
  }

  void _setClickNotificationToLaunchMainActivity() async {
    setState(() {
      launchMain = !launchMain;
    });
    await Mobpush.setClickNotificationToLaunchMainActivity(launchMain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PushAPI接口'),
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
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'restartPush',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _restartPush,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'stopPush',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _stopPush,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'isPushStopped',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _isPushStopped,
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child:
                        Text('setAlias', style: TextStyle(color: Colors.white)),
                    onPressed: _setAlias,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'getAlias',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _getAlias,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'deleteAlias',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _deleteAlias,
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'addTags',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _addTags,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'getTags',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _getTags,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'deleteTags',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _deleteTags,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'cleanTags',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _cleanTags,
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setSilenceTime',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _setSilenceTime,
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'removeLocalNotification',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _removeLocalNotification,
                  )),
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'clearLocalNotifications',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _clearLocalNotifications,
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setAppForegroundHiddenNotification',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _setAppForegroundHiddenNotification,
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'bindPhoneNum',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _bindPhoneNum,
                  )),
                  Expanded(
                      child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          color: Color(0xFF29C18B),
                          child: Text(
                            'setNotifyIcon',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _setNotifyIcon)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setClickNotificationToLaunchMainActivity',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _setClickNotificationToLaunchMainActivity,
                  )),
                ],
              ),
            ],
          ),
        ));
  }
}
