import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/Screen/DonorSection/DonorIncidentPage/DonorIncidentPage.dart';
import 'package:design_app/main.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMoney extends StatefulWidget {
  final incidentList;
  SendMoney(this.incidentList);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  var nPress = 0;

  File _image;
  bool _isImage = false;
  int imgPercent = 1;
  var _showImage;
  bool isLoading = false;
  bool _isCancelImg = false;
  CancelToken token = CancelToken();
  var dio = new Dio();
  int incidentId = 0;
  int donarId = 0;

  String fullUrl, mainUrl;
  String tryUrl;

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
          new FormData.from({"imgUrl": new UploadFileInfo(filePath, fileName),
          "url": '$mainUrl',
          });

      Response response = await Dio().post(
          '$tryUrl',//'http://test.appifylab.com/app/incidentUpload',
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

  @override
  void initState() {
    print('Button is pressed');
    print(nPress);
    setState(() {
      nPress = 0;
    });

    _getUserInfo();
    postPicData();

    incidentId = widget.incidentList.id;
    print('incidentId');
    print(incidentId);
    super.initState();
  }

  postPicData() async {
    var apiUrl = '/app/incidentUpload';
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
    if (token != null || user != null) {
      var userinfoList = json.decode(user);
      donarId = userinfoList['id'];
      print('token');
      print(donarId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          //backgroundColor: Colors.white,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 26),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          titleSpacing: 0.5,
          title: Container(
            child: Text(
              'FINANCIAL ASSISTANCE',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Roboto-Bold",
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (nPress == 0)
                    ? Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Text(
                          'Send money from',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ))
                    : Container(),
                (nPress == 0)
                    ? Container(
                        margin: EdgeInsets.fromLTRB(40, 30, 40, 25),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 40,
                                  width: 40,
                                  //color: Colors.red,
                                  child: Image.asset(
                                    'assets/image/paymayaLogo2.png',
                                    width: 100,
                                    height: 50,
                                  )),
                              SizedBox(width: 5),
                              Text(
                                'PayMaya',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0XFF0083cb),
                                    fontFamily: "Roboto-Bold",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (Platform.isAndroid) {
                            bool isInstalled = await DeviceApps.isAppInstalled('com.paymaya');
                            print(isInstalled);
                            if(isInstalled == true) {
                            setState(() {
                              DeviceApps.openApp('com.paymaya');
                              nPress += 1;
                              print('Button is pressed times');
                              print(nPress);
                            });
                            } else {
                              _showMessage('PayMaya App is not installed on your phone');
                            }
                            } else if (Platform.isIOS) {
                              bool isInstalled = await DeviceApps.isAppInstalled('991673877');
                              print(isInstalled);
                              if(isInstalled == true) {
                              setState(() {
                                DeviceApps.openApp('991673877');
                                nPress += 1;
                                print('Button is pressed times');
                                print(nPress);
                              });
                              } else {
                                _showMessage('PayMaya App is not installed on your phone');
                              }
                            }
                          },
                        ),
                      )
                    : Container(),
                (nPress == 0)
                    ? Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 30),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                          color: Color(0XFF017cfe),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 40,
                                  width: 40,
                                  //color: Colors.red,
                                  child: Image.asset(
                                    'assets/image/gcashLogo2.jpg',
                                    width: 100,
                                    height: 50,
                                  )),
                              SizedBox(width: 5),
                              Text(
                                'GCash',
                                //textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Roboto-Bold",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              bool isInstalled = await DeviceApps.isAppInstalled('com.globe.gcash.android');
                              print(isInstalled);
                              if(isInstalled == true) {
                              setState(() {
                                DeviceApps.openApp('com.globe.gcash.android');
                                nPress += 1;
                                print('Button is pressed times');
                                print(nPress);
                              });
                              } else {
                                _showMessage('GCash App is not installed on your phone');
                              }
                            }
                            else if (Platform.isIOS) {
                                bool isInstalled = await DeviceApps.isAppInstalled('520020791');
                                print(isInstalled);
                                if(isInstalled == true) {
                                setState(() {
                                  DeviceApps.openApp('520020791');
                                  nPress += 1;
                                  print('Button is pressed times');
                                  print(nPress);
                                });
                                } else {
                                  _showMessage('GCash App is not installed on your phone');
                                }
                            }
                          },
                        ),
                      )
                    : Container(),
                // Container(
                //   child: RaisedButton(
                //     child: Icon(Icons.gamepad),
                //     onPressed: () {
                //       DeviceApps.openApp('com.globe.gcash.android');
                //   },),
                // )
                nPress > 0
                    ? Container(
                        child: Column(
                        children: <Widget>[
                          ////////////  upload image //////////////

                          Container(
                              // margin: EdgeInsets.only(,
                              child:
                                  _image == null
                                      ?
                                  Column(
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                //   alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 2,
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                child: DottedBorder(
                                  color: Colors.black,
                                  radius: Radius.circular(60),
                                  strokeWidth: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: IconButton(
                                              icon: Icon(Icons.file_upload,
                                                  color: Colors.black54),
                                              onPressed: getImage),
                                        ),
                                        // Container(
                                        //   padding: EdgeInsets.only(bottom: 12),
                                        //   child: Text(
                                        //     'Upload Image',
                                        //     style: TextStyle(
                                        //       color: Colors.black54,
                                        //       fontSize: 16.0,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
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
                                        top: 20, left: 20, right: 20),
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height / 1.9,
                                        padding: EdgeInsets.only(top: 8, bottom: 8),
                                        child: Container(
                                          child: Image.file(_image,
                                              height: 120, width: 120, fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                            ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 30),
                          //   height: MediaQuery.of(context).size.height / 2,
                          //   width: MediaQuery.of(context).size.width / 1.2,
                          //   color: Colors.grey.withOpacity(0.2),
                          //   child: Container(
                          //       child: Icon(
                          //     Icons.photo_camera,
                          //     size: 30,
                          //   )),
                          // ),
                          _image == null? GestureDetector(
                            onTap: getImage,
                            child: Container(
                                margin: EdgeInsets.only(top: 100),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(top: 0),
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Import from Gallery',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(Icons.camera_alt, size: 28),
                                    ),
                                  ],
                                )),
                          )
                          :
                          Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                         // padding: EdgeInsets.only(left: 40, right: 40),
                          margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            onPressed: () {
                              // showMsg();
                              checkSOS();

                              // Navigator.push(
                              //      context, SlideLeftRoute(page: Beneficiary()));
                            },
                            color: appColor,
                            child: Container(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(
                                'Donate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Roboto-Bold",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                        ],
                      ))
                    : Container(),
                    // IconButton(icon: Icon(Icons.ac_unit), onPressed:(){getImage();})
                //  (nPress > 0) ? Text('Paid') : Text('Not Paid')
              ],
            ),
          ),
        )));
  }


  Future<void> checkSOS() async {
    if (_image == null) {
      _showMessage("No picture is added, add a picture");
    }

    setState(() {
      isLoading = true;
    });

    var items = {
      "incidentId": incidentId,
      "donerId": donarId,
      "payment_img": _showImage,
    };

    print(items);

    var res = await CallApi().postData(items, '/app/addDonationPaymentImg');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      // sendSOS();
      showMsg();
      //_image == null;
    }

    print(items);

    setState(() {
      isLoading = false;
    });
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

  void showErrorMsg(msg) {
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
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 45.0, right: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Message",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  msg,
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 112, 112, 112)),
                  textAlign: TextAlign.center,
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonorIncidentPage()));
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
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
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
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 45.0, right: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Message",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Donation is summited successfully",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 112, 112, 112)),
                  textAlign: TextAlign.center,
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonorIncidentPage()));
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
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
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
