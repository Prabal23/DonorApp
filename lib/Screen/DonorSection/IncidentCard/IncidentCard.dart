import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/DonorSection/DonateAddCompose/DonateAddCompose.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../donate_view_add_screen.dart';

class IncidentCard extends StatefulWidget {
  final incidentList;
  final alertDate;
  IncidentCard(this.incidentList, this.alertDate);
  @override
  _IncidentCardState createState() => _IncidentCardState();
}

class _IncidentCardState extends State<IncidentCard> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  var incidentId = '';
  var userToken = '';

  List donations = [];


  @override
  void initState() {
    incidentId = widget.incidentList.id == null ? "" : '${widget.incidentList.id}';
    print('incidentId');
    print(incidentId);
    _getUserInfo();
    donationList();
    super.initState();
  }

  List<String> status = [];
  String donationStatus;

  List pickupTime = [];
  var donationsPickupTime;

  donationList() {
    for (int i = 0; i < widget.incidentList.donation.length; i++) {
      donations.add(widget.incidentList.donation[i]);
      status.add(widget.incidentList.donation[i].status);
      donationStatus = status[i];

      pickupTime.add(widget.incidentList.donation[i].pickupTime);
      donationsPickupTime = pickupTime[i];
    }
    print(donations.length);
    print('donations');
    print(donations);
    print(donations.length);
    print('status');
    print(donationStatus);
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user = localStorage.getString('user');
    if (token != null || user != null) {
      var userinfoList = json.decode(user);
      // donerId = userinfoList['id'];
      userToken = token;
      print('userToken');
      print(userToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Slidable(
      //     actionPane: SlidableDrawerActionPane(),
      //     actionExtentRatio: 0.25,
      //     child: GestureDetector(
      //       onTap: () {
      // Navigator.push(
      //     context, SlideLeftRoute(page: DonateViewAddScreen()));
           // },
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
          padding: EdgeInsets.only(right: 12, left: 15, top: 10, bottom: 10),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          //color: Colors.blue,
          child: Column(
            children: <Widget>[
              Container(
                // color: Colors.red,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Alert  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: Color(0xFFEC4647),
                                        fontFamily: "Roboto-Bold",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.incidentList.created_at == ''
                                          ? ""
                                          : "${widget.incidentList.created_at}",
                                      // widget.alertDate == ''
                                      // ? ""
                                      // : "${widget.alertDate}",
                                      overflow: TextOverflow.clip,
                                      textDirection: TextDirection.ltr,
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
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Situation  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.incidentList.situation == null
                                          ? ""
                                          : "${widget.incidentList.situation.situation}", //"Situation",
                                      overflow: TextOverflow.clip,
                                      textDirection: TextDirection.ltr,
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
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Donate Status  :  ",
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Text(
                                      donations.length == 0
                                          ? "---"
                                          : "$donationStatus", //"Donate Status",
                                      overflow: TextOverflow.clip,
                                      textDirection: TextDirection.ltr,
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
                    Row(
                      children: <Widget>[
                        donations.length == 0?
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,SlideLeftRoute(page:DonateAddCompose(widget.incidentList)));
                          },
                          child: Container(
                              //color: Colors.red,
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.add,
                                color: appColor,
                                size: 28,
                              )),
                        )
                        :
                        Container(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                SlideLeftRoute(page: DonateViewAddScreen(widget.incidentList)));
                          },
                          child: Container(
                              //color: Colors.red,
                              padding: EdgeInsets.fromLTRB(10, 10, 2, 10),
                              child: Icon(
                                Icons.remove_red_eye,
                                color: appColor,
                                size: 26,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      //),
      // secondaryActions: <Widget>[
      //   IconSlideAction(
      //       caption: 'Delete',
      //       color: Colors.red,
      //       icon: Icons.delete,
      //       onTap: () {
      //         _deleteConfirmationDialog();
      //         // Navigator.push(
      //         //     context, SlideLeftRoute(page: DonateAddCompose(widget.incidentList)));
      //       }),
      // ]
      // ),
    );
  }
  // Future<void> confirmCancel() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   var items = {
  //     // "shareMessage": contrl.text,
  //     "reason": '',
  //     // "donerId": userToken,
  //   };

  //   print(items);

  //   var res =
  //       await CallApi().postData(items, '/app/CancleIncidentforDoner/$incidentId?token=$userToken');

  //   var body = json.decode(res.body);
  //   print(body);

  //   if (res.statusCode == 200) {
  //     showMsg();
  //   }

  //   // print(items);

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void showMsg() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1.5,
                color: Theme.of(context).primaryColor,
              )),
          elevation: 16,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: 45.0, right: 45.0, top: 15.0, bottom: 15.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Success",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 12.0,
                    bottom: 35.0,
                  ),
                  child: Text(
                    "Donation is cancelled successfully",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 112, 112, 112)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           DonorIncidentPage())
                      // );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   ///////Dialog ////////////////////
  void _deleteConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        child: new Text(
                          "Do you want to delete this incident?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appColor,
                            fontSize: 19.0,
                            decoration: TextDecoration.none,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    //color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ///////// Cancle Button Start /////
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.white),
                            height: 45,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: Text(
                                  'Cancel',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: appColor,
                                    fontSize: 18.0,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                            )),

                        ///////// Cancle Button end /////

                        ///////// Ok Button Start /////
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Color(0XFFFB7676),
                            ),
                            height: 45,
                            child: RaisedButton(
                              onPressed: () {
                                // Navigator.of(context).pop();
                               // confirmCancel();
                              },

                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: Text(
                                  'Ok',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Color(0XFF1A3D7A),
                                    fontSize: 18.0,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              color: Color(0XFFFB7676),
                              elevation: 2.0,
                              //splashColor: Colors.blueGrey,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                            )),

                        ///////// Ok Button end /////
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
