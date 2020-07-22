import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/RiderSection/PickUpView/PickUpView.dart';
import 'package:design_app/Screen/RiderSection/RiderTake/RiderTake.dart';
import 'package:design_app/Services/callAndMsgServices.dart';
import 'package:design_app/Services/service_locator.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../custom_icons_icons.dart';

class EmergencyHotlineCard extends StatefulWidget {
  final emergencyHotlineList;
  EmergencyHotlineCard(this.emergencyHotlineList);
  @override
  _EmergencyHotlineCardState createState() => _EmergencyHotlineCardState();
}

class _EmergencyHotlineCardState extends State<EmergencyHotlineCard> {
  String formattedDate;
  String formattedTime;
  var donationStatus;

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  var number = "";

  @override
  void initState() {
    number = widget.emergencyHotlineList.telephone == null? "": "${widget.emergencyHotlineList.telephone}";
    print(number);
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, left: 0, right: 5),
      child: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
         // color: Colors.yellow,

        // padding: EdgeInsets.only(right: 12, left: 20, top: 20, bottom: 15),
        // alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
             // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 5, top: 5,),
                  child: IconButton(
                    icon:
                    widget.emergencyHotlineList.type == null
                    ? Icon(CustomIcons.phone_2, color: appColor, size: 24,)
                    : (widget.emergencyHotlineList.type =='Police')
                    ? Icon(CustomIcons.taxi, color: appColor, size: 23,)
                    : (widget.emergencyHotlineList.type =='Government Office')
                    ? Icon(CustomIcons.bank, color: appColor, size: 24,)
                    : (widget.emergencyHotlineList.type =='Ambulance')
                    ? Icon(CustomIcons.ambulance, color: appColor, size: 24,)
                    : (widget.emergencyHotlineList.type =='Hospital')
                    ? Icon(CustomIcons.hospital, color: appColor, size: 24,)
                    : (widget.emergencyHotlineList.type =='Non-Government Organization')
                    ? Icon(CustomIcons.apartment, color: appColor, size: 24,)
                    : Icon(CustomIcons.phone_2, color: appColor, size: 24,), onPressed: () { print('a'); },
                  ),//Icon(Icons.home, size: 26, color: appColor,),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                       // color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 2, right: 5, bottom: 2),
                                  child: Text(
                                    "Type       : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: appColor,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 2, bottom: 2),
                                    child: Text(
                                      widget.emergencyHotlineList.type == null
                                          ? "- - -"
                                          : "${widget.emergencyHotlineList.type}", //"Donation",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 5, right: 5),
                                  child: Text(
                                    "Address  : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: appColor,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      widget.emergencyHotlineList.address == null
                                          ? "- - -"
                                          : "${widget.emergencyHotlineList.address}", //"Donation",
                                      overflow: TextOverflow.clip,

                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 5, right: 8),
                                  child: Text(
                                    "Tel           : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: appColor,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      widget.emergencyHotlineList.telephone == null
                                          ? "- - -"
                                          : "${widget.emergencyHotlineList.telephone}", //"Donation",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: Icon(CustomIcons.phone, color: Colors.black, size: 26), onPressed: () => _service.call(number),),//Icon(Icons.phone),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], height: 20, thickness: 1, indent: 8, endIndent: 8,),
          ],
        ),
      ),
    );
  }
}
