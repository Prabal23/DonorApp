import 'dart:convert';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DonorNotificationPage.dart';


class DonorNotificationDetails extends StatefulWidget {
  final title;
  final msg;

  DonorNotificationDetails(this.title, this.msg);

  @override
  _DonorNotificationDetailsState createState() =>
      _DonorNotificationDetailsState();
}

class _DonorNotificationDetailsState extends State<DonorNotificationDetails> {
  String isReviewd = "";
  var body;
  var orderData;
  bool _isLoading = true;

  @override
  void initState() {
    // print(_isLoading);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: appColor,
        title: const Text('Details'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context, SlideLeftRoute(page: DonorNotificationPage()));
              },
            );
          },
        ),
      ),
      body:
          // _isLoading?
          //    Center(
          //      child: Container(

          //       // color: Colors.red,
          //                               child: Text(
          //                                 "Please wait to see details.... ",
          //                                 textAlign: TextAlign.left,
          //                                 style: TextStyle(
          //                                     color: appColor,
          //                                     fontFamily: "DINPro",
          //                                     fontSize: 15,
          //                                     fontWeight: FontWeight.w500),
          //                               ),
          //                             ),
          //    ):
          WillPopScope(
        onWillPop: _onWillPop,
            child: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            //color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //////// Order Number/////////

                Container(
                  margin: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Title     :        ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "DINPro",
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title == null ? '' :
                          "${widget.title}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "DINPro",
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Message    :    ",
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: "DINPro",
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.normal),
                      ),
                      Expanded(
                        child: Text(
                          widget.msg == null ? '' :
                          "${widget.msg}",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: "DINPro",
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
          ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.push(context,
                      SlideLeftRoute(page: DonorNotificationPage()));
    return false;
    // WillPopScope(
  //       onWillPop: _onWillPop,
  }
}
