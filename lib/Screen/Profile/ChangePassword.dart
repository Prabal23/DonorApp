import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //elevation: 0,
          backgroundColor: appColor,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          title: Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
              //  fontSize: 21.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        //backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: 15.0, top: 10.0, right: 15.0, bottom: 40),
                child: Column(
                  children: <Widget>[
                    //  VerifyEmail(),

                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(bottom: 30, top: 30),
                      alignment: Alignment.center,
                      //height: 70,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.blue,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Please enter your Old Password to verify this account.',
                              //textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                decoration: TextDecoration.none,
                                fontFamily: 'sourcesanspro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /////////// Form Start//////////

                    ChangePassForm()
                    ///////////Form end///////////
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

/////////

class ChangePassForm extends StatefulWidget {
  @override
  _ChangePassFormState createState() => _ChangePassFormState();
}

class _ChangePassFormState extends State<ChangePassForm> {
    bool _isLoading = false;
  var userData;
  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var matchOldPass = "";
  @override
  void initState() {
    _getOldPass();
      //  _getUserInfo();
    super.initState();
  }

  void _getOldPass() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
      matchOldPass = localStorage.getString('pass');
      print(matchOldPass);
  }
  //   void _getUserInfo() async {
  //   // SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   // var userJson = localStorage.getString('user');
  //   // var user = json.decode(userJson);
  //   // setState(() {
  //   //   userData = user;
  //   // });
  //   // // firstNameController.text = userData != null && userData['firstName'] != null
  //   // //   ? '${userData['firstName']}'
  //   // //   : 'Type Here';
  //   // // lastNameController.text = userData != null && userData['lastName'] != null
  //   // //   ? '${userData['lastName']}'
  //   // //   : 'Type Here';
  //   // // emailController.text = userData != null && userData['email'] != null
  //   // //   ? '${userData['email']}'
  //   // //   : 'Type Here';
  //   // print(user);
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 0),
        //color: Colors.red,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 0),
              // height: 100,
              width: MediaQuery.of(context).size.width,
              //color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ///////////////// Old Password Textfield  Start///////////////

                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: TextField(
                      obscureText: true,
                      controller: oldPasswordController,
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.white,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                        enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontFamily: "sourcesanspro",
                            fontWeight: FontWeight.normal),
                        contentPadding:
                            EdgeInsets.only(left: 20, bottom: 12, top: 12),
                        fillColor: Colors.grey[200].withOpacity(0.5),
                        filled: true,
                        hintText: "Password",
                      ),
                    ),
                  ),

                  /////////////////Old PAssword Textfield  End///////////////

                  ////////////////////new PAssword Text start///////////////

                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(bottom: 10, top: 0),
                    alignment: Alignment.centerLeft,
                    //height: 70,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.blue,
                    child: Text(
                      'Enter new password',
                      //textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'sourcesanspro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ////////////////////new PAssword Text end///////////////

                  ///////////////// New Password Textfield  Start///////////////
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: TextField(
                      obscureText: true,
                      controller: newPasswordController,
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.white,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                        enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontFamily: "sourcesanspro",
                            fontWeight: FontWeight.normal),
                        contentPadding:
                            EdgeInsets.only(left: 20, bottom: 12, top: 12),
                        fillColor: Colors.grey[200].withOpacity(0.5),
                        filled: true,
                        hintText: "New Password",
                      ),
                    ),
                  ),

                  ///////////////// New Password Textfield  End///////////////

                  ///////////////// Confirm Textfield  Start///////////////
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.white,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                        enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontFamily: "sourcesanspro",
                            fontWeight: FontWeight.normal),
                        contentPadding:
                            EdgeInsets.only(left: 20, bottom: 12, top: 12),
                        fillColor: Colors.grey[200].withOpacity(0.5),
                        filled: true,
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),

                  ///////////////// Confirm Textfield  End///////////////
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              //height: 90,
              width: MediaQuery.of(context).size.width,
              //color: Colors.yellow,
              child: Column(
                children: <Widget>[
                  ///////////////// Submit Button  Start///////////////

                  Container(
                      decoration: BoxDecoration(
                        color: appColor.withOpacity(0.9),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: FlatButton(
                          child: Text(
                            'Submit',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              decoration: TextDecoration.none,
                              fontFamily: 'MyriadPro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          color: Colors.transparent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          onPressed: () {
                            Navigator.pop(context);
                          })),

                  ///////////////// Submit Button  End///////////////
                ],
              ),
            )
          ],
        ));
  }

  //  _changePassword() async{
  //    if (oldPasswordController.text.isEmpty){
  //       return _showMsg("Old Password is empty");
  //     }
  //       else if(matchOldPass != oldPasswordController.text){
  //       return _showMsg("Old Password doesn't match");
  //     }
  //     else if (newPasswordController.text.isEmpty){
  //       return _showMsg("New Password is empty");
  //     }
  //     else if (confirmPasswordController.text.isEmpty){
  //       return _showMsg("Confirm Password is empty");
  //     }

  //     else if(newPasswordController.text != confirmPasswordController.text){
  //       return _showMsg("Confirm Password doesn't match");
  //     }

  //     var data = {
  //     'oldPassword': oldPasswordController.text,
  //     'password' : newPasswordController.text
  //   };

  //   var res = await CallApi().postData(data, 'auth/resetPassword');
  //   var body = json.decode(res.body);
  //   print(body);
  //   if(body['success']==true){
  //       SharedPreferences localStorage = await SharedPreferences.getInstance();
  //      localStorage.remove('pass');
  //      localStorage.setString('pass', newPasswordController.text);

  //     _changePassMsg();

  //   }
  //    else{

  //     showMsg(context,"Error");
  //   }

  // }

  void _changePassMsg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.all(5),
            title: Text(
              "Your Password has been changed. Now you can login with your new password",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontFamily: "grapheinpro-black",
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            actions: <Widget>[
              Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  // width: MediaQuery.of(context).size.width/3,
                  height: 30,
                  margin: EdgeInsets.only(bottom: 15, right: 10),
                  child: OutlineButton(
                      color: Colors.greenAccent[400],
                      child: new Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //     context, SlideLeftRoute(page: LogIn()));
                      },
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0))))
            ]);
      },
    );
  }
}
