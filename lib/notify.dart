// import 'dart:convert';
// import 'dart:io';

// import 'package:bahrain_unique_deliver/Api/registerApi.dart';
// import 'package:bahrain_unique_deliver/Forms/LoginForm/logInPage.dart';
// import 'package:bahrain_unique_deliver/Model/OrderSort/orderSort.dart';
// import 'package:bahrain_unique_deliver/Model/OrderStatusModel/OrderStatusModel.dart';
// import 'package:bahrain_unique_deliver/Model/StatusSearchModel/StatusSearchModel.dart';
// import 'package:bahrain_unique_deliver/NavigationAnimation/RouteTransition/routeAnimation.dart';
// import 'package:bahrain_unique_deliver/Screens/NotificationPage/NotificationPage.dart';
// import 'package:bahrain_unique_deliver/Screens/Orders/OrderPage/ordersPage.dart';
// import 'package:bahrain_unique_deliver/main.dart';
// import 'package:bahrain_unique_deliver/redux/action.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomePage extends StatefulWidget {
//   // final statusF, date1, date2;
//   // HomePage(this.statusF, this.date1, this.date2);
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController searchController = TextEditingController();
//   var unseenNotific = 0;

//   var userToken;
//   bool isRefresh = false;

//   bool _isLoading = true;
//   var orderDetail;
//   var body, bodySearch;
//   var searchDetail, searchDetail2;
//   String totalCost = '';
//   String totalNumber = '';
//   bool _isSearching = false;

//   String statusSelect2 = '';
//   String dateFr = '';
//   String dateTo = '';

//   var bodyStatus;
//   List<String> status = [];
//   List<String> statusForDate = [];
//   // String _currentStatusSelected = '';
//   var isStatus = true;

//   DateTime selectedDateFrom = DateTime.now();
//   DateTime selectedDateTo = DateTime.now();

//   var _seqName = "Block";
//   var _seqType = "";
//   var _sendType = 'asc';
//  bool _notificLoading = true;
//   bool _fromTop = true;
//   var appToken;

//    int notificCount = 0;
// var body1;
//   int showNumber=0;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   var _type = ['A to Z', 'Z to A'];
//   var _currentTypeSelected = 'A to Z';
//   void _typeDropDownSelected(String newValueSelected) {
//     setState(() {
//       this._currentTypeSelected = newValueSelected;
//       if (newValueSelected == 'A to Z') {
//         _sendType = 'asc';
//         _seqType = 'asc';
//       } else {
//         _sendType = 'desc';
//         _seqType = 'desc';
//       }
//     });

//     Navigator.pop(context);
//     selection(3);
//   }

//   @override
//   void initState() {
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//       //  setState(() {


//           // store.dispatch(UnseenNotificationAction(store.state.unseenState + 1));
//           // unseenNotific = store.state.unseenState;
//           // print(store.state.unseenState);
//       //  });
//        notifyCount();
//         _showNotificationPop(
//             message['notification']['title'], message['notification']['body']);
//         // Navigator.push(context, SlideLeftRoute(page: NotificationPage()));
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         pageLaunch(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         pageDirect(message);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print("Settings registered: $settings");
//     });

//     _showOrderStatus();
//     _showOrderDetails();
//    // showNotifyListCount();
   
//     super.initState();
//   }

//     showNotifyListCount() async {
//       var data = {};
//     var res =
//         await CallApi().postData(data,'/app/allnotificationUpdate');

//     body1 = json.decode(res.body);

//     print(body1);

//     if (res.statusCode == 200) {
//       setState(() {
//         print("done");
//       });
//     }
//   }

//    Future<void> notifyCount() async {
//     var res = await CallApi().getData('/app/countUnseenNotification');
//     body = json.decode(res.body);

//     if (res.statusCode == 200) {
//       _orderState();
//     }
//   }

//     void _orderState() {
//     if (!mounted) return;
//     setState(() {
//        notificCount = body["total"];
//        store.dispatch(UnseenNotificationAction(notificCount));
//          print("unseen");
//        print(store.state.unseenState);
     
//          print("seen");
//        print(store.state.seenState);
//          showNumber = store.state.unseenState - store.state.seenState;
//        print("show numberrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
//        print(showNumber);
//       _notificLoading = false;
//     });
//     print("count");
//     print(notificCount);
//   }

//   ///// handle looping onlaunch firebase //////
//   void pageDirect(Map<String, dynamic> msg) {
//     print("onResume: $msg");
//     setState(() {
//       index = 1;
//     });
//      Navigator.push(context, SlideLeftRoute(page: NotificationPage()));
//   }

//   void pageLaunch(Map<String, dynamic> msg) {
//     print("onLaunch: $msg");
//     pageRedirect();
//   }

//   void pageRedirect() {
//     if (index != 1 && index != 2) {
//        Navigator.push(context, SlideLeftRoute(page: NotificationPage()));
//       setState(() {
//         index = 2;
//       });
//     }
//   }

//   ///// end handle looping onlaunch firebase //////

//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   _showMsg(msg) {
//     final snackBar = SnackBar(
//       content: Text(msg),
//       action: SnackBarAction(
//         label: 'Close',
//         onPressed: () {
//           // Some code to undo the change!
//         },
//       ),
//     );
//     //Scaffold.of(context).showSnackBar(snackBar);
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => new AlertDialog(
//             //   title: new Text('Are you sure?'),
//             content: new Text('Do you want to exit this App'),
//             actions: <Widget>[
//               new FlatButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: new Text(
//                   'No',
//                   style: TextStyle(color: appTealColor),
//                 ),
//               ),
//               new FlatButton(
//                 onPressed: () => exit(0),
//                 child: new Text(
//                   'Yes',
//                   style: TextStyle(color: appTealColor),
//                 ),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }

//   //////////////////////////////////// get status data start /////////////////
//   Future _getLocalOrderStatusData(key) async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var localorderStatusData = localStorage.getString(key);
//     if (localorderStatusData != null) {
//       bodyStatus = json.decode(localorderStatusData);
//     }
//   }

//   void _orderStatusState() {
//     var orderStatus = OrderStatusModel.fromJson(bodyStatus);
//     // print("orderStatus");
//     // print(orderStatus);
//     if (!mounted) return;
//     setState(() {
//       var statuses = orderStatus.status;
//       // print("statuses");
//       // print(statuses.length);
//       for (int i = 0; i < statuses.length; i++) {
//         status.add("${statuses[i].name}");
//       }
//       isStatus = false;
//     });

//     // print("status isssss");
//     // print(status.length);
//     // print(status);
//   }

//   Future<void> _showOrderStatus() async {
//     var key = 'order-status-list-sort';
//     await _getLocalOrderStatusData(key);

//     var res = await CallApi().getData('/app/showStatus');
//     // print(res);
//     bodyStatus = json.decode(res.body);
//     // print("bodyStatus");
//     // print(bodyStatus);
//     if (res.statusCode == 200) {
//       _orderStatusState();

//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.setString(key, json.encode(bodyStatus));
//     }
//   }
//   ////////////////////////////////// get status data end /////////////////

//   /////////// Refresh Method Start //////////////
//   Future<void> _allData() async {
//     print('searchDetail.length');
//     print(isRefresh);
//     if (isRefresh == true) {
//       setState(() {
//         _showSearchStatus();
//       });
//     } else {
//       _showOrderDetails();
//     }

//      notifyCount();
//   }
//   /////////// Refresh Method End //////////////

//   void choiceAction(String choice) {
//     if (choice == OrderSort.statusSort) {
//       selection(1);
//     }
//     if (choice == OrderSort.statusDateSort) {
//       selection(2);
//     }
//     if (choice == OrderSort.blockSort) {
//       selection(3);
//     }
//   }

//   userInfo() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     userToken = localStorage.getString('token');
//     // searchDetail2 = localStorage.getString('status-search-list');
//     print(userToken);
//   }

//   //////////////////////////// get order data start ////////////////////////
//   Future _getLocalOrderDetailsData(key) async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var localorderDetailsData = localStorage.getString(key);
//     if (localorderDetailsData != null) {
//       body = json.decode(localorderDetailsData);
//     }
//   }

//   void _orderDetailsState() {
//     var orderDetails = StatusSearchModel.fromJson(body);
//     if (!mounted) return;
//     setState(() {
//       orderDetail = orderDetails.allTripOfMyStatus;
//       // print('orderDetail');
//       // print(orderDetail);
//       _isLoading = false;
//     });
//   }

//   Future<void> _showOrderDetails() async {
//     var key = 'order-details-list';
//     await _getLocalOrderDetailsData(key);

//     var res;
//     _seqName != "" && _seqType != ""
//         ? res = await CallApi().getData1(
//             '/app/allTripOfMyStatus?status=$statusSelect2&order=$_seqName,$_seqType')
//         : res = await CallApi().getData('/app/allTripOfMyStatus');

//     // var res = await CallApi().getData('/app/allTripOfMyStatus');
//     print('response');
//     print(res);
//     body = json.decode(res.body);
//     // print('body');
//     // print(body);
//     if (res.statusCode == 200) {
//       _orderDetailsState();
//       _isSearching = false;
//       // _showOrderStatus();

//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.setString(key, json.encode(body));
//       // print('orderDetail');
//       // print(orderDetail);
//     }
//   }
//   ////////////////////////////// get order data end ///////////////////////////

//   ////////////////////////////// search status start ////////////////////////
//   Future _getLocalSearchStatusData(key) async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var localsearchStatusData = localStorage.getString(key);
//     if (localsearchStatusData != null) {
//       bodySearch = json.decode(localsearchStatusData);
//       //_orderSearchStatusState();
//     }
//   }

//   void _orderSearchStatusState() {
//     var searchDetails = StatusSearchModel.fromJson(bodySearch);
//     // print('searchDetails');
//     // print(searchDetails);
//     if (!mounted) return;
//     setState(() {
//       searchDetail = searchDetails.allTripOfMyStatus;
//       _isLoading = false;
//       // statusSelect2 = '';
//       // dateFr = '';
//       // dateTo = '';

//       totalCost = searchDetails.totalGrandTotal.toString();
//       totalNumber = searchDetails.total.toString();
//       print('total amount');
//       print(searchDetails.totalGrandTotal.toString());
//       print('total');
//       print(searchDetails.total.toString());
//       print('statusSelect');
//       print(statusSelect2);
//       print('dateFr');
//       print(dateFr);
//       // print(statusSelect);
//     });
//   }

//   Future<void> _showSearchStatus() async {
//     var key = 'status-search-list';
//     await _getLocalSearchStatusData(key);

//     var res;
//     dateTo == '' && statusSelect2 != ''
//         ? res = await CallApi()
//             .getData1('/app/allTripOfMyStatus?status=$statusSelect2')
//         : res = await CallApi().getData1(
//             '/app/allTripOfMyStatus?status=$statusSelect2&from=$dateFr&to=$dateTo');
//     // var res = await CallApi().getData1('/app/allTripOfMyStatus?status=${searchController.text}');
//     // print('responseSearch');
//     // print(res);
//     bodySearch = json.decode(res.body);
//     // print('bodySearch');
//     // print(bodySearch);
//     // print('statusSelect2');
//     // print(statusSelect2);
//     if (res.statusCode == 200) {
//       _orderSearchStatusState();
//       _isSearching = true;
//       isSearching2 = false;
//       // statusSelect2 = '';///////////////////////////////////////////////////
//       dateFr = '';
//       dateTo = '';
//       //_currentStatusSelected = '';
//       selectedDateFrom = DateTime.now();
//       selectedDateTo = DateTime.now();

//       //_showOrderStatus();

//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.setString(key, json.encode(bodySearch));
//       // print('searchDetail');
//       // print(searchDetail.length);
//     }
//   }
//   ///////////////////////////////// search status end //////////////////////////

//   ////////////////////////  Log Out Calling  Start  //////////////////////
//   void _logout() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     localStorage.remove('user');
//     localStorage.remove('token');

//     Navigator.push(
//         context, new MaterialPageRoute(builder: (context) => LogInPage()));
//   }
//   ///////////////////////////  Log Out Calling End /////////////////////////

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: appTealColor,
//           automaticallyImplyLeading: false,
//           actions: <Widget>[
//             Container(
         
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   //////////////////////  Notification start //////////////////
//                   Container(
                 
                  
//                     child: GestureDetector(
//                       onTap: () {
//                         // Navigator.push(
//                         //     context,
//                         //     SlideLeftRoute(
//                         //         page: NotificationPage()));
//                       },
//                       child: Stack(
                        
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: (){
//                                 Navigator.push(context, SlideLeftRoute(page: NotificationPage()));
//                             },
//                             child: Container(
//                                margin: EdgeInsets.only(top: 5),
//                               child: Icon(
//                                 Icons.notifications,
//                                 //size: 32,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left:13),
//                            // padding: EdgeInsets.only(bottom:10),
//                             decoration: BoxDecoration(
//                                 color: showNumber == 0 ||
//                                         showNumber == null
//                                     ? Colors.transparent
//                                     : Colors.red[900],
//                                 shape: BoxShape.circle),
//                             child: Padding(
//                               padding: showNumber < 9
//                                   ? EdgeInsets.all(5.0)
//                                   : EdgeInsets.all(2.0),
//                               child: Text(
//                                 showNumber == 0
//                                     ? ""
//                                     : showNumber > 9
//                                         ? "9+"
//                                         : '$showNumber',
//                                 style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   //////////////////////  Notification end /////////////////////
//                   ///////////////////////  filter start /////////////////////
//                   // Container(
//                   //   height: 45.0,
//                   //   padding: EdgeInsets.only(bottom: 5),
//                   //   child: GestureDetector(
//                   //     onTap: () {
//                   //       _filterPage();
//                   //       // Navigator.push(
//                   //       //     context, SlideLeftRoute(page: FilterDialog()));
//                   //     },
//                   //     child: Container(
//                   //       padding:
//                   //           EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
//                   //       decoration:
//                   //           BoxDecoration(borderRadius: BorderRadius.circular(6)),
//                   //       child: Row(
//                   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //         children: <Widget>[
//                   //           Icon(Icons.filter_list, color: Colors.white)
//                   //         ],
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   //////////////////////  filter end /////////////////////

//                   /////////////////  Log Out Button Start /////////////////
//                   SizedBox(
//                     width: 10,
//                   ),
//                   GestureDetector(
//                       onTap: () {
//                         _showDialog(context);
//                         // _logout();
//                       },
//                       child: Container(
//                           margin: EdgeInsets.only(top: 5),
//                         child: Icon(
//                           Icons.exit_to_app,
//                         ),
//                       )),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   ///////////////////  Log Out Button End /////////////////
//                 ],
//               ),
//             ),
//           ],
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(110.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                     alignment: Alignment.topLeft,
//                     padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
//                     child: Text('Orders',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 26,
//                             fontFamily: 'Roboto',
//                             fontWeight: FontWeight.bold))),

//                 ////////////////////  Popup menu button start //////////////////
//                 Container(
//                   height: 45.0,
//                   //color: Colors.red,
//                   padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
//                   child: PopupMenuButton<String>(
//                     onSelected: choiceAction,
//                     icon: Icon(
//                       Icons.more_vert,
//                       color: Colors.white,
//                     ),
//                     itemBuilder: (BuildContext context) {
//                       return OrderSort.choices.map((String choice) {
//                         return PopupMenuItem<String>(
//                           value: choice,
//                           child: Text(choice),
//                         );
//                       }).toList();
//                     },
//                   ),
//                 )
//                 ////////////////////  Popup menu button end /////////////////////
//               ],
//             ),
//           ),
//         ),
//         body: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Container(
//                 decoration: BoxDecoration(
//                   color: appTealColor,
//                 ),
//                 child: Container(
//                   padding:
//                       EdgeInsets.only(top: 15, bottom: 8.0, left: 2, right: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(25.0),
//                         topRight: Radius.circular(25.0)),
//                   ),
//                   child: !_isSearching && orderDetail.length == 0
//                       ? Center(
//                           child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                                 width: 100,
//                                 height: 110,
//                                 decoration: new BoxDecoration(
//                                     shape: BoxShape.rectangle,
//                                     image: new DecorationImage(
//                                       fit: BoxFit.fill,
//                                       image: new AssetImage(
//                                           'assets/img/empty_box.png'),
//                                     ))),
//                             Text(
//                               "You have no assigned order",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: appTealColor,
//                                   fontFamily: "sourcesanspro",
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                               SizedBox(height:10),
//                               GestureDetector(
//                                 onTap: (){
//                                   _allData();
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.only(left:12, right:12, top:6, bottom:6),
//                                   color: appTealColor,
//                                   child: Text(
//                                   "Retry",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontFamily: "sourcesanspro",
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold),
//                             ),
//                                 ),
//                               ),



//                           ],
//                         ))
//                       // SingleChildScrollView(
//                       //     physics: AlwaysScrollableScrollPhysics(),
//                       //     child: Container(
//                       //         height: MediaQuery.of(context).size.height,
//                       //         alignment: Alignment.topCenter,
//                       //         padding: EdgeInsets.only(top: 50),
//                       //         child: Text(
//                       //           'No Order Assigned !!',
//                       //           style: TextStyle(fontSize: 16),
//                       //         )),
//                       //   )
//                       : _isSearching && searchDetail.length == 0
//                           ? Center(
//                               child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                     width: 100,
//                                     height: 110,
//                                     decoration: new BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         image: new DecorationImage(
//                                           fit: BoxFit.fill,
//                                           image: new AssetImage(
//                                               'assets/img/empty_box.png'),
//                                         ))),
//                                 Text(
//                                   "No \" $statusSelect2 \" Order Found",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                       color: appTealColor,
//                                       fontFamily: "sourcesanspro",
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ))
//                           // SingleChildScrollView(
//                           //         physics: AlwaysScrollableScrollPhysics(),
//                           //         child: Container(
//                           //             height: MediaQuery.of(context).size.height,
//                           //             alignment: Alignment.topCenter,
//                           //             padding: EdgeInsets.only(top: 50),
//                           //             child: Text(
//                           //               'No Order Found !!',
//                           //               style: TextStyle(fontSize: 16),
//                           //             )),
//                           //       )
//                           : RefreshIndicator(
//                               onRefresh: _allData,
//                               child: SingleChildScrollView(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: _isSearching
//                                           ? _showSearchOrdersList()
//                                           : _showOrdersList()),
//                                 ),
//                               ),
//                             ),
//                   // Container(
//                   //     height: MediaQuery.of(context).size.height,
//                   //     child: ListView.builder(
//                   //       physics: AlwaysScrollableScrollPhysics(),
//                   //       scrollDirection: Axis.vertical,
//                   //       itemBuilder:
//                   //           (BuildContext context, int index) =>
//                   //               Container(
//                   //         margin: EdgeInsets.only(
//                   //             bottom: 5, top: 0, left: 3),
//                   //         decoration: BoxDecoration(
//                   //           color: Colors.white,
//                   //           borderRadius: BorderRadius.only(
//                   //               bottomLeft: Radius.circular(10),
//                   //               bottomRight: Radius.circular(10)),
//                   //         ),
//                   //         child: OrdersPage(
//                   //             // _isSearching
//                   //             //       ? searchDetail[index]
//                   //             //       :
//                   //             searchDetail[index]
//                   //             //: orderDetail[index],
//                   //             ),
//                   //       ),
//                   //       itemCount:
//                   //           // _isSearching
//                   //           //     ? searchDetail.length
//                   //           //     :
//                   //           searchDetail.length,
//                   //     )),
//                   // ),
//                 ),
//               ),
//         bottomNavigationBar: (_isSearching == true && totalNumber != '0')
//             ? Container(child: totalDeliveryInfo())
//             : Container(
//                 height: 0,
//               ),
//       ),
//     );
//   }

//   List<Widget> _showOrdersList() {
//     List<Widget> list = [];

//     for (var d in orderDetail) {
//       //   print(d.status);

//       list.add(OrdersPage(d));
//     }

//     return list;
//   }

//   List<Widget> _showSearchOrdersList() {
//     List<Widget> list = [];

//     for (var d in searchDetail) {
//       //   print(d.status);

//       list.add(OrdersPage(d));
//     }

//     return list;
//   }

//   ///////////////// Total Amount Card Start  ///////////////////////
//   Card totalDeliveryInfo() {
//     return Card(
//       margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
//       //color: Colors.blue,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(5))),
//       child: Container(
//         //margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
//         padding: EdgeInsets.only(top: 10, left: 10),
//         height: 70,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: appTealColor),
//             borderRadius: BorderRadius.all(Radius.circular(5))),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   "Total $statusSelect2 :  ",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'Roboto',
//                       color: appTealColor,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                   child: Text(
//                     totalNumber == null ? '' : totalNumber,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'Roboto',
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   "Amount :  ",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'Roboto',
//                       color: appTealColor,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                   child: Text(
//                     totalCost == null
//                         ? ''
//                         : totalCost+" BHD", //totalCost == null ? "0.00 BHD" : '$totalCost BHD',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'Roboto',
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   ///////////////// Total Amount Card End  ///////////////////////

//   ////////////////////////  Route to Filter Page  //////////////////
//   // void _filterPage() {
//   //   Navigator.of(context).push(new MaterialPageRoute<Null>(
//   //       builder: (BuildContext context) {
//   //         return new FilterDialog();
//   //       },
//   //       fullscreenDialog: true));
//   // }

//   ////////////////////////   Log Out Dialog Start   //////////////////
//   void _showDialog(context) {
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return alert dialog object
//         return AlertDialog(
//           title: new Text(
//             'Do you want to log out ?',
//             style: TextStyle(color: appTealColor),
//           ),
//           content:
//               // actions: <Widget>[
//               // usually buttons at the bottom of the dialog
//               Container(
//             padding: EdgeInsets.only(top: 10, left: 15, right: 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 new OutlineButton(
//                   borderSide: BorderSide(
//                       color: appTealColor, style: BorderStyle.solid, width: 2),
//                   shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(50.0)),
//                   child: new Text(
//                     "No",
//                     style: TextStyle(color: appTealColor),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 new FlatButton(
//                   color: appTealColor,
//                   // borderSide: BorderSide(
//                   //     color: appTealColor, style: BorderStyle.solid, width: 2),
//                   shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(50.0)),
//                   child: new Text(
//                     "Yes",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     _logout();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           //],
//         );
//       },
//     );
//   }
//   ////////////////////////   Log Out Dialog End   //////////////////

//   void selection(int num) {
//     num == 1
//         ? showDialog(
//             ////////////////////////   Filter By Status Dialog   /////////////////////
//             context: context,
//             builder: (BuildContext context) {
//               // return object of type Dialog
//               return AlertDialog(
//                   //contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                   title: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                             padding: EdgeInsets.only(top: 5, bottom: 12),
//                             child: new Text("Select Status")),
//                         Divider(
//                           height: 0,
//                           color: Colors.grey[400],
//                         ),
//                       ],
//                     ),
//                   ),
//                   content: Container(
//                     width: MediaQuery.of(context).size.width * 0.9,
//                     height: MediaQuery.of(context).size.height * 0.9,
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                             // height: 450,
//                             //padding: EdgeInsets.only(left: 5),
//                             child: _isLoading
//                                 ? Center(child: CircularProgressIndicator())
//                                 : ListView.builder(
//                                     physics: BouncingScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemCount: status.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       return ListTile(
//                                         contentPadding: EdgeInsets.symmetric(
//                                             vertical: 0, horizontal: 0),
//                                         onTap: () {
//                                           setState(() {
//                                             statusSelect2 = status[index];
//                                             isRefresh = true;
//                                             print('isRefresh');
//                                             print(isRefresh);
//                                             print(statusSelect2);
//                                             _showSearchStatus();
//                                             Navigator.of(context).pop();
//                                             // selection(2);
//                                           });
//                                         },
//                                         leading: Container(
//                                             child: Text(
//                                           status[index],
//                                           overflow: TextOverflow.ellipsis,
//                                         )),
//                                       );
//                                     },
//                                   )),
//                       ],
//                     ),
//                   ));
//             },
//           )
//         : num == 2
//             ? showDialog(
//                 /////////////////////////////   Filter By Status Date Dialog    /////////////////////////
//                 context: context,
//                 builder: (BuildContext context) {
//                   // return object of type Dialog
//                   return AlertDialog(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                             alignment: Alignment.center,
//                             child: new Text("Status Date")),
//                         Divider(
//                           color: Colors.grey[400],
//                         ),
//                         selectStatusWidgetcolumn(),
//                         dateFromField("Date From", '$dateFr'),
//                         dateToField("To", '$dateTo'),
//                       ],
//                     ),
//                     actions: <Widget>[
//                       // usually buttons at the bottom of the dialog
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           new OutlineButton(
//                             borderSide: BorderSide(
//                                 color: appTealColor,
//                                 style: BorderStyle.solid,
//                                 width: 1),
//                             shape: new RoundedRectangleBorder(
//                                 borderRadius: new BorderRadius.circular(50.0)),
//                             child: new Text(
//                               "Ok",
//                               style: TextStyle(color: appTealColor),
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 if (statusSelect2 == '') {
//                                   _showMsg("Select a status first");
//                                 } else if (dateTo == '' || dateFr == '') {
//                                   _showMsg("Select date");
//                                 } else {
//                                   isRefresh = true;
//                                   print('isRefresh');
//                                   print(isRefresh);
//                                   // isSearching2 = true;
//                                   _showSearchStatus();
//                                   // _isSearching = true;
//                                   Navigator.of(context).pop();
//                                 }
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               )
//             : showDialog(
//                 /////////////////////////////   Sort By Block Dialog    /////////////////////////
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                     contentPadding: EdgeInsets.all(5),
//                     title: Column(
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             ////////////   Address  start ///////////

//                             Container(
//                                 alignment: Alignment.center,
//                                 child: new Text(
//                                   "Sort by Block",
//                                   style: TextStyle(color: Colors.grey[600]),
//                                 )),
//                             Divider(
//                               color: Colors.grey[400],
//                             ),
//                             ///////////// Address   ////////////

//                             // Container(
//                             //     alignment: Alignment.topLeft,
//                             //     margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
//                             //     child: Text("Sort by",
//                             //         textAlign: TextAlign.left,
//                             //         style: TextStyle(color: appTealColor, fontSize: 13))),

//                             ////////////   Address Dropdown ///////////

//                             // Container(
//                             //   padding: EdgeInsets.only(
//                             //     left: 15,
//                             //     right: 15,
//                             //   ),
//                             //   margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
//                             //   decoration: BoxDecoration(
//                             //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                             //       color: Colors.grey[100],
//                             //       border: Border.all(width: 0.2, color: Colors.grey)),
//                             //   alignment: Alignment.center,
//                             //   child: Column(
//                             //     crossAxisAlignment: CrossAxisAlignment.start,
//                             //     children: <Widget>[
//                             //       Container(

//                             //           //color: Colors.red,
//                             //           child: Row(
//                             //         crossAxisAlignment: CrossAxisAlignment.start,
//                             //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //         children: <Widget>[
//                             //           // Expanded(
//                             //           //   child: Container(
//                             //           //     child: DropdownButtonHideUnderline(
//                             //           //       child: DropdownButton<String>(
//                             //           //         icon: Icon(Icons.keyboard_arrow_down,
//                             //           //             size: 25, color: Color(0xFFC5C2C7)),
//                             //           //         items:
//                             //           //             _sort.map((String dropDownStringItem) {
//                             //           //           return DropdownMenuItem<String>(
//                             //           //               value: dropDownStringItem,
//                             //           //               child: Text(
//                             //           //                 dropDownStringItem,
//                             //           //                 textAlign: TextAlign.left,
//                             //           //                 style: TextStyle(
//                             //           //                     color: Colors.grey[600]),
//                             //           //               ));
//                             //           //         }).toList(),
//                             //           //         onChanged: (String newValueSelected) {
//                             //           //           _addressDropDownSelected(newValueSelected);
//                             //           //         },
//                             //           //         value: _currentAddressSelected,
//                             //           //       ),
//                             //           //     ),
//                             //           //   ),
//                             //           // )
//                             //         ],
//                             //       )),
//                             //     ],
//                             //   ),
//                             // ),

//                             ////////////   Address end ///////////
//                           ],
//                         ),
//                         Column(
//                           children: <Widget>[
//                             ////////////   Address  start ///////////

//                             ///////////// Address   ////////////

//                             Container(
//                                 alignment: Alignment.topLeft,
//                                 margin: EdgeInsets.only(
//                                     left: 25, top: 5, bottom: 8),
//                                 child: Text("Sort",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         color: appTealColor, fontSize: 13))),

//                             ////////////   Address Dropdown ///////////

//                             Container(
//                               padding: EdgeInsets.only(
//                                 left: 15,
//                                 right: 15,
//                               ),
//                               margin: EdgeInsets.only(
//                                   bottom: 15, left: 20, right: 20),
//                               decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(5.0)),
//                                   color: Colors.grey[100],
//                                   border: Border.all(
//                                       width: 0.2, color: Colors.grey)),
//                               alignment: Alignment.center,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Container(

//                                       //color: Colors.red,
//                                       child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Container(
//                                           child: DropdownButtonHideUnderline(
//                                             child: DropdownButton<String>(
//                                               icon: Icon(
//                                                   Icons.keyboard_arrow_down,
//                                                   size: 25,
//                                                   color: Color(0xFFC5C2C7)),
//                                               items: _type.map(
//                                                   (String dropDownStringItem) {
//                                                 return DropdownMenuItem<String>(
//                                                     value: dropDownStringItem,
//                                                     child: Text(
//                                                       dropDownStringItem,
//                                                       textAlign: TextAlign.left,
//                                                       style: TextStyle(
//                                                           color:
//                                                               Colors.grey[600]),
//                                                     ));
//                                               }).toList(),
//                                               onChanged:
//                                                   (String newValueSelected) {
//                                                 _typeDropDownSelected(
//                                                     newValueSelected);
//                                               },
//                                               value: _currentTypeSelected,
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   )),
//                                 ],
//                               ),
//                             ),

//                             ////////////   Address end ///////////
//                           ],
//                         ),
//                       ],
//                     ),
//                     content: Container(
//                         height: 70,
//                         width: 250,
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(20.0)),
//                                   ),
//                                   width: 110,
//                                   height: 45,
//                                   margin: EdgeInsets.only(
//                                     top: 25,
//                                     bottom: 15,
//                                   ),
//                                   child: OutlineButton(
//                                     child: new Text(
//                                       "Ok",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     color: Colors.white,
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                       // isRefresh = true;
//                                       // print('isRefresh');
//                                       // print(isRefresh);
//                                       _showOrderDetails();
//                                     },
//                                     borderSide: BorderSide(
//                                         color: Colors.black, width: 0.5),
//                                     shape: new RoundedRectangleBorder(
//                                         borderRadius:
//                                             new BorderRadius.circular(20.0)),
//                                   )),
//                             ])),
//                   );
//                 },
//               );
//   }

//   Column selectStatusWidgetcolumn() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Select a status',
//           textAlign: TextAlign.start,
//           style: TextStyle(
//               color: Colors.black,
//               fontSize: 15,
//               fontFamily: 'Oswald',
//               fontWeight: FontWeight.w400),
//         ),

//         ///////   Dropdown Button For Status Start  ////////
//         Container(
//             margin: EdgeInsets.only(top: 10, bottom: 5),
//             padding:
//                 EdgeInsets.only(right: 12.0, left: 12.0, top: 0, bottom: 0),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 color: Colors.white,
//                 border: Border.all(width: 0.2, color: Colors.grey)),
//             child: DropdownButton<String>(
//               //value: _currentStatusSelected,
//               iconSize: 30,
//               iconEnabledColor: Color(0XFF294F95),
//               iconDisabledColor: Color(0XFF294F95),
//               isExpanded: true,
//               //isDense: true,
//               underline: Container(
//                 height: 0,
//                 color: Colors.white,
//               ),

//               onChanged: (String newValue) {
//                 _onDropdownSelectedStatus(newValue);
//               },
//               items: status.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 );
//               }).toList(),
//               hint: Text(statusSelect2),
//             )),
//         ///////   Dropdown Button For Status End ////////
//       ],
//     );
//   }

//   Container dateFromField(String label, String date) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//               // width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.only(top: 8),
//               child: Text(
//                 label,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontFamily: 'Oswald',
//                     fontWeight: FontWeight.w400),
//               )),
//           GestureDetector(
//             onTap: () {
//               _selectDateFrom(context);
//             },
//             child: Container(
//               //   width: ,
//               padding: EdgeInsets.fromLTRB(5, 12, 5, 12),
//               margin: EdgeInsets.only(top: 13),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   color: Colors.white,
//                   border: Border.all(width: 0.2, color: Colors.grey)),
//               child: new Row(
//                 children: <Widget>[
//                   new Icon(
//                     Icons.date_range,
//                     color: appTealColor,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(left: 5, right: 5),
//                     // decoration: BoxDecoration(
//                     //   border: Border.all(color: appTealColor, width: 2),
//                     // ),
//                     child: new Text(date,
//                         //DateFormat.yMMMd().format(selectedDate),
//                         style: TextStyle(
//                             color: appTealColor,
//                             fontFamily: 'Roboto',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container dateToField(String label2, String date2) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//               // width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.only(top: 8),
//               child: Text(
//                 label2,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontFamily: 'Oswald',
//                     fontWeight: FontWeight.w400),
//               )),
//           GestureDetector(
//             onTap: () {
//               _selectDateTo(context);
//             },
//             child: Container(
//               //   width: ,
//               padding: EdgeInsets.fromLTRB(5, 12, 5, 12),
//               margin: EdgeInsets.only(top: 13),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   color: Colors.white,
//                   border: Border.all(width: 0.2, color: Colors.grey)),
//               child: new Row(
//                 children: <Widget>[
//                   new Icon(
//                     Icons.date_range,
//                     color: appTealColor,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(left: 5, right: 5),
//                     // decoration: BoxDecoration(
//                     //   border: Border.all(color: appTealColor, width: 2),
//                     // ),
//                     child: new Text(date2,
//                         //DateFormat.yMMMd().format(selectedDate),
//                         style: TextStyle(
//                             color: appTealColor,
//                             fontFamily: 'Roboto',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   ////////////////////////   Date Picker Start  //////////////////
//   Future<Null> _selectDateFrom(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDateFrom,
//         firstDate: DateTime(1964, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDateFrom) {
//       setState(() {
//         selectedDateFrom = picked;
//         dateFr = "${DateFormat("yyyy-MM-dd").format(selectedDateFrom)}";
//         Navigator.pop(context);
//         selection(2);
//       });
//     }
//   }
//   ////////////////////////   Date Picker End  //////////////////

//   ////////////////////////   Date Picker Start  //////////////////
//   Future<Null> _selectDateTo(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDateTo,
//         firstDate: DateTime(1964, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDateTo) {
//       setState(() {
//         selectedDateTo = picked;
//         dateTo = "${DateFormat("yyyy-MM-dd").format(selectedDateTo)}";
//         Navigator.pop(context);
//         selection(2);
//       });
//     }
//   }
//   ////////////////////////   Date Picker End  //////////////////

//   void _onDropdownSelectedStatus(String newValue) {
//     setState(() {
//       this.statusSelect2 = newValue;
//       Navigator.pop(context);
//       selection(2);
//     });
//   }

//   void _showNotificationPop(String title, String msg) {
//     showGeneralDialog(
//       barrierLabel: "Label",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: Duration(milliseconds: 700),
//       context: context,
//       pageBuilder: (BuildContext context, anim1, anim2) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop();
//             Navigator.push(context, SlideLeftRoute(page: NotificationPage()));
//           },
//           child: Material(
//             type: MaterialType.transparency,
//             child: Align(
//               alignment:
//                   _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();

//                   // Navigator.push(
//                   //     context, SlideLeftRoute(page: NotificationPage()));
//                 },
//                 child: ListView.builder(
//                   itemCount: 1,
//                   itemBuilder: (context, index) {
//                     //  final item = items[index];

//                     return Dismissible(
//                       key: Key("item"),
//                       onDismissed: (direction) {
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         height: 100,
//                         child: SizedBox.expand(
//                             child: Container(
//                           padding: EdgeInsets.only(left: 15),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               ////////////   Address  start ///////////

//                               ///////////// Address   ////////////

//                               Container(
//                                   alignment: Alignment.topLeft,
//                                   margin: EdgeInsets.only(
//                                       left: 5, top: 2, bottom: 0),
//                                   child: Text(title,
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(
//                                           color: appTealColor,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold))),
//                               Container(
//                                   alignment: Alignment.topLeft,
//                                   margin: EdgeInsets.only(
//                                       left: 5, top: 2, bottom: 8),
//                                   child: Text(msg,
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(
//                                           color: appTealColor,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.normal))),
//                             ],
//                           ),
//                         )),
//                         margin: EdgeInsets.only(
//                             top: 50, left: 12, right: 12, bottom: 50),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position:
//               Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
//                   .animate(anim1),
//           child: child,
//         );
//       },
//     );
//   }
// }
