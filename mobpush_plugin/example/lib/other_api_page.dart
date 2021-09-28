import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

class OtherApiPage extends StatefulWidget {
  @override
  _OtherApiPageState createState() {
    return new _OtherApiPageState();
  }
}

class _OtherApiPageState extends State<OtherApiPage> {
  static List<String> otherPublicAPIs = ['stopPush', 'restartPush', 'isPushStoped', 'setAlias', 'getAlias', 'deleteAlias', 'addTags', 'getTags', 'deleteTags', 'cleanTags', 'bindPhoneNum'];
  static List<String> otherAndOnlyAPIs = ['setSilenceTime', 'removeLocalNotification', 'clearLocalNotifications', 'setAppForegroundHiddenNotification', 'setNotifyIcon', 'setClickNotificationToLaunchMainActivity', 'setShowBadge'].map((f)=>f+'\n(仅安卓可用)').toList();
  static List<String> otheriOSOnlyAPIs = ['setBadge', 'clearBadge', 'setAPNsShowForegroundType'].map((f)=>f+'\n(仅iOS可用)').toList();
  List<String> otherAllAPIs = otherPublicAPIs + otherAndOnlyAPIs + otheriOSOnlyAPIs;

  TextEditingController _controller = new TextEditingController();
  bool hiddenNotify = false;
  bool launchMain = true;

  // 公共 API
  void _setAlias() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog (
          title: Text("Alias"),
          content: Container(
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Please input alias...",
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
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Cancel')
            ),
            // new FlatButton(
            //   child: new Text('Cancel'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            new TextButton(
                onPressed: () {
                  MobpushPlugin.setAlias(_controller.text).then((Map<String, dynamic> aliasMap){
                    String res = aliasMap['res'];
                    String error = aliasMap['error'];
                    // String errorCode = aliasMap['errorCode'];
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> setAlias -> res: $res error: $error");
                  });
                  Navigator.pop(context);
                },
                child: new Text('OK')
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     MobpushPlugin.setAlias(_controller.text).then((Map<String, dynamic> aliasMap){
            //       String res = aliasMap['res'];
            //       String error = aliasMap['error'];
            //       String errorCode = aliasMap['errorCode'];
            //       print(">>>>>>>>>>>>>>>>>>>>>>>>>>> getAlias -> res: $res error: $error");
            //     });
            //     Navigator.pop(context);
            //   },
            // )
          ],
        );
      }
    );
  }

  void _addTags() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Tag"),
          content: Container(
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Please input tags(split by ',')...",
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
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Cancel')
            ),
            // new FlatButton(
            //   child: new Text('Cancel'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            new TextButton(
                onPressed: () {
                  List<String> tags = _controller.text.split(',');
                  MobpushPlugin.addTags(tags).then((Map<String, dynamic> tagsMap){
                    String res = tagsMap['res'];
                    String error = tagsMap['error'];
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> addTags -> res: $res error: $error");
                  });
                  Navigator.pop(context);
                },
                child: new Text('OK')
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     List tags = _controller.text.split(',');
            //     MobpushPlugin.addTags(tags).then((Map<String, dynamic> tagsMap){
            //       String res = tagsMap['res'];
            //       String error = tagsMap['error'];
            //       print(">>>>>>>>>>>>>>>>>>>>>>>>>>> addTags -> res: $res error: $error");
            //     });
            //     Navigator.pop(context);
            //   },
            // )
          ],
        );
      }
    );
  }

  void _deleteTags() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Tag"),
          content: Container(
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Please input tags to delete(split by ',')...",
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
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Cancel')
            ),
            // new FlatButton(
            //   child: new Text('Cancel'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            new TextButton(
                onPressed: () {
                  List<String> tags = _controller.text.split(',');
                  MobpushPlugin.deleteTags(tags).then((Map<String, dynamic> tagsMap){
                    String res = tagsMap['res'];
                    String error = tagsMap['error'];
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> deleteTags -> res: $res error: $error");
                  });
                  Navigator.pop(context);
                },
                child: new Text('OK')
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     List tags = _controller.text.split(',');
            //     MobpushPlugin.deleteTags(tags).then((Map<String, dynamic> tagsMap){
            //       String res = tagsMap['res'];
            //       String error = tagsMap['error'];
            //       print(">>>>>>>>>>>>>>>>>>>>>>>>>>> deleteTags -> res: $res error: $error");
            //     });
            //     Navigator.pop(context);
            //   },
            // )
          ],
        );
      }
    );
  }

  void _bindPhoneNum() async {
    // 先清空输入框内容
    _controller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("BindPhoneNum"),
          content: Container(
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Please input phone number...",
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
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')
            ),
            // new FlatButton(
            //   child: new Text('Cancel'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            new TextButton(
                onPressed: () {
                  MobpushPlugin.bindPhoneNum(_controller.text).then((Map<String, dynamic> phoneMap){
                    String res = phoneMap['res'];
                    String error = phoneMap['error'];
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> bindPhoneNum -> res: $res error: $error");
                  });
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     MobpushPlugin.bindPhoneNum(_controller.text).then((Map<String, dynamic> phoneMap){
            //       String res = phoneMap['res'];
            //       String error = phoneMap['error'];
            //       print(">>>>>>>>>>>>>>>>>>>>>>>>>>> bindPhoneNum -> res: $res error: $error");
            //     });
            //     Navigator.pop(context);
            //   },
            // )
          ],
        );
      }
    );
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
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Please input badge number...",
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
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')
            ),
            // new FlatButton(
            //   child: Text('Cancel'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            new TextButton(
                onPressed: () {
                  int badge = int.parse(_controller.text);
                  MobpushPlugin.setBadge(badge);
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     int badge = int.parse(_controller.text);
            //     MobpushPlugin.setBadge(badge);
            //     Navigator.pop(context);
            //   },
            // )
          ],
        );
      }
    );
  }

  void _setAPNsShowForegroundType() {
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
          title: Text("ShowType"),
          content: Container(
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Please input show type 0-7 ...",
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
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')
            ),
            // new FlatButton(
            //   child: Text('Cancel'),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            new TextButton(
                onPressed: () {
                  int type = int.parse(_controller.text);
                  MobpushPlugin.setAPNsShowForegroundType(type);
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     int type = int.parse(_controller.text);
            //     MobpushPlugin.setAPNsShowForegroundType(type);
            //     Navigator.pop(context);
            //   },
            // )
          ],
        );
      }
    );
  }

  // 工具方法
  void _showWarningDialog(bool isOnlyForAnd) {
    String noti = isOnlyForAnd ? 'Android' : 'iOS';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Warning⚠️"),
          content: Container(
            child: Text(
              '仅 $noti 可用！'
            ),
          ),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text("OK")
            )
            // new FlatButton(
            //   child: new Text("OK"),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // )
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
        textTheme: TextTheme(headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: new ListView.separated (
        padding: const EdgeInsets.all(15.0),
        itemCount: otherAllAPIs.length,
        itemBuilder: (context, i) {
          return new ListTile(
            title: new Text(
              otherAllAPIs[i],
              style: const TextStyle(fontSize: 18.0),
            ),
            trailing: new Icon(
              Icons.arrow_forward_ios
            ),
            onTap: () {
              setState(() {
                print('----->' + otherAllAPIs[i] + i.toString());
                _onListRowClicked(i);
              });
            },
          );
        },
        separatorBuilder: (context, index) => Divider(height: .0),
      )
    );
  }

  Future _onListRowClicked(int index) async {
    switch (index) {
      case 0:
        await MobpushPlugin.stopPush();
        break;
      case 1:
        await MobpushPlugin.restartPush();
        break;
      case 2:
        bool isStop = await MobpushPlugin.isPushStopped();
        print('>>>>>>>>>>>>>>>>>Push stop state:$isStop');
        break;
      case 3:
        _setAlias();
        break;
      case 4:
        MobpushPlugin.getAlias().then((Map<String, dynamic> aliasMap){
          String res = aliasMap['res'];
          String error = aliasMap['error'];
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>> getAlias -> res: $res error: $error");
        });
        break;
      case 5:
        MobpushPlugin.deleteAlias().then((Map<String, dynamic> aliasMap){
          String res = aliasMap['res'];
          String error = aliasMap['error'];
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>> deleteAlias -> res: $res error: $error");
        });
        break;
      case 6:
        _addTags();
        break;
      case 7:
        MobpushPlugin.getTags().then((Map<String, dynamic> tagsMap){

           List<dynamic> resList;
          if (tagsMap['res'] == null) {
            resList = [];
          } else {
            resList = tagsMap['res'].toList();
          }
          String error = tagsMap['error'];

          print(
              ">>>>>>>>>>>>>>>>>>>>>>>>>>> getTags -> res: $resList error: $error");
        });
        break;
      case 8:
        _deleteTags();
        break;
      case 9:
        MobpushPlugin.cleanTags().then((Map<String, dynamic> tagsMap){
          String res = tagsMap['res'];
          String error = tagsMap['error'];
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>> cleanTags -> res: $res error: $error");
        });
        break;
      case 10:
        _bindPhoneNum();
        break;
      case 11:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        await MobpushPlugin.setSilenceTime(20, 0, 8, 0);
        break;
      case 12:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        await MobpushPlugin.removeLocalNotification(0);
        break;
      case 13:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        await MobpushPlugin.clearLocalNotifications();
        break;
      case 14:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        setState(() {
          hiddenNotify = !hiddenNotify;
        });
        await MobpushPlugin.setAppForegroundHiddenNotification(hiddenNotify);
        break;
      case 15:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        await MobpushPlugin.setNotifyIcon("ic_launcher");
        break;
      case 16:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        setState(() {
          launchMain = !launchMain;
        });
        await MobpushPlugin.setClickNotificationToLaunchMainActivity(launchMain);
        break;
      case 17:
        if (!Platform.isAndroid) {
          _showWarningDialog(true);
          return;
        }
        await MobpushPlugin.setShowBadge(true);
        break;
      case 18:
        _setBadge();
        break;
      case 19:
        if (!Platform.isIOS) {
          _showWarningDialog(false);
          return;
        }
        MobpushPlugin.clearBadge();
        break;
      case 20:
        if (!Platform.isIOS) {
          _showWarningDialog(false);
          return;
        }
        _setAPNsShowForegroundType();
        break;
      default:
        break;
    }
  }

}
