import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class AppShareIOS extends StatefulWidget {
  final iosLink;
  AppShareIOS(this.iosLink);

  @override
  State<StatefulWidget> createState() => AppShareIOSState();
}

class AppShareIOSState extends State<AppShareIOS> {

  static const double _topSectionTopPadding = 30.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  @override
  void initState() {
    _dataString = widget.iosLink == null? '---' : widget.iosLink;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Share'),
      ),
      body: _contentWidget(),
    );
  }



  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      padding: EdgeInsets.only(bottom: 60),
      child:  Column(
        children: <Widget>[
            Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10.0,
              right: 10.0,
             // bottom: _topSectionBottomPadding,
            ),
            child: Text('# Invite nearby friends via scanning QR code or link', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            // child:  Container(
            //   height: _topSectionHeight,
            //   child:  Row(
            //     mainAxisSize: MainAxisSize.max,
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: <Widget>[
            //       Expanded(
            //         child:  TextField(
            //           controller: _textController,
            //           decoration:  InputDecoration(
            //             hintText: "Enter a custom message",
            //             errorText: _inputErrorText,
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10.0),
            //         child:  FlatButton(
            //           child:  Text("SUBMIT"),
            //           onPressed: () {
            //             setState((){
            //               _dataString = _textController.text;
            //               _inputErrorText = null;
            //             });
            //           },
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                  // onError: (ex) {
                  //   print("[QR] ERROR - $ex");
                  //   setState((){
                  //     _inputErrorText = "Error! Maybe your input value is too long?";
                  //   });
                  // },
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SelectableText('$_dataString',
            onTap: () {
              Share.share('$_dataString');
              // launch(_dataString);
              // if (await canLaunch(url)) {
              //   await launch(url);
              // } else {
              //   throw 'Could not launch $url';
              // }
            },
            style: TextStyle(
              color: Colors.blue,
              fontSize: 17,
              decoration: TextDecoration.underline,
            ),),
          )
        ],
      ),
    );
  }
}