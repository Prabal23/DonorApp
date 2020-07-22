import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/BeneficiarySection/Beneficiary/Beneficiary.dart';
import 'package:design_app/main.dart';
import 'package:design_app/model/NotificationModel/NotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BeneficiaryNotificationDetails.dart';

class BeneficiaryNotificationPage extends StatefulWidget {
  @override
  _BeneficiaryNotificationPageState createState() => _BeneficiaryNotificationPageState();
}

class _BeneficiaryNotificationPageState extends State<BeneficiaryNotificationPage> {
  var body, body1, body2, notificData, userToken;
  bool _notificLoading = true;
  List bbb = ['1', '2', '3'];

  var orderData;

  @override
  void initState() {
    _allData();

    super.initState();
  }

  Future<void> _allData() {
    _showAllNotifications();
  }

  Future _getLocalNotiData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localOrderData = localStorage.getString(key);
    if (localOrderData != null) {
      body = json.decode(localOrderData);
      print('local data');
      print(body);
      _orderState();
    }
  }

  Future<void> _showAllNotifications() async {
    var key = 'all-notifications-list';
    await _getLocalNotiData(key);

    var res = await CallApi().getDataWithToken2('/app/allNotification');
    body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      _orderState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  void _orderState() {
    var notifis = NotificationModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      notificData = notifis.allNotification;
      _notificLoading = false;
    });

    print('notification dataddssssss');
    print(notificData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: appColor,
        automaticallyImplyLeading: true,
        title: const Text('Notification'),
        titleSpacing: 0.5,
        leading: 
        Builder(
          builder: (BuildContext context) {
            return 
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, SlideLeftRoute(page: Beneficiary()));
              },
            );
          },
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              updateAllNotif();
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 18, 10, 2),
                child: Text('Mark all as Read',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "sourcesanspro",
                    ))),
          ),
        ],
      ),
      body:
          //  _notificLoading
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          WillPopScope(
        onWillPop: _onWillPop,
            child: SafeArea(
        child: RefreshIndicator(
            onRefresh: _showAllNotifications,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                child: Column(children: <Widget>[
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     GestureDetector(
                  //       onTap: () {
                  //         updateAllNotif();
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.fromLTRB(10, 20, 10, 2),
                  //         child: Text('Mark all as Read',
                  //         style: TextStyle(
                  //           color: appColor, fontSize: 15, fontFamily: "sourcesanspro",
                  //         ))),
                  //     ),
                  //   ],
                  // ),
                  notificData == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : notificData.length == 0
                          ? Center(
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: 10, right: 10, top: 100),
                              child: Text("No notifications yet!"),
                            ))
                          : SingleChildScrollView(
                              // physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Column(
                                  children: List.generate(notificData.length //bbb.length //
                                      , (index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 5, top: 5, left: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          //   print(notificData[index].id);
                                          if (notificData[index].seen == 0) {
                                            updateNotify(notificData[index].id);
                                          }

                                          // if (notificData[index].type == "Order") {
                                          //   //   print("orderrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
                                          //   ////////// Me //////////////
                                          if (notificData[index].title != null) {
                                            Navigator.push(
                                                context,
                                                SlideLeftRoute(
                                                    page: BeneficiaryNotificationDetails(notificData[index].title,
                                                    notificData[index].msg)));
                                          }

                                          // }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[200],
                                                  blurRadius: 17,
                                                )
                                              ],
                                              color: notificData[index].seen == 1
                                                  ? Colors.white
                                                  : Color(0xFFEAF5FF)),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 7),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            padding: EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(100),
                                                                border: Border.all(width: 0.5,
                                                                    color: Colors.grey)),
                                                            alignment: Alignment.center,
                                                            margin: EdgeInsets.only(right: 10.0, left: 10),
                                                            child: Icon(
                                                              Icons.notifications,
                                                              color: Colors.grey,
                                                              size: 17,
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                width: MediaQuery.of(context).size.width /1.9,
                                                                padding: EdgeInsets.only(top: 5),
                                                                child: Text(
                                                                  "${notificData[index].title}", //'vg', //
                                                                  // "${d.quantity}x ${d.item.name}",
                                                                  textAlign: TextAlign.left,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      color: appColor,
                                                                      fontFamily: "sourcesanspro",
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width /1.5,
                                                                alignment: Alignment.centerLeft,
                                                                padding: EdgeInsets.only(
                                                                        top: 5, bottom: 0),
                                                                child: Text(
                                                                  "${notificData[index].msg}", //'hh', //
                                                                  // maxLines: ,
                                                                  overflow: TextOverflow.visible,
                                                                  //  "\$${(d.item.price * d.quantity).toStringAsFixed(2)}",
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                      color: Colors.black54,
                                                                      fontFamily: "sourcesanspro",
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   child: Row(
                                                    //     children: <Widget>[
                                                    //       Container(
                                                    //         child: IconButton(
                                                    //           icon: Icon(
                                                    //             Icons.delete,
                                                    //             size: 18,
                                                    //             color: appColor,
                                                    //           ),
                                                    //           onPressed: () {
                                                    //             _showDeleteAlert(index);
                                                    //           },
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                ]),
              ),
            ),
        ),
      ),
          ),
    );
  }

  updateNotify(id) async {
    var data = {
      'id': id,
    };

    var res = await CallApi().postData1(data, '/app/specificNotifUpdateToSeen');

    body1 = json.decode(res.body);

    print(data);
    print(body1);

    if (res.statusCode == 200) {
      //    store.dispatch(SeenNotificationAction(store.state.unseenState-1));

      // setState(() {
      //   _showAllNotifications();
      //    // _showToast();
      //  });

      // print(notificData[index].type);
      // print(notificData[index].id);

    }
  }

  updateAllNotif() async {
    var data = {
      //   'id': id,
    };

    var res = await CallApi().postData1(data, '/app/allNotifUpdateToSeen');

    body2 = json.decode(res.body);

    print(data);
    print(body2);

    if (res.statusCode == 200) {
      //    store.dispatch(SeenNotificationAction(store.state.unseenState-1));

      setState(() {
        _showAllNotifications();
        // _showToast();
      });

      // print(notificData[index].type);
      // print(notificData[index].id);

    }
  }

  deleteNotifyList(id) async {
    // var data = {
    //   'id': id,
    // };

    // var res = await CallApi()
    //     .postData(data, '/app/deleteNotification');

    // body1 = json.decode(res.body);

    // //print(data);

    // if (res.statusCode == 200) {
    //   setState(() {
    //     _showAllNotifications();
    //     //  _showToast();
    //   });
    // }
  }

  // _showToast() {
  //   Fluttertoast.showToast(
  //       msg: "Deleted successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 1,
  //       backgroundColor: appTealColor.withOpacity(0.9),
  //       textColor: Colors.white,
  //       fontSize: 13.0);
  // }

  void _showDeleteAlert(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
            //    width: double.maxFinite,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //  color: Colors.red,
                  // width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 30),
                  // height: 40,
                  alignment: Alignment.center,

                  child: Text(
                    "Are you sure you want to remove this item from notification?",
                    textAlign: TextAlign.center,
                    //maxLines: 3,
                    style: TextStyle(
                        color: Color(0XFF414042),
                        fontFamily: "SourceSansPro",
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        deleteNotifyList(notificData[index].id);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 80,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: appColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child:
                            Text("Yes", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        width: 80,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: appColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Text("No", style: TextStyle(color: appColor)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.push(context,
                      SlideLeftRoute(page: Beneficiary()));
    return false;
    // WillPopScope(
  //       onWillPop: _onWillPop,
  }
}
