import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/Profile/ProfileEditForm.dart';
import 'package:design_app/Screen/PublicReporterSection/AddIncidentByReporter/addIncidentByReporter.dart';
import 'package:design_app/Screen/PublicReporterSection/PublicReporterNotification/PublicReporterNotificationPage.dart';
import 'package:design_app/Screen/PublicReporterSection/ReporterCard/ReporterCard.dart';
import 'package:design_app/Screen/permissions_service.dart';
import 'package:design_app/model/PublicReporterModel/PublicReporterModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../login.dart';

class PublicReporter extends StatefulWidget {
  @override
  _PublicReporterState createState() => _PublicReporterState();
}

class _PublicReporterState extends State<PublicReporter> {
  TextEditingController msgController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var format;
  var userData;
  var _showImage;
  bool noDonoation = false;
  var body, donorBody, incidentList;
  List donorList = [];
  var userToken = '';
  var date = "Select Date",
      msg = "",
      situation = "",
      incidentMsg = "No incident found on this date !!";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int showNumber = 0;
  int notificCount = 0;
  bool _notificLoading = true;
  bool _fromTop = true;
  var notifBody;

  @override
  void initState() {
    setState(() {
      date = DateFormat("yyyy-MM-dd").format(selectedDate);

      loggedinInfo();
      _getUserInfo();
      getLatestIncident();
    });
    _fireBaseNotification();
    notifyCount();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    print("date");
    print(date);
    super.initState();
  }

  void loggedinInfo() async {
    loggedData = 'Public Reporter';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('loggedIn', loggedData);
    print('loggedData');
    print(loggedData);
  }

 void _fireBaseNotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        notifyCount();
        // _showNotificationPop(
        //     message['notification']['title'], message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        pageLaunch(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        pageDirect(message);
      },
    );
  }

  // showNotifyListCount() async {
  //     var data = {};
  //   var res =
  //       await CallApi().postData(data,'/app/allNotification');

  //   body1 = json.decode(res.body);

  //   print(body1);

  //   if (res.statusCode == 200) {
  //     setState(() {
  //       print("done");
  //     });
  //   }
  // }

  Future<void> notifyCount() async {
    var res = await CallApi().getDataWithToken2('/app/allUnseenNotification');
    notifBody = json.decode(res.body);
    print(notifBody);

    if (res.statusCode == 200) {
      _orderState();
    }
  }

  void _orderState() {
    if (!mounted) return;
    setState(() {
      notificCount = notifBody["allUnseenNotif"];
      var notif = notificCount.toString();
      print('djkhfhdbf $notif');
      // store.dispatch(UnseenNotificationAction(notificCount));
      // print("unseen");
      // print(store.state.unseenState);

      // print("seen");
      // print(store.state.seenState);
      // showNumber = store.state.unseenState - store.state.seenState;
      // print("show numberrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      // print(showNumber);
      // _notificLoading = false;
    });
    print("count");
    print(notificCount);
  }

  ///// handle looping onlaunch firebase //////
  void pageDirect(Map<String, dynamic> msg) {
    print("onResume: $msg");
    setState(() {
      index = 1;
    });
    Navigator.push(context, SlideLeftRoute(page: PublicReporterNotificationPage()));
  }

  void pageLaunch(Map<String, dynamic> msg) {
    print("onLaunch: $msg");
    pageRedirect();
  }

  void pageRedirect() {
    if (index != 1 && index != 2) {
      Navigator.push(context, SlideLeftRoute(page: PublicReporterNotificationPage()));
      setState(() {
        index = 2;
      });
    }
  }

  ///// end handle looping onlaunch firebase //////

  Future<void> allData() async{
    getLatestIncident();
    notifyCount();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user = localStorage.getString('user');

    print("user");
    print(user);
    print("token");
    print(token);
    if (token != null || user != null) {
      var userinfoList = json.decode(user);
      // donerId = userinfoList['id'];
      setState(() {
        userData = userinfoList;
        userToken = token;
      });
      // userToken = token;
      print('userToken');
      print(userToken);
    }
    _showImage = userData != null && userData['image'] != null
        ? '${userData['image']}'
        : '';
    // _showImage = null;
    print(_showImage);
   //// getLatestIncident();
  }

  Future<void> getLatestIncident() async {
    var res = await CallApi()
        .getDataWithToken('/app/showLatestPublicReport?date=$date');
    body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      var incidentcontent = res.body;
      final incident = json.decode(incidentcontent);

      var incidentdata = PublicReporterModel.fromJson(incident);
      incidentList = incidentdata.publicReport;
      if (incidentList != null) {
        setState(() {
          // String dd = incidentList.created_at;
          // var spDate = dd.split(" ");
          // date = spDate[0];
          // msg = incidentList.messageForDoner;
          // situation = incidentList.situation.situation;
          // print('situations');
          // print(situation);
        });
        print(incident);
      } else {
        setState(() {
          incidentMsg = 'No incident found on this date !!';
        });
      }
    }
  }

  // Future<void> getDonorList() async {
  //   var res = await CallApi().getData('/app/showDonation/${incidentList.id}');
  //   donorBody = json.decode(res.body);
  //   print(donorBody);

  //   if (res.statusCode == 200) {
  //     var donorcontent = res.body;
  //     final donor = json.decode(donorcontent);

  //     var donordata = DonorModel.fromJson(donor);

  //   //  setState(() {
  //       donorList = donordata.donations;
  //     // });
  //     if (donorList.length >= 1) {
  //       setState(() {
  //         noDonoation = false;
  //       });
  //       print(noDonoation);
  //     } else {
  //     setState(() {
  //         noDonoation = true;
  //       });
  //     }
  //     }
  //     print("donorList.length");
  //     print(donorList.length);
  //   }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("yyyy-MM-dd").format(selectedDate)}";
        getLatestIncident();
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(left: 0, top: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, SlideLeftRoute(page: ProfileEditForm(loggedData)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: appColor),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: _showImage == '' || _showImage == null
                          ? ClipOval(
                            child: Image.asset(
                              'assets/image/profile.png',
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,),
                          )
                          : ClipOval(
                              child: Image.network(
                                _showImage,
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Public Reporter',
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto-Bold",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Container(
                  //             margin: EdgeInsets.only(top: 10),
                  //             // decoration:
                  //             //     BoxDecoration(color: appColor, shape: BoxShape.circle),
                  //             child: IconButton(
                  //               icon: Icon(Icons.refresh, color: appColor),
                  //               onPressed: () {
                  //                 PermissionsService().requestPermission(PermissionGroup.camera);
                  //                 if(isGranted == true) {
                  //                   setState(() {
                  //                     isPermitted = true;
                  //                   });
                  //                 } else if(isGranted == false) {
                  //                   setState(() {
                  //                     isPermitted = false;
                  //                   });
                  //                 }
                  //               },
                  //               // onPressed: () {
                  //               //   Navigator.push(context,
                  //               //       SlideLeftRoute(page: DenorIncidentPage()));
                  //               // },
                  //             ),
                  //           ),
                  Container(
                    margin: EdgeInsets.only(right: 10, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.grey,
                        size: 25,
                      ),
                      onPressed: () {
                        _showLogoutDialog();
                      },
                    ),
                  ),

                    Container(
                    margin: EdgeInsets.only(right: 20, top: 10),
                    decoration:
                        BoxDecoration(color: appColor, shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed:() {
                            Navigator.push(
                          context, SlideLeftRoute(page: AddIncidentByReporter()));
                      }
                    ),
                  )

                ],
              ),
            )
          ],
        ),
        body:
        RefreshIndicator(
          onRefresh: allData,
          child:
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /////////////////   as of //////////
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 20, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'As of',
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Regular",
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     SlideLeftRoute(
                                //         page: NotificationPage()));
                              },
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideLeftRoute(
                                              page: PublicReporterNotificationPage()));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 5, right: 20),
                                      child: Icon(
                                        Icons.notifications,
                                        size: 26,
                                        color: appColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 13),
                                    // padding: EdgeInsets.only(bottom:10),
                                    decoration: BoxDecoration(
                                        color:
                                            // showNumber == 0 ||
                                            //         showNumber == null
                                            //     ? Colors.transparent
                                            //     : Colors.red[900]
                                            notificCount == 0 ||
                                                    notificCount == null
                                                ? Colors.transparent
                                                : 
                                                Colors.red[900],
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding:
                                          // showNumber < 9
                                          //     ? EdgeInsets.all(5.0)
                                          //     : EdgeInsets.all(2.0),
                                          notificCount < 9
                                          ? EdgeInsets.all(4.0)
                                          :
                                          EdgeInsets.all(2.0),
                                      child: Text(
                                        notificCount == null || notificCount == 0
                                            ? ''
                                            : notificCount > 9
                                            ? '9+'
                                            :
                                            '$notificCount',
                                        // showNumber == 0
                                        //     ? ""
                                        //     : showNumber > 9
                                        //         ? "9+"
                                        //         :
                                        //   '$showNumber',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /////////////////// date picker field /////////////

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          //color: Colors.white,
                          border: Border.all(width: 1, color: appColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              date.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            color: appColor,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectDate(context);
                                  //_showDate();
                                });
                              },
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ///////////////// Incident List //////////////////
                        Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 25, bottom: 25),
                                  child: Text(
                                    'Incident List',
                                    style: TextStyle(
                                        color: appColor,
                                        fontFamily: "Roboto-Bold",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                incidentList == null
                                    ? CircularProgressIndicator()
                                    : incidentList.length == 0
                                        ? Container(
                                            height: MediaQuery.of(context).size.height/2.5,
                                            child: Center(child: Text("No incident found on this date")))
                                        :
                                        Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5, bottom: 30),
                                            child: ListView.builder(
                                                physics: BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: incidentList.length,
                                                itemBuilder: (BuildContext ctxt,
                                                    int index) {
                                                  return Column(
                                                    children: <Widget>[
                                                      ReporterCard(incidentList[index])
                                                      // DonorCard(donorList[index],
                                                      //     incidentList)
                                                    ],
                                                  );
                                                })),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
      ////  ),
      ),
    ));
  }

  // void goToIncidentAddPage(BuildContext context) {
  //    Navigator.push(
  //     context, SlideLeftRoute(page: IncidentAddScreen()));
  // }

  Future<Null> _showLogoutDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Text(
                          "Do you want to logout?",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 5, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: logout,
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future logout() async {
    Navigator.of(context).pop();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    localStorage.remove('user');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //   title: new Text('Are you sure?'),
            content: new Text('Do you want to exit this App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}
