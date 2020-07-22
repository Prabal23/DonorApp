import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/RiderSection/PickUpView/PickUpView.dart';
import 'package:design_app/Screen/RiderSection/RiderTake/RiderTake.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class RiderCard extends StatefulWidget {
  final pickingList;
  final value;
  RiderCard(this.pickingList, this.value);
  @override
  _RiderCardState createState() => _RiderCardState();
}

class _RiderCardState extends State<RiderCard> {
  String formattedDate;
  String formattedTime;
  var donationStatus;

  

  @override
  void initState() {
   // todayDate();
    // donationStatus = (widget.pickingList.status == null)
    //  ? "- - -"
    //  : (widget.pickingList.status =='Pending')
    //      ? "OPEN"
    //   : (widget.pickingList.status =='Picked')
    //    ? "FOR PICKUP"
    //        :"${widget.pickingList.status}";
      super.initState();
  }

  todayDate() {
   if(widget.pickingList.pickupDate != null) {
    var dateTime = DateTime.parse("${widget.pickingList.pickupDate}");
    formattedDate = DateFormat('EEE, MMM d, yyyy').format(dateTime);
    print(formattedDate);
    print(dateTime);
   }
    // var dateTime2 = DateTime.parse("${widget.pickingList.pickupTime}");
    // formattedTime = DateFormat('EEE, hh:mm').format(dateTime2);
    // print(formattedTime);
    // print(dateTime2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
      // child: Slidable(
      //     actionPane: SlidableDrawerActionPane(),
      //     actionExtentRatio: 0.25,
      // child: GestureDetector(
      //   onTap: () {
      //     Navigator.push(context, SlideLeftRoute(page: RiderTake()));
      //   },
      child: Card(
        elevation: 1,
        //  margin: EdgeInsets.only(bottom: 5, left: 5),
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
          padding: EdgeInsets.only(right: 12, left: 20, top: 20, bottom: 15),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                //color: Colors.red,
                child: Container(
                  //color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5, right: 5),
                            child: Text(
                              "STATUS :  ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     SlideLeftRoute(
                              //         page: PickUpView(
                              //             widget.pickingList)));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                (widget.pickingList.status == null)
                                    ? "- - -"
                                    : (widget.pickingList.status =='Pending')
                                        ? "OPEN"
                                        : (widget.pickingList.status =='Picked')
                                        ? "FOR PICKUP"
                                        : "${widget.pickingList.status}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "Roboto-Regular",
                                    fontSize: 15,
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
                            margin: EdgeInsets.only(top: 8, right: 5),
                            child: Text(
                              "DONATED BY  :  ",
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
                                widget.pickingList.doner == null
                                    ? "- - -"
                                    : "${widget.pickingList.doner.name}", //"Donation",
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
                            margin: EdgeInsets.only(top: 8, right: 5),
                            child: Text(
                              "PICKUP LOCATION  :  ",
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
                                widget.pickingList.address == null
                                    ? "- - -"
                                    : "${widget.pickingList.address}", //"Donation",
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
                            margin: EdgeInsets.only(top: 8, right: 8),
                            child: Text(
                              "PICKUP DATE  :  ",
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
                              margin: EdgeInsets.only(top: 8),
                              child: Text(
                                widget.pickingList.pickupDate == null
                                    ? "- - -"
                                    : "${widget.pickingList.pickupDate}", //"Donation",
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
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 8, right: 8),
                            child: Text(
                              "PICKUP TIME  :  ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              widget.pickingList.pickupTime == null
                                  ? "- - -"
                                  : "${widget.pickingList.pickupTime}", //"Donation",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),

                        Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          onPressed: () {
                            if (widget.pickingList.status =='Pending') {
                              Navigator.push(
                              context,
                              SlideLeftRoute(
                              page: PickUpView(widget.pickingList, widget.value)));
                            } else {
                              Navigator.push(
                              context,
                              SlideLeftRoute(
                              page: RiderTake(widget.pickingList, widget.value)));
                            }
                          },
                          color: appColor,
                          child: Container(
                            padding: EdgeInsets.only(top: 8, bottom: 8, left: 40, right: 40),
                            child: Text(
                              (widget.pickingList.status =='Pending')?
                              'For Pickup'
                              :(widget.pickingList.status =='Picked')?
                              'Taken'
                              : 'View',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
      // secondaryActions: <Widget>[
      //   IconSlideAction(
      //       caption: 'Take it',
      //       color: Colors.grey[400],
      //       icon: Icons.playlist_add_check,
      //       onTap: () {
      //         Navigator.push(context, SlideLeftRoute(page: PickUpView()));
      //       }),
      // ]),
    );
  }
}
