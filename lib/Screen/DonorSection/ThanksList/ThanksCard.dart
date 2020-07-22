import 'dart:async';

import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../donate_cancel_screen.dart';

class ThanksCard extends StatefulWidget {
  final thanksList;
  ThanksCard(this.thanksList);
  @override
  _ThanksCardState createState() => _ThanksCardState();
}

class _ThanksCardState extends State<ThanksCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      child: Card(
        elevation: 1,
       // margin: EdgeInsets.only(bottom: 5, top: 5),
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 16.0,
                // offset: Offset(0.0,3.0)
              )
            ],
            // border: Border.all(
            //   color: Color(0xFF08be86)
            // )
          ),
          padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 20),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          //color: Colors.blue,
          child: Column(
            children: <Widget>[
              Container(
                // color: Colors.red,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    "Donation ID  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xFFEC4647),
                                        fontFamily: "Roboto-Bold",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.thanksList.donationId == null
                                        ? "- - -"
                                        : "${widget.thanksList.donationId}",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Beneficiary Name  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.thanksList.beneficiar.name == ""
                                          ? "- - -"
                                          : "${widget.thanksList.beneficiar.name}",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Message  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Text(
                                     // "Donate Status",
                                      widget.thanksList.message == ""
                                          ? "- - -"
                                          : "${widget.thanksList.message}",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Date  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Text(
                                     // "Donate Status",
                                      widget.thanksList.created_at == null
                                          ? "- - -"
                                          : "${widget.thanksList.created_at}",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14,
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
                    // GestureDetector(
                    //   onTap: () {
                    //     // Navigator.push(context,
                    //     //     SlideLeftRoute(page: ThanksCardDetails()));
                    //   },
                    //   child: Container(
                    //       //color: Colors.red,
                    //       padding: EdgeInsets.fromLTRB(10, 10, 2, 10),
                    //       child: Icon(
                    //         Icons.remove_red_eye,
                    //         color: appColor,
                    //         size: 26,
                    //       )),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}