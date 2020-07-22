import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './donate_view_add_screen.dart';
import 'DonorIncidentPage/DonorIncidentPage.dart';

class DonateCancelScreen extends StatefulWidget {
  final donorList;
  DonateCancelScreen(this.donorList);
  @override
  _DonateCancelScreenState createState() => _DonateCancelScreenState();
}

class _DonateCancelScreenState extends State<DonateCancelScreen> {
  TextEditingController reasonController = TextEditingController();
  bool isLoading = false;
  var id = '';
  int donerId = 0;
  var userToken = '';


  @override
  void initState() {
    id = widget.donorList.id == null ? "" : '${widget.donorList.id}';
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user = localStorage.getString('user');
    if (token != null || user != null) {
      var userinfoList = json.decode(user);
      donerId = userinfoList['id'];
      userToken = token;
      print('userToken');
      print(userToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DonateViewAddScreen()),
            // );
          },
        ),
        title: Text(
          'DONATE-VIEW/EDIT',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                child: Text(
                  'Reason for cancellation',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  controller: reasonController,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.all(15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 43),
                child: RaisedButton(
                  /////////////////
                  onPressed: () {
                    confirmCancel();
                  },
                  ////////////////
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> confirmCancel() async {
    if(reasonController.text.isEmpty)
    {
      return _showMessage('Please give a reason for your cancellation');
    }
    setState(() {
      isLoading = true;
    });

    var items = {
      "isCancel": 1,
      "reason": reasonController.text,
      // "donerId": userToken,
    };

    print(items);

    var res =
        await CallApi().postData(items, '/app/CancelDonation/$id?token=$userToken');
        print(res);

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      showMsg();
      reasonController.text = '';
    }

    // print(items);

    setState(() {
      isLoading = false;
    });
  }

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DonorIncidentPage())
                      );
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
                        'Ok',
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
}
