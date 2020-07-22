import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/EmergencyHotlineSection/EmergencyHotlineCard/EmargencyHotlineCard.dart';
import 'package:design_app/Screen/Profile/ProfileEditForm.dart';
import 'package:design_app/Screen/login.dart';
import 'package:design_app/main.dart';
import 'package:design_app/model/DonationsForRiderModel/DonationsForRiderModel.dart';
import 'package:design_app/model/EmergencyHotlineModel/EmergencyHotlineModel.dart';
import 'package:design_app/model/StatusFilterModel/StatusFilterModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyHotlinePage extends StatefulWidget {
  @override
  _EmergencyHotlinePageState createState() => _EmergencyHotlinePageState();
}

class _EmergencyHotlinePageState extends State<EmergencyHotlinePage> {
  TextEditingController msgController = TextEditingController();
  var emergencyHotlineBody, emergencyHotlineList;
  var incidentMsg = "";

  var userData;
  var selectedStatus = '';

  @override
  void initState() {
    setState(() {
      //_getUserInfo();
      getEmergencyList();
    });
    super.initState();
  }


  Future<void> getEmergencyList() async {
    var res;
   // if (selectedStatus == '') {
      res = await CallApi().logIngetData('/app/showEmergency');
  //  }
    // else {
    //   res = await CallApi().getData(
    //       '/app/showDonationforRider?date=$date&status=$selectedStatus');
    // }
    emergencyHotlineBody = json.decode(res.body);
    print(emergencyHotlineBody);

    if (res.statusCode == 200) {
      var emergencyHotlinecontent = res.body;
      final emergencyHotline = json.decode(emergencyHotlinecontent);

      var emergencyHotlinedata = EmergencyHotlineModel.fromJson(emergencyHotline);
      emergencyHotlineList = emergencyHotlinedata.emergency;

      if (emergencyHotlineList != null) {
        setState(() {
          //  String dd = incidentList.created_at;
          //  var spDate = dd.split(" ");
          //  alertDate = spDate[0];
          // situation = incidentList.situation;
          print('emergencyHotlineList');
          print(emergencyHotlineList);
        });
        print(emergencyHotline);
      } else {
        setState(() {
          incidentMsg = "No Emergency contact found !!!";
        });
      }
      // setState(() {
      //   selectedStatus = '';
      // });

      // setState(() {
      //   incidentList = incidentdata.incident;
      // });
      // print("incidentList.length");
      // print(incidentList.length);

    }
  }


  @override
  Widget build(BuildContext context) {
    return 
    // WillPopScope(
    //   onWillPop: _onWillPop,
     // child:
       Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.5,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: appColor, size: 28,), onPressed: (){
                    Navigator.pop(context);
                  }),
            titleSpacing: 0.5,
            title: Container(
              margin: EdgeInsets.only(left: 0, top: 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Emergency Hotline',
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto-Bold",
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  emergencyHotlineList == null
                      ? Center(child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator()))
                      : emergencyHotlineList.length == 0
                          ? Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 300,
                                  child: Text("No Emergency contact found !!!")))
                          :
                          Container(
                             // height: 150,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, bottom: 30, top: 20),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: emergencyHotlineList.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Column(
                                      children: <Widget>[
                                        EmergencyHotlineCard(
                                            emergencyHotlineList[index])
                                      ],
                                    );
                                  })),
                ],
              ),
            ),
          ),
        ),
    //  ),
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

}
