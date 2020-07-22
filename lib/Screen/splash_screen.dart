import 'dart:async';
import 'dart:convert';

import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/login.dart';
import 'package:design_app/Screen/screen_two.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BeneficiarySection/Beneficiary/Beneficiary.dart';
import 'DonorSection/DonorIncidentPage/DonorIncidentPage.dart';
import 'PublicReporterSection/PublicReporter/PublicReporter.dart';
import 'RiderSection/RiderPage/RiderPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isLoggedIn = false;
  bool _isBeneficiary = false;
  bool _isDonor = false;
  bool _isRider = false;
  bool _isReporter = false;

  @override
  void initState() {
    super.initState();
    loadData();
    _checkIfLoggedIn();
  }

  // @override
  // void initState() {
  //   _checkIfLoggedIn();
  //   super.initState();
  // }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var logData = localStorage.getString('loggedIn');
    print(logData);
    if(token != null){
    if (logData == 'Beneficiary') {
      setState(() {
        _isBeneficiary = true;
        _isDonor = false;
        _isRider = false;
        _isReporter = false;
      });
    } else if (logData == 'Donor') {
      setState(() {
        _isDonor = true;
        _isBeneficiary = false;
        _isRider = false;
        _isReporter = false;
      });
    } else if (logData == 'Rider') {
      setState(() {
        _isRider = true;
        _isBeneficiary = false;
        _isDonor = false;
        _isReporter = false;
      });
    }
    else if (logData == 'Public Reporter') {
      setState(() {
        _isReporter = true;
        _isRider = false;
        _isBeneficiary = false;
        _isDonor = false;
      });
    }
    }
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    if (_isBeneficiary == true) {
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>Beneficiary()));
    } else if (_isDonor == true) {
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>DonorIncidentPage()));
    } else if (_isRider == true) {
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>RiderPage()));
    } else if (_isReporter == true) {
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>PublicReporter()));
    } else {
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/logo.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    BlendMode.dstATop),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                'Logo',
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'bold',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
