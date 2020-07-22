import 'package:flutter/material.dart';

class PreviewImage extends StatefulWidget {
  final index;
  PreviewImage(this.index);
  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.all(10),
        // color: Colors.white,
        padding: EdgeInsets.only(top: 30, bottom: 20),
          child: Image.network(
        widget.index,
        // height: 50,
        // width: 100,
        fit: BoxFit.cover,
      )),
    );
  }
}
