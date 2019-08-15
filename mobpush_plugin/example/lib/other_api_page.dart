import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

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

  // 公共 API
  void _restartPush() async {
    await MobpushPlugin.restartPush();
  }

  void _stopPush() async {
    await MobpushPlugin.stopPush();
  }

  void _isPushStopped() async {
    bool isStop = await MobpushPlugin.isPushStopped();
    print('>>>>>>>>>>>>>>>>>Push stop state:$isStop');
  }

  void _setAlias() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog (
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
                    style: BorderStyle.solid
                  )
                )
              ),
              controller: _controller,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                MobpushPlugin.setAlias(_controller.text);
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void _getAlias() async {
    await MobpushPlugin.getAlias();
  }

  void _deleteAlias() async {
    await MobpushPlugin.deleteAlias();
  }

  void _addTags() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                    style: BorderStyle.solid
                  )
                )
              ),
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
                MobpushPlugin.addTags(tags);
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void _getTags() async {
    await MobpushPlugin.getTags();
  }

  void _deleteTags() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                    style: BorderStyle.solid
                  )
                )
              ),
              controller: _controller,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                List tags = new List();
                tags.add(_controller.text);
                MobpushPlugin.deleteTags(tags);
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void _cleanTags() async {
    await MobpushPlugin.cleanTags();
  }

  void _bindPhoneNum() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                    style: BorderStyle.solid
                  )
                )
              ),
              controller: _controller,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                MobpushPlugin.bindPhoneNum(_controller.text);
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }


  // 仅Andorid API
  void _setSilenceTime() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    await MobpushPlugin.setSilenceTime(20, 0, 8, 0);
  }

  void _removeLocalNotification() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    await MobpushPlugin.removeLocalNotification(0);
  }

  void _clearLocalNotifications() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    await MobpushPlugin.clearLocalNotifications();
  }

  void _setAppForegroundHiddenNotification() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    setState(() {
      hiddenNotify = !hiddenNotify;
    });
    await MobpushPlugin.setAppForegroundHiddenNotification(hiddenNotify);
  }

  void _setNotifyIcon() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    await MobpushPlugin.setNotifyIcon("ic_launcher");
  }

  void _setClickNotificationToLaunchMainActivity() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    setState(() {
      launchMain = !launchMain;
    });
    await MobpushPlugin.setClickNotificationToLaunchMainActivity(launchMain);
  }

  void _setShowBadge() async {
    if (!Platform.isAndroid) {
      _showWarningDialog(true);
      return;
    }
    await MobpushPlugin.setShowBadge(true);
  }

  // 仅 iOS API
  void _setBadge() async {
    if (!Platform.isIOS) {
      _showWarningDialog(false);
      return;
    }
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Badge"),
          content: Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "请填写Badge数字",
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
          actions: <Widget>[
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                int badge = int.parse(_controller.text);
                MobpushPlugin.setBadge(badge);
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void _clearBadge() {
    if (!Platform.isIOS) {
      _showWarningDialog(false);
      return;
    }
    MobpushPlugin.clearBadge();
  }

  // 工具方法
  void _showWarningDialog(bool isAnd) {
    String noti = isAnd ? 'Android' : 'iOS';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Warning⚠️"),
          content: Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              '仅 $noti 可用！'
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PushAPI接口'),
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(title: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _restartPush,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'stopPush',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _stopPush,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'isPushStopped',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _isPushStopped,
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setAlias', 
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _setAlias,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'getAlias',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _getAlias,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'deleteAlias',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _deleteAlias,
                  )
                ),
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
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _addTags,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'getTags',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _getTags,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'deleteTags',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _deleteTags,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'cleanTags',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _cleanTags,
                  )
                ),
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
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _bindPhoneNum,
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setSilenceTime\n(仅andorid)',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _setSilenceTime,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setShowBadge\n(仅andorid)',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _setShowBadge,
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'removeLocalNotification\n(仅andorid)',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _removeLocalNotification,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'clearLocalNotifications\n(仅andorid)',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _clearLocalNotifications,
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setAppForegroundHiddenNotification\n(仅andorid)',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _setAppForegroundHiddenNotification,
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setNotifyIcon\(仅andorid)',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _setNotifyIcon
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setClickNotificationToLaunchMainActivity\n(仅andorid)',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _setClickNotificationToLaunchMainActivity,
                  )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'setBadge\n(仅iOS)',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _setBadge,
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: Color(0xFF29C18B),
                    child: Text(
                      'clearBadge\n(仅iOS)',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _clearBadge,
                  )
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
