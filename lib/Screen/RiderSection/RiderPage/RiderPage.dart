import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/Profile/ProfileEditForm.dart';
import 'package:design_app/Screen/RiderSection/RiderCard/RiderCard.dart';
import 'package:design_app/Screen/RiderSection/RiderNotification/RiderNotificationPage.dart';
import 'package:design_app/Screen/login.dart';
import 'package:design_app/main.dart';
import 'package:design_app/model/DonationsForRiderModel/DonationsForRiderModel.dart';
import 'package:design_app/model/StatusFilterModel/StatusFilterModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderPage extends StatefulWidget {
  @override
  _RiderPageState createState() => _RiderPageState();
}

class _RiderPageState extends State<RiderPage> {
  TextEditingController msgController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  var pickBody, pickingList;
  var incidentMsg = "";
  final List<Map<String, String>> listOfColumns = [
    {
      "Name": "AAAAAA",
      "Number": "1",
      "State": "Yes",
    },
    {
      "Name": "BBBBBB",
      "Number": "2",
      "State": "no",
    },
    {
      "Name": "CCCCCC",
      "Number": "3",
      "State": "Yes",
    },
  ];

  List data = [
    {
      "Name": "AAAAAA",
      "Number": "1",
      "State": "Yes",
    },
    {
      "Name": "BBBBBB",
      "Number": "2",
      "State": "no",
    },
    {
      "Name": "CCCCCC",
      "Number": "3",
      "State": "Yes",
    },
  ];

  var userData;
  var _showImage;
  var selectedStatus = '';
  var value;

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
      _getUserInfo();
      loggedinInfo();
      getDonationList();
      _myLocation();
    });
    _fireBaseNotification();
    notifyCount();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    super.initState();
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
    Navigator.push(context, SlideLeftRoute(page: RiderNotificationPage()));
  }

  void pageLaunch(Map<String, dynamic> msg) {
    print("onLaunch: $msg");
    pageRedirect();
  }

  void pageRedirect() {
    if (index != 1 && index != 2) {
      Navigator.push(context, SlideLeftRoute(page: RiderNotificationPage()));
      setState(() {
        index = 2;
      });
    }
  }

  ///// end handle looping onlaunch firebase //////

  // Future<void> allData() async{
  //   getDonationList();
  //   notifyCount();
  // }

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
      setState(() {
        userData = userinfoList;
      });
    }
    _showImage = userData != null && userData['image'] != null
        ? '${userData['image']}'
        : '';
    print(_showImage);
  }

  void loggedinInfo() async {
    loggedData = 'Rider';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('loggedIn', loggedData);
    print('loggedData');
    print(loggedData);
  }

  Future<void> getDonationList() async {
    var res;
    if (selectedStatus == '') {
      res = await CallApi().getData('/app/showDonationforRider?date=$date');
    } else {
      res = await CallApi().getData(
          '/app/showDonationforRider?date=$date&status=$selectedStatus');
    }
    pickBody = json.decode(res.body);
    print(pickBody);

    if (res.statusCode == 200) {
      var pickcontent = res.body;
      final pick = json.decode(pickcontent);

      var pickdata = DonationsForRiderModel.fromJson(pick);
      pickingList = pickdata.donationforRider;

      if (pickingList != null) {
        setState(() {
          //  String dd = incidentList.created_at;
          //  var spDate = dd.split(" ");
          //  alertDate = spDate[0];
          // situation = incidentList.situation;
          print('pickingList');
          print(pickingList);
        });
        print(pick);
      } else {
        setState(() {
          incidentMsg = "No incident found on this date!";
        });
      }
      setState(() {
        selectedStatus = '';
      });

      // setState(() {
      //   incidentList = incidentdata.incident;
      // });
      // print("incidentList.length");
      // print(incidentList.length);

    }
  }

  void choiceAction(String choice) {
    if (choice == StatusFilterModel.allStatus) {
      selectedStatus = '';
      getDonationList();
      notifyCount();
    }
    if (choice == StatusFilterModel.openStatus) {
      selectedStatus = 'Pending';
      getDonationList();
      notifyCount();
    }
    if (choice == StatusFilterModel.forPickupStatus) {
      selectedStatus = 'Picked';
      getDonationList();
      notifyCount();
    }
    if (choice == StatusFilterModel.takenStatus) {
      selectedStatus = 'Taken';
      getDonationList();
      notifyCount();
    }
  }

  void _myLocation() async {
    // controller = await _controller.future;

    LocationData currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      // print("currentLocation ;lkjg df;gj dgj ldgj lgjl dgjd gj");
      // print(currentLocation);
      // Fluttertoast.showToast(
      //     msg: "$currentLocation",
      //     //toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIos: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } on Exception {
      currentLocation = null;
    }

    setState(() {
      // riderLat = currentLocation.latitude;
      // riderLan = currentLocation.longitude;
      value = {
        "lat": currentLocation.latitude,
        "lan": currentLocation.longitude,
      };
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("yyyy-MM-dd").format(selectedDate)}";
        getDonationList();
        notifyCount();
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
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Container(
              margin: EdgeInsets.only(left: 0, top: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          SlideLeftRoute(page: ProfileEditForm(loggedData)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
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
                      // margin: EdgeInsets.only(right: 8),
                      // height: 30,
                      // width: 30,
                      // decoration: BoxDecoration(
                      //     color: appColor,
                      //     borderRadius: BorderRadius.all(Radius.circular(30)),
                      //     image: DecorationImage(
                      //         image: _showImage == '' || _showImage == null
                      //             ? AssetImage(
                      //                 'assets/image/profile.png',
                      //                 //f: BoxFit.cover,
                      //               )
                      //             : NetworkImage(
                      //                 _showImage,
                      //               ))),
                    ),
                  ),
                  Text(
                    'Rider',
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto-Bold",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // title: Container(
            //   child: Container(
            //     margin: EdgeInsets.only(top: 10),
            //     child: Text(
            //       'Rider',
            //       style: TextStyle(
            //           color: appColor,
            //           fontFamily: "Roboto-Bold",
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.grey,
                    size: 25,
                  ),
                  onPressed: () {
                    // print(CallApi().url());
                    _showLogoutDialog();
                  },
                ),
              ),
            ]

            // actions: <Widget>[
            //    Container(
            //       margin: EdgeInsets.only(right: 20, top: 10),
            //       decoration:
            //           BoxDecoration(color: appColor, shape: BoxShape.circle),
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.add,
            //           color: Colors.white,
            //           size: 25,
            //         ),
            //         onPressed: () {
            //           Navigator.push(
            //               context, SlideLeftRoute(page: PickUpView()));
            //         },
            //       ),
            //     )
            // ],

            ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                                              page: RiderNotificationPage()));
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 12, top: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                //color: Colors.white,
                                border: Border.all(width: 1, color: appColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    date.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xFF8A8A8A),
                                        fontFamily: "Roboto-Regular",
                                        fontSize: 16,
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
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, right: 10),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: appColor,
                              border: Border.all(width: 1, color: appColor)),
                          // child: IconButton(
                          //   onPressed: () {
                          //     // setState(() {
                          //     //   _selectDate(context);
                          //     //   //_showDate();
                          //     // });
                          //   },
                          //   icon: Icon(
                          //     Icons.filter_list,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          child: PopupMenuButton<String>(
                            onSelected: choiceAction,
                            icon: Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            itemBuilder: (BuildContext context) {
                              return StatusFilterModel.choices
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 25),
                    child: Text(
                      'Picking List',
                      style: TextStyle(
                          color: appColor,
                          fontFamily: "Roboto-Bold",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  pickingList == null
                      ? CircularProgressIndicator()
                      : pickingList.length == 0
                          ? Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 300,
                                  child: Text("No donation found !!")))
                          : Container(
                              // height: 150,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, bottom: 30),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: pickingList.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Column(
                                      children: <Widget>[
                                        RiderCard(pickingList[index], value)
                                      ],
                                    );
                                  })),

                  // Container(
                  //   margin: EdgeInsets.only(left: 5, right: 5, bottom: 30),
                  //   child: Column(
                  //     children: <Widget>[
                  //       RiderCard(),
                  //       RiderCard(),
                  //       RiderCard(),
                  //       RiderCard(),
                  //       RiderCard(),
                  //       RiderCard(),
                  //       RiderCard(),
                  //       RiderCard(),
                  //     ],
                  //   ),
                  // ),

//                 Container(
//                   height: MediaQuery.of(context).size.height,
//                   child: ListView(
//   children: const <Widget>[

//     Card(
//       child: ListTile(
//         leading: FlutterLogo(size: 72.0),
//         title: Text('Three-line ListTile'),
//         subtitle: Text(
//           'A sufficiently long subtitle warrants three lines.'
//         ),
//         trailing: Icon(Icons.more_vert),
//         isThreeLine: true,
//       ),
//     ),
//   ],
// ),
//                 ),

                  // Container(
                  //   margin: EdgeInsets.only(left: 20, right: 20),
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       top: BorderSide(width: 1, color: appColor),
                  //       left: BorderSide(width: 1, color: appColor),
                  //       right: BorderSide(width: 1, color: appColor),
                  //     ),
                  //   ),
                  //   child: Theme(
                  //     data: Theme.of(context).copyWith(
                  //       dividerColor: appColor,
                  //     ),
                  //     child: Container(
                  //       child: DataTable(
                  //         columnSpacing: 20,
                  //         horizontalMargin: 5,
                  //         columns: [
                  //           DataColumn(
                  //             label: Container(
                  //               //  margin: EdgeInsets.only(top: 25, bottom: 25),
                  //               child: Text(
                  //                 'Alert',
                  //                 style: TextStyle(
                  //                     color: Color(0xFFEC4647),
                  //                     fontFamily: "Roboto-Regular",
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.normal),
                  //               ),
                  //             ),
                  //           ),
                  //           DataColumn(
                  //               label: Container(
                  //             //  margin: EdgeInsets.only(top: 25, bottom: 25),
                  //             child: Text(
                  //               'Situations',
                  //               style: TextStyle(
                  //                   color: Color(0xFFEC4647),
                  //                   fontFamily: "Roboto-Regular",
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.normal),
                  //             ),
                  //           )),
                  //           DataColumn(
                  //               label: Container(
                  //             //  margin: EdgeInsets.only(top: 25, bottom: 25),
                  //             child: Text(
                  //               'Status',
                  //               style: TextStyle(
                  //                   color: Color(0xFFEC4647),
                  //                   fontFamily: "Roboto-Regular",
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.normal),
                  //             ),
                  //           )),
                  //           DataColumn(label: Text('')),
                  //           DataColumn(label: Text('')),
                  //         ],
                  //         rows:
                  //             listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                  //                 .map(
                  //                   ((element) => DataRow(
                  //                         cells: <DataCell>[
                  //                           DataCell(Text(
                  //                             element["Name"],
                  //                             textAlign: TextAlign.center,
                  //                           )), //Extracting from Map element the value
                  //                           DataCell(Text(element["Number"],
                  //                               textAlign: TextAlign.center)),
                  //                           DataCell(Text(element["State"],
                  //                               textAlign: TextAlign.center)),
                  //                           DataCell(
                  //                             Container(
                  //                               //  padding: EdgeInsets.only(left: 15, right: 15),
                  //                               // color: appColor,
                  //                               child: IconButton(
                  //                                 onPressed: () {},
                  //                                 icon: Icon(
                  //                                   Icons.add,
                  //                                   color: appColor,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           DataCell(
                  //                             Container(
                  //                               //  padding: EdgeInsets.only(left: 15, right: 15),
                  //                               //  color: appColor,
                  //                               child: IconButton(
                  //                                 onPressed: () {},
                  //                                 icon: Icon(
                  //                                   Icons.visibility,
                  //                                   color: appColor,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           )
                  //                         ],
                  //                       )),
                  //                 )
                  //                 .toList(),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //     Table(
                  //       border: TableBorder.all(width: 1.0),
                  //     children: data.map((item) {
                  //   return TableRow(
                  //       children: data.map((row) {
                  //     return Container(
                  //       color:
                  //          Colors.green,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Text(
                  //           row['Name'].toString(),
                  //           style: TextStyle(fontSize: 20.0),
                  //         ),
                  //       ),
                  //     );
                  //   }).toList());
                  // }).toList(),
                  //     )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
}
