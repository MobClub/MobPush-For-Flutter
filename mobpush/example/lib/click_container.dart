import 'package:flutter/material.dart';

class clickcontainer extends StatefulWidget{
  double left;
  double top;
  double right;
  double bottom;
  String res;
  String content;
  GestureTapCallback onTap;

  clickcontainer({this.content, this.res, this.left, this.top, this.right, this.bottom, this.onTap});

  @override
  _ClickContainerState createState() {
    return _ClickContainerState();
  }
}

class _ClickContainerState extends State<clickcontainer>{

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left:widget.left, top: widget.top,
            right: widget.right, bottom:widget.bottom),
        decoration: BoxDecoration(
          color: Color(0xFFebf2ff),
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(widget.res),
            Text(widget.content)
          ],
        ),
      ),
      onTap: widget.onTap,
    );
  }
  }
