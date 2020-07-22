import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/model/ThanksModel/ThanksModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'ThanksCard.dart';


class ThanksList extends StatefulWidget {
  @override
  _ThanksListState createState() => _ThanksListState();
}

class _ThanksListState extends State<ThanksList> {
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "Select Date";
  var alertDate = '';
  var userToken;
  var body, thanksBody, thanksList;
  var situation = "", thanksMsg = "No thanks yet!";
  bool isLoading = false;

  var userData;
  var _showImage;
  @override
  void initState() {
    setState(() {
      _getUserInfo();
      getThanksList();
    });
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userToken = localStorage.getString('token');
    var user = localStorage.getString('user');

    print("user");
    print(user);
    print("token");
    print(userToken);
    // if (token != null || user != null) {
    //   var userinfoList = json.decode(user);

    //   setState(() {
    //     userData = userinfoList;
    //     userToken = token;
    //   });
    // }
    // _showImage = userData != null && userData['image'] != null
    //     ? '${userData['image']}'
    //     : '';
    // print(_showImage);
  }

  Future<void> getThanksList() async {
    var res = await CallApi().getData('/app/showThanks?token=$userToken');
    thanksBody = json.decode(res.body);
    print(thanksBody);

    if (res.statusCode == 200) {
      var thankscontent = res.body;
      final thanks = json.decode(thankscontent);
      isLoading = true;

      var thanksdata = ThanksModel.fromJson(thanks);
      thanksList = thanksdata.showThank;

      if (thanksList != null) {
        setState(() {
          //  String dd = thanksList.created_at;
          //  var spDate = dd.split(" ");
          //  alertDate = spDate[0];
          // situation = thanksList.situation;
          print('thanksList');
          print(thanksList);
        });
        print(thanks);
      } else {
        setState(() {
          thanksMsg = "No thanks yet!";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
                margin: EdgeInsets.only(top: 30, bottom: 25),
                child: Text(
                  'Thanks List',
                  style: TextStyle(
                      color: appColor,
                      fontFamily: "Roboto-Bold",
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(top: 15, right: 5, left: 5),
            child: Column(
              children: <Widget>[

                thanksList == null
                    ? Center(child: CircularProgressIndicator())
                    : thanksList.length == 0
                        ? Center(
                            child: Container(
                                alignment: Alignment.center,
                                height: 300,
                                child: Text(thanksMsg)))
                        :
                Container(
                    // height: 150,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 30),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: thanksList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Column(
                            children: <Widget>[
                              ThanksCard(thanksList[index])
                            ],
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
