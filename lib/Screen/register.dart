import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'login.dart';
import 'package:path/path.dart' as Path;
import 'package:dio/dio.dart';
//import 'package:path/path.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
//    LocationData _currentLocation;
//   Location location = Location();
// var userLocation;
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "Date of birth";
  String _value;
  String userType = '';

  bool _isLoading = false;

  String deviceId = '';

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController payMayaNumber = new TextEditingController();
  TextEditingController gCashNumber = new TextEditingController();
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

  bool internet = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
    } else {
      _uploadImg(image);

      setState(() {
        _image = image;
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
          new FormData.from({"imgUrl": new UploadFileInfo(filePath, fileName)});

      Response response = await Dio().post(
       // CallApi().getUrl()+'/app/userUpload',
        '$tryUrl',
         // 'http://test.appifylab.com/app/userUpload',
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
  }

  void cancelImg() async {
    print("object");
    setState(() {
      _isImage = false;
      _isCancelImg = true;
      // print(_isCancelImg);
    });
  }

  String fullUrl;
  String tryUrl;

  @override
  void initState() {
    getLocationData();
    internetCheck();
    postPicData();
    // print("full url is : $fullUrl");
   // postPicData('/app/userUpload');
    super.initState();
  }

  postPicData() async {
    var apiUrl = '/app/userUpload';
    fullUrl = await CallApi().getUrl() + apiUrl;
    tryUrl = fullUrl;
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    print("full url is : $tryUrl");
    return fullUrl;
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

  void getLocationData () {
    var location = new Location();

    location.onLocationChanged().listen((LocationData currentLocation) {
      setState(() {
        lat = currentLocation.latitude;
        lan = currentLocation.longitude;
      });
      deviceID();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 40.0),
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ////////////  upload image //////////////

              Container(
                // margin: EdgeInsets.only(,
                child: _image == null
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          color: Theme.of(context).accentColor,
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
                    : GestureDetector(
                      onTap: getImage,
                      child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              child: ClipOval(
                                child: Image.file(_image,
                                    height: 120, width: 120, fit: BoxFit.fill),
                              ),
                            ),
                          ],
                        ),
                    ),
              ),

              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: name,
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
              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    hintText: 'Password (min 6 digit)',
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
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
              Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: number,
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
                    margin: EdgeInsets.only(left: 12, right: 10, top: 20, bottom: 12),
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
                              date.toString(),
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

              // Container(

              //   child: RaisedButton(child: Text('$deviceId',), onPressed: () {
              //     _getId().then((id) {
              //       deviceId = id;
              //       print('deviceId');
              //       print(deviceId);
              //     });
              //   },),
              // ),

              // Container(
              //   child: Text('$deviceId'),
              // ),

              // Container(
              //   margin: EdgeInsets.only(top: 5.0),
              //   width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.only(
              //     left: 10.0,
              //     right: 10.0,
              //   ),
              //   decoration: ShapeDecoration(
              //     shape: RoundedRectangleBorder(
              //       side: BorderSide(
              //         width: 1.0,
              //         style: BorderStyle.solid,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(5.0),
              //       ),
              //     ),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       items: [
              //         DropdownMenuItem<String>(
              //           child: Text(
              //             'Rider',
              //             style: TextStyle(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 15.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           value: 'Rider',
              //         ),
              //         DropdownMenuItem<String>(
              //           child: Text(
              //             'Donor',
              //             style: TextStyle(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 15.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           value: 'Donor',
              //         ),
              //         DropdownMenuItem<String>(
              //           child: Text(
              //             'Beneficiary',
              //             style: TextStyle(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 15.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           value: 'Beneficiary',
              //         ),
              //       ],
              //       iconDisabledColor: Theme.of(context).primaryColor,
              //       iconEnabledColor: Theme.of(context).primaryColor,
              //       hint: Text(
              //         'Select',
              //         style: TextStyle(
              //           color: Theme.of(context).primaryColor,
              //           fontSize: 15.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       onChanged: (String value) {
              //         setState(() {
              //           _value = value;
              //           userType = _value;
              //           print(userType);
              //         });
              //       },
              //       // hint: Text('Select Item'),
              //       value: _value,
              //     ),
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 50),
                child: RaisedButton(
                  onPressed: () {
                    if(internet == false){
                        return _showMessage('You are not connected to the internet');
                      } else {
                        _isLoading ? null : _handleRegister();
                      }
                  },
                 // onPressed: _isLoading ? null : _handleRegister,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 3.0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      _isLoading ? "Creating..." : "Register",
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
              Container(
                margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account? ',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0,
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, SlideLeftRoute(page: Login()));
                      },
                      child: Text(
                        'Sign In ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void uploadImage(File image) async {

  //   print(image.path);

  //     String fileName = Path.basename(image.path);

  //      try {
  //     FormData formData = new FormData.from({"img": new UploadFileInfo(image, fileName)});
  //     //FormData formData = new FormData.from({""})
  //     Response response = await Dio().post(
  //         'http://test.appifylab.com/app/userUpload',
  //         data: formData,);

  //           //imgPercent=0;

  //     //     setState(() {
  //     //   _isImage = false;
  //     // });

  //   } catch (e) {
  //     print("Exception Caught: $e");
  //   }
  //   print("File base name: $fileName");
  // }



  /////////////////////////////////  Api Calling   /////////////////////////////
  void _handleRegister() async {
    if (name.text.isEmpty) {
      return _showDialog('Please Enter Your Name..');
    } else if (email.text.isEmpty) {
      return _showDialog('Please Enter Your Email Address..');
    } else if (!email.text.contains('@')) {
      return _showDialog("Email is invalid");
    } else if (password.text.isEmpty) {
      return _showDialog('You need to create a Passowrd..');
    } else if (password.text.length < 6) {
      return _showDialog('Password length not less than 6 character..');
    } else if (number.text.isEmpty) {
      return _showDialog('Please Enter Your Mobile Number..');
    } else if (payMayaNumber.text.isEmpty) {
      return _showDialog('Please Enter Your Paymaya Number..');
    } else if (gCashNumber.text.isEmpty ) {
      return _showDialog('Please Enter Your GCash Number..');
    } else if (date == "Date of birth") {
      return _showDialog('Please Enter Your Date of birth..');
    }

    var data = {
      "email": email.text,
      "password": password.text,
      //"userType": userType,
      "device_id": deviceId,// '444446ff',
      "mobileNumber": number.text,
      "lat": lat,
      "lng": lan,
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
    if(lat == null || lan == null || deviceId == null){
      return setState(() {
        getLocationData();
        _showMessage("Wait while getting location...");
        _isLoading = false;
      });
    } else {
      var res = await CallApi().loginPostData(data, '/app/register');
      print(res);
      var body = json.decode(res.body);
      print(body);

    // setState(() {
    //   regData = res.body;
    // });

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
     // localStorage.setString('deviceId', deviceId);

      _showMessage("You are successfully registered to this app!");

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
      setState(() {
        _isLoading = false;
      });
    } else if (res.statusCode == 400) {
        return setState(() {

        _showDialog(body['message'].toString());
        _isLoading = false;
      });
      // return setState(() {
      //   getLocationData();
      //   _showDialog(body['email'].toString());
      //   _isLoading = false;
      // });
    }
    setState(() {
      _isLoading = false;
    });
    }
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

}
