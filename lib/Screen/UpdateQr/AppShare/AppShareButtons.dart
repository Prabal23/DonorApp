import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/UpdateQr/AppShare/AppShareAndroid.dart';
import 'package:design_app/main.dart';
import 'package:design_app/model/AppLinkModel/AppLinkModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'AppShareIOS.dart';

class AppShareButtons extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppShareButtonsState();
}

class AppShareButtonsState extends State<AppShareButtons> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();
  var iosLink = '';
  var androidLink = '';

  var appLinkBody, appLinkList;

  @override
  void initState() { 
    super.initState();
    getAppLink();
  }


  Future<void> getAppLink() async {

    var res = await CallApi().logIngetData('/app/showAppLink');

    appLinkBody = json.decode(res.body);
    print(appLinkBody);

    if (res.statusCode == 200) {
      var appLinkcontent = res.body;
      final appLink = json.decode(appLinkcontent);

      var appLinkdata = AppLinkModel.fromJson(appLink);
      appLinkList = appLinkdata.appLink;

      if (appLinkList != null) {
        setState(() {
          iosLink = appLinkList.ios == null? '' : appLinkList.ios;
          androidLink = appLinkList.android == null? '' : appLinkList.android;
          print('appLinkList');
          print(appLinkList);
          print('iosLink');
          print(iosLink);
          print('androidLink');
          print(androidLink);
        });
        print(appLink);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Share'),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 12.0,
                right: 10.0,
                bottom: _topSectionBottomPadding,
              ),
              child: Text(
                '# Invite nearby friends via scanning QR code or link',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
              child: RaisedButton(
                color: appColor,
                onPressed: () {
                  Navigator.push(
                  context, SlideLeftRoute(page: AppShareAndroid(androidLink)));
                },
                child: Text('GET ANDROID APP',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
              child: RaisedButton(
                color: appColor,
                onPressed: () {
                  Navigator.push(
                  context, SlideLeftRoute(page: AppShareIOS(iosLink)));
                },
                child: Text('GET IOS APP',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            // Text('$androidLink'),
            // Text('$iosLink')
          ],
        )),
      ),
    );
  }
}
