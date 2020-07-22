import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/Screen/BeneficiarySection/Beneficiary/Beneficiary.dart';
import 'package:design_app/Screen/DonorSection/DonorIncidentPage/DonorIncidentPage.dart';
import 'package:design_app/Screen/Profile/ChangePassword.dart';
import 'package:design_app/Screen/PublicReporterSection/PublicReporter/PublicReporter.dart';
import 'package:design_app/Screen/RiderSection/RiderPage/RiderPage.dart';
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:path/path.dart' as Path;
import 'package:dio/dio.dart';

import '../login.dart';
//import 'package:path/path.dart';

class ProfileEditForm extends StatefulWidget {
  final loggedData;
  ProfileEditForm(this.loggedData);
  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  TextEditingController payMayaNumber = new TextEditingController();
  TextEditingController gCashNumber = new TextEditingController();
//    LocationData _currentLocation;
//   Location location = Location();
// var userLocation;
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  String _value;
  String userType = '';

  bool _isLoading = false;

  String deviceId = '';

  var userData;
  var userToken = '';

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  // TextEditingController password = new TextEditingController();
  TextEditingController number = new TextEditingController();
  String base64Image;
  var lat;
  var lan;
  var strImage;
  File _image;
  bool _isImage = false;
  int imgPercent = 1;
  List imgList = [];
  var _showImage;
  bool isLoading = false;
  bool _isCancelImg = false;
  CancelToken token = CancelToken();
  var dio = new Dio();
  bool _isGetImage = false;

  String fullUrl, mainUrl;
  String tryUrl;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
    } else {
      _uploadImg(image);

      setState(() {
        _image = image;
        _isGetImage = true;
      });
    }
  }

  void _uploadImg(filePath) async {
    setState(() {
      _isImage = true;
    });

    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData =
          new FormData.from({"imgUrl": new UploadFileInfo(filePath, fileName),
          "url": '$mainUrl',
          });

      Response response = await Dio().post(
          '$tryUrl',//'http://test.appifylab.com/app/userUpload',
          data: formData,
          cancelToken: token, onSendProgress: (int sent, int total) {
        //imgPercent=0;
        setState(() {
          imgPercent = ((sent / total) * 100).toInt();

          print("percent");
          print(imgPercent);
        });
      });
      print('response');
      print(response);
      print('_isCancelImg');
      print(_isCancelImg);

      if (_isCancelImg == true) {
        _isCancelImg = false;
      } else {
        setState(() {
          _showImage = response.data['imgUrl'];
          _isImage = false;
          imgPercent = 0;
        });
        print('_showImage');
        print(_showImage);

        //imgList.add({'imgUrl': response.data['imgUrl']});
      }
      //     setState(() {
      //   _isImage = false;
      // });
      print('imgList');
      print(imgList);

      // Show the incoming message in snakbar
      //_showMsg(response.data['message']);
    } catch (e) {
      // print("Exception Caught: $e");
    }
    print(_isImage);
  }

  void cancelImg() async {
    print("object");
    setState(() {
      _isImage = false;
      _isCancelImg = true;
      // print(_isCancelImg);
    });
  }

  @override
  void initState() {
    _getUserInfo();
    postPicData();
    super.initState();
  }

  postPicData() async {
    var apiUrl = '/app/userUpload';
    mainUrl = await CallApi().getUrl();
    fullUrl = await CallApi().getUrl() + apiUrl;
    tryUrl = fullUrl;
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    print("full url is : $tryUrl");
    return fullUrl;
  }


  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user = localStorage.getString('user');
    print('userrrrr');
    print(user);
    // deviceId = localStorage.getString('deviceId');
    if (token != null || user != null) {
      var userinfoList = json.decode(user);
      setState(() {
        userData = userinfoList;
        userToken = token;
      });
      //deviceId = userinfoList['device_id'];
      print('userData');
      print(userData);
      print('userToken');
      print(userToken);
    }
    name.text = userData != null && userData['name'] != null
        ? '${userData['name']}'
        : 'Name';
    email.text = userData != null && userData['email'] != null
        ? '${userData['email']}'
        : 'Email';
    number.text = userData != null && userData['mobileNumber'] != null
        ? '${userData['mobileNumber']}'
        : 'Mobile number';
    payMayaNumber.text = userData != null && userData['paymaya'] != null
        ? '${userData['paymaya']}'
        : 'Paymaya number';
    gCashNumber.text = userData != null && userData['gcash'] != null
        ? '${userData['gcash']}'
        : 'Gcash number';
    date = userData != null && userData['birthDate'] != null
        ? '${userData['birthDate']}'
        : '';
    _showImage = userData != null && userData['image'] != null
        ? '${userData['image']}'
        : '';
    // _showImage = null;
    print(_showImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          padding: EdgeInsets.only(top: 5.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 28,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (widget.loggedData == 'Beneficiary') {
                Navigator.push(context, SlideLeftRoute(page: Beneficiary()));
              } else if (widget.loggedData == 'Donor') {
                Navigator.push(
                    context, SlideLeftRoute(page: DonorIncidentPage()));
              } else if (widget.loggedData == 'Rider') {
                Navigator.push(
                    context, SlideLeftRoute(page: RiderPage()));
              } else {
                Navigator.push(context, SlideLeftRoute(page: PublicReporter()));
              }
            },
          ),
        ),
        titleSpacing: 2,
        title: Container(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(
            'Profile Edit',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //   icon: Icon(Icons.vpn_key, size: 28,),
        //   color: Theme.of(context).primaryColor,
        //   onPressed: () {
        //     Navigator.push(
        //               context, SlideLeftRoute(page: ChangePassword()));
        //   },
        // ),
        // ],
      ),
      body: Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 12.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ////////////  upload image //////////////

              Container(
                  // margin: EdgeInsets.only(,
                  child: _showImage == '' || _showImage == null
                      ? Column(
                          //  mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              //   alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: DottedBorder(
                                color: Colors.black,
                                radius: Radius.circular(60),
                                strokeWidth: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: IconButton(
                                            icon: Icon(Icons.file_upload,
                                                color: Color(0xFF8A8A8A)),
                                            onPressed: getImage),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: Text(
                                          'Upload Image',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              child: _isImage
                                  ? Column(
                                      children: <Widget>[
                                        imgPercent == 100
                                            ? Container(
                                                margin: EdgeInsets.only(top: 20,),
                                                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(5))),
                                                child: Text(
                                                  '.... loading picture',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.only(top: 20,),
                                                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(5))),
                                                child: Text(
                                                  '$imgPercent % loading',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )
                                  : ClipOval(
                                      child: GestureDetector(
                                          onTap: getImage,
                                          child: Image.network(
                                            _showImage,
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          )
                                          // child: Image.file(_image,
                                          //     height: 120, width: 120, fit: BoxFit.fill),
                                          ),
                                    ),
                            ),
                          ],
                        )
                  // :
                  // Column(
                  //   children: <Widget>[
                  //     Container(
                  //       margin: EdgeInsets.only(
                  //         top: 20,
                  //       ),
                  //       child: ClipOval(
                  //         child: GestureDetector(
                  //           onTap: getImage,
                  //           child: Image.file(_image,
                  //               height: 120, width: 120, fit: BoxFit.fill),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ),

              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: name,
                  minLines: 1,
                  maxLines: 20,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  minLines: 1,
                  maxLines: 20,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              // Container(
              //   // width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.only(top: 5.0),
              //   child: TextField(
              //     controller: password,
              //     decoration: InputDecoration(
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide:
              //             BorderSide(color: Theme.of(context).primaryColor),
              //       ),
              //       hintText: 'Password (min 6 digit)',
              //       hintStyle: TextStyle(color: Theme.of(context).primaryColor),
              //       prefixIcon: Icon(
              //         Icons.lock,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //     ),
              //     style: TextStyle(
              //       color: Theme.of(context).primaryColor,
              //     ),
              //     obscureText: true,
              //   ),
              // ),
              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: number,
                  minLines: 1,
                  maxLines: 20,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    prefixIcon: Icon(
                      Icons.phone_iphone,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              //////////////////////// PayMaya Number  /////////////////////

              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 1.0, bottom: 3.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 50,
                     // color: Colors.red,
                      child: Image.asset('assets/image/paymayaLogo2.png', width: 100, height: 50,)),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: payMayaNumber,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          //       BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          disabledBorder: UnderlineInputBorder(
                              borderSide:
                                BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                BorderSide(color: Colors.white),
                          ),
                          hintText: 'PAYMAYA Number',
                          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(thickness: 1, height: 0.2, color: appColor),

              //////////////////////// GCash Number  /////////////////////

              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 2.0, bottom: 4.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 22,
                      width: 50,
                     // color: Colors.red,
                      child: Image.asset('assets/image/gcashLogo2.jpg', width: 100, height: 50,)),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: gCashNumber,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          //       BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          disabledBorder: UnderlineInputBorder(
                              borderSide:
                                BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                BorderSide(color: Colors.white),
                          ),
                          hintText: 'GCASH Number',
                          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(thickness: 1, height: 0.2, color: appColor),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectDate(context);
                    //_showDate();
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(left: 12, right: 10, top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                        size: 22,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            (date == '' || date == null)
                                ? 'Date of birth'
                                : date.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: "Roboto-Regular",
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 1, height: 1, color: appColor),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 50),
                child: RaisedButton(
                  // onPressed: () {
                  // //   _registerNow();
                  // },
                  onPressed: _isLoading ? null : _profileUpdate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 3.0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      _isLoading ? "Creating..." : "Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(top: 19.0, bottom: 10.0),
              //   child: Text(
              //     'Forgot Password?',
              //     style: TextStyle(
              //       color: Theme.of(context).accentColor,
              //       fontSize: 12.0,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////////  Api Calling   /////////////////////////////
  void _profileUpdate() async {
    if (!email.text.contains('@')) {
      return _showDialog("Email is invalid");
    }

    var data = {
      "email": email.text,
      //"userType": userType,
      "mobileNumber": number.text,
      "image": _showImage,
      "name": name.text,
      "birthDate": date,
      "gcash": gCashNumber.text,
      "paymaya": payMayaNumber.text,
    };
    print(data);
    setState(() {
      _isLoading = true;
    });

    // print(data);

    var res = await CallApi()
        .loginPostData(data, '/app/profileEdit?token=$userToken');
    print(res);
    var body = json.decode(res.body);
    print(body);

    // setState(() {
    //   regData = res.body;
    // });

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['user']));
      // localStorage.setString('deviceId', deviceId);

      _showMessage("Your profile is updated!");

      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return Login();
      // }));
    } else {
      _showMessage("Something went wrong !!");
    }
    setState(() {
      _isLoading = false;
    });
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("yyyy-MM-dd").format(selectedDate)}";
      });
  }
}
