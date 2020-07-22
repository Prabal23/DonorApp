import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/EmergencyHotlineSection/EmergencyHotlinePage/EmergencyHotlinePage.dart';
import 'package:design_app/Screen/register.dart';
import 'package:design_app/model/SettingsModel/SettingsModel.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'BeneficiarySection/Beneficiary/Beneficiary.dart';
import 'DonorSection/DonorIncidentPage/DonorIncidentPage.dart';
import 'PublicReporterSection/PublicReporter/PublicReporter.dart';
import 'RiderSection/RiderPage/RiderPage.dart';
import 'UpdateQr/AppShare/AppShareButtons.dart';
import 'UpdateQr/UpdateQr.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _value;
  String userType;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  var deviceId;
  var lat;
  var lan;
  bool internet = false;
  var appToken;

  TextEditingController mobileLoginController = new TextEditingController();
  TextEditingController emailLoginController = new TextEditingController();
  TextEditingController passLoginController = new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _getDeviceID();
    internetCheck();
    _firebaseMessaging.getToken().then((token) async {

      print("Notification app token");
      print(token);
        appToken = token;

   });
   // getLocation();
    super.initState();
  }

  // void getLocation() {
  //    var location = new Location();

  //   location.onLocationChanged().listen((LocationData currentLocation) {
  //     setState(() {
  //       lat = currentLocation.latitude;
  //       lan = currentLocation.longitude;
  //     //   _getId().then((id) async {
  //     //     deviceId = id;
  //     //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     //     localStorage.setString('deviceId', deviceId);
  //     //     print('deviceId');
  //     //     print(deviceId);
  //     //   });
  //     });
  //   });
  // }

  // void deviceID() {
  //   setState(() {
  //     _getId().then((id) {
  //       deviceId = id;
  //       print('deviceId login');
  //       print(deviceId);
  //     });
  //   });
  // }

  void _getDeviceID() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // var token = localStorage.getString('token');
    // var user = localStorage.getString('user');
   // deviceId = localStorage.getString('deviceId');
    print('device_id');
    print(deviceId);
    // if (token != null || user != null) {
    //   var userinfoList = json.decode(user);
    //   //deviceId = userinfoList['device_id'];
    //   print('userinfoList');
    //   print(userinfoList);
    // }
    deviceID();
  }

  void deviceID() {
    setState(() {
      _getId().then((id) {
        deviceId = id;
        print('deviceId login');
        print(deviceId);
      });
    });
  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }


  // void _getUserInfo() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   var user = localStorage.getString('user');
  //   if (token != null || user != null) {
  //     var userList = json.decode(user);
  //     print(userList);
  //     print(userList['userType']);
  //     if (token != null && user != null) {
  //       setState(() {
  //         _isLoggedIn = true;
  //       });
  //       if (_isLoggedIn == true) {
  //         if (userList['userType'] == 'Beneficiary') {
  //           Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(builder: (context) => Beneficiary()));
  //         } else if (userList['userType'] == 'Donor') {
  //           Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(builder: (context) => DonerEmptyPage()));
  //         } else {
  //           Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(builder: (context) => RiderPage()));
  //         }
  //       }
  //     }
  //   }
  // }


  void choiceAction(String choice) {
    if (choice == SettingsModel.appShare) {
      Navigator.push(
          context, SlideLeftRoute(page: AppShareButtons()));
    }
    if (choice == SettingsModel.updateQr) {
      Navigator.push(
          context, SlideLeftRoute(page: UpdateQr()));
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => _onHorizontalDrag(details),
        child: Scaffold(
          // appBar: AppBar(
          //    backgroundColor: Colors.white,
          //   elevation: 0,
          // ),
          backgroundColor: Colors.white,
          body: Container(
            margin:
                EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 50.0),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                            onSelected: choiceAction,
                            icon: Icon(
                              Icons.settings,
                              color: Theme.of(context).primaryColor,
                            ),
                            itemBuilder: (BuildContext context) {
                              return SettingsModel.choices
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        // IconButton(
                        //   onPressed: () {
                        //     // Navigator.push(
                        //     //     context, SlideLeftRoute(page: ScreenTwo()));
                        //     Navigator.push(
                        //         context, SlideLeftRoute(page: UpdateQr()));
                        //   },
                        //   icon: Icon(
                        //     Icons.settings,
                        //     color: Theme.of(context).primaryColor,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 60.0),
                    child: Text(
                      'Sign in to Continue',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'I\'m a',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: ShapeDecoration(
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
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                            child: Text(
                              'Rider',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: 'Rider',
                          ),
                          DropdownMenuItem<String>(
                            child: Text(
                              'Donor',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: 'Donor',
                          ),
                          DropdownMenuItem<String>(
                            child: Text(
                              'Beneficiary',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: 'Beneficiary',
                          ),
                          DropdownMenuItem<String>(
                            child: Text(
                              'Public Reporter',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: 'Public Reporter',
                          ),
                        ],
                        iconDisabledColor: Theme.of(context).primaryColor,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        hint: Text(
                          'Select',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            // _value = value;
                            // userType = _value;
                            userType = value;
                          });
                        },
                        // hint: Text('Select Item'),
                        value: userType, //_value,
                      ),
                    ),
                  ),
                  // Container(
                  //   // width: MediaQuery.of(context).size.width,
                  //   padding: EdgeInsets.only(top: 5.0),
                  //   child: TextField(
                  //     controller: emailLoginController,
                  //     keyboardType: TextInputType.emailAddress,
                  //     decoration: InputDecoration(
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderSide:
                  //             BorderSide(color: Theme.of(context).primaryColor),
                  //       ),
                  //       hintText: 'Email',
                  //       hintStyle:
                  //           TextStyle(color: Theme.of(context).primaryColor),
                  //       prefixIcon: Icon(
                  //         Icons.email,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //     style: TextStyle(
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: passLoginController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        hintText: 'Password',
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      obscureText: true,
                    ),
                  ),
                  // Container(
                  //   // width: MediaQuery.of(context).size.width,
                  //   padding: EdgeInsets.only(top: 5.0),
                  //   child: TextField(
                  //     keyboardType: TextInputType.number,
                  //     controller: mobileLoginController,
                  //     decoration: InputDecoration(
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderSide:
                  //             BorderSide(color: Theme.of(context).primaryColor),
                  //       ),
                  //       hintText: 'Mobile Number',
                  //       hintStyle:
                  //           TextStyle(color: Theme.of(context).primaryColor),
                  //       prefixIcon: Icon(
                  //         Icons.phone_iphone,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //     style: TextStyle(
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(top: 43),
                    child: RaisedButton(
                      onPressed: () {
                        if(internet == false){
                          return _showMessage('You are not connected to the internet');
                        } else {
                          _isLoading ? null : _logIn();
                        }
                        // setState(() {
                        //   _getId().then((id) {
                        //     deviceId = id;
                        //     print('deviceId');
                        //     print(deviceId);
                        //   });
                        //   _isLoading ? null : _logIn();
                        // });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          _isLoading ? "Please wait..." : "Login",
                          // 'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 19.0, bottom: 10.0),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Don\'t have an account? ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context, SlideLeftRoute(page: Register()));
                          },
                          child: Text(
                            'Sign Up ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                 // Text(isOffline? "Not connected" : "Connected")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////////   Api Calling   //////////////////
  void _logIn() async {
    if (userType == null) {
      return _showDialog("Select a usertype");
    }
    //  else if (emailLoginController.text.isEmpty) {
    //   return _showDialog("Email field is empty");
    // }
    else if (passLoginController.text.isEmpty) {
      return _showDialog("Password field is empty");
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      "appToken": appToken,
      "password": passLoginController.text,
      "device_id": deviceId,//'444446ff',//
    };
    print(data);
    var res = await CallApi().loginPostData(data, '/app/login');
    print(res);
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));

      if (userType == "Beneficiary") {
        Navigator.push(context, SlideLeftRoute(page: Beneficiary()));
      } else if (userType == "Donor") {
        Navigator.push(context, SlideLeftRoute(page: DonorIncidentPage()));
      } else if (userType == "Rider") {
        Navigator.push(context, SlideLeftRoute(page: RiderPage()));
      }
      else if (userType == "Public Reporter") {
        Navigator.push(context, SlideLeftRoute(page: PublicReporter()));
      }
    } else {
      _showDialog('Invalid Password');
    }

    setState(() {
      _isLoading = false;
    });

  }

  void _showDialog(String msg) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  msg, //'Invalid Email/Password Combination'
                ),
                content: SingleChildScrollView(
                  child: Container(
                    color: Color(0xFFF2F2F2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Ok Got it!"),
                          elevation: 5.0,
                          fillColor: Color(0xFFF2F2F2),
                          padding: const EdgeInsets.all(15.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: appColor.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 13.0);
  }

  void internetCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      setState(() {
        internet = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      setState(() {
        internet = true;
      });
    } else {
      print("No Internet !!");
      setState(() {
        internet = false;
      });
    }
  }
  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return; // user have just tapped on screen (no dragging)

      if (details.primaryVelocity.compareTo(0) == -1)
      {
        print('dragged from left');
        Navigator.push(
            context, SlideLeftRoute(page: EmergencyHotlinePage()));
      }
      else
      {
        print('dragged from right');
        Navigator.push(
            context, SlideLeftRoute(page: EmergencyHotlinePage()));
      }
    }
}
