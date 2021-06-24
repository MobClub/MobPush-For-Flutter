
import 'package:flutter/material.dart';

class ClickContainer extends StatefulWidget {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final String res;
  final String content;
  final GestureTapCallback onTap;

  ClickContainer(
    {
      required this.content,
      required this.res,
      required this.left,
      required this.top,
      required this.right,
      required this.bottom,
      required this.onTap
    }
  );

  @override
  _ClickContainerState createState() {
    return _ClickContainerState();
  }
}

class _ClickContainerState extends State<ClickContainer> {

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
