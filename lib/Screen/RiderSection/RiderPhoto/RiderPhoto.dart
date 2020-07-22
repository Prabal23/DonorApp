import 'dart:convert';
import 'dart:io';
import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/RiderSection/RiderPage/RiderPage.dart';
import 'package:design_app/main.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderPhoto extends StatefulWidget {
  final pickingList;
  RiderPhoto(this.pickingList);
  @override
  _RiderPhotoState createState() => _RiderPhotoState();
}

class _RiderPhotoState extends State<RiderPhoto> {
  TextEditingController shareController = TextEditingController();
  File _image;
  bool _isImage = false;
  int imgPercent = 1;
  List imgList = [];
  var _showImage;
  bool isLoading = false;
  bool _isCancelImg = false;
  CancelToken token = CancelToken();
  var dio = new Dio();

  String fullUrl, mainUrl;
  String tryUrl;

  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  var donationId = '';
  var userToken = '';

  @override
  void initState() {
    donationId =
        widget.pickingList.id == null ? "" : "${widget.pickingList.id}";
    print('donationId');
    print(donationId);
    _getUserInfo();
    postPicData();
    super.initState();
  }

  postPicData() async {
    var apiUrl = '/app/RiderUploadImg';
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
      // var userinfoList = json.decode(user);
      // donerId = userinfoList['id'];
      userToken = token;
      print('userToken');
      print(userToken);
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
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
          '$tryUrl',//'http://test.appifylab.com/app/RiderUploadImg',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: Text(
            'RIDER',
            style: TextStyle(
                color: appColor,
                fontFamily: "Roboto-Bold",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///////////////////// pick images//////////

                /////////////// image part 1//////////
                _isImage
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          imgPercent == 100
                              ? '.... loading picture'
                              : '$imgPercent % loading',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: featureImage(_image)),

                ////////////// Donate button ////////
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      ///  showMsg();
                      takeIt();

                      // Navigator.push(
                      //      context, SlideLeftRoute(page: Picked()));
                    },
                    color: appColor,
                    child: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        'Done',
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
            ),
          ),
        ),
      ),
    );
  }

  Future<void> takeIt() async {
    if (_showImage == null || _showImage == '') {
      return _showMessage('Take a picture of the donation');
    }

    setState(() {
      isLoading = true;
    });

    var items = {
      "status": "Taken",
      "image": _showImage,
    };

    print(items);

    var res = await CallApi().postData(
        items, '/app/riderAddImageforDonation/$donationId?token=$userToken');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      // sendSOS();
      showMsg(body['message'].toString());
    }
    // else showMsg(body['errors'].toString());

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

  void showMsg(String msg) {
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
                  msg, //"Item is now assigned to you",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 112, 112, 112)),
                  textAlign: TextAlign.center,
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, SlideLeftRoute(page: RiderPage()));
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

  Container featureImage(File img) {
    return Container(
      // margin: EdgeInsets.only(,
      child: img == null
          ?
          // ? _isImage
          //     ? Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: <Widget>[
          //           Container(
          //             height: MediaQuery.of(context).size.height / 2,
          //             margin: EdgeInsets.only(top: 20),
          //             child: DottedBorder(
          //               color: Colors.black,
          //               radius: Radius.circular(60),
          //               strokeWidth: 1,
          //               child: Container(
          //                 alignment: Alignment.center,
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: <Widget>[
          //                     Container(
          //                       child: IconButton(
          //                           icon: Icon(Icons.file_upload,
          //                               color: Color(0xFF8A8A8A)),
          //                           onPressed: () {
          //                             cancelImg();
          //                           }),
          //                     ),
          //                     Container(
          //                       padding: EdgeInsets.only(bottom: 12),
          //                       child: Text(
          //                         'Picture Taking',
          //                         style: TextStyle(
          //                           color: Theme.of(context).accentColor,
          //                           fontSize: 16.0,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //     :
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  margin: EdgeInsets.only(top: 20),
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
                              onPressed: getImage,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Picture Taking',
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
          // Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: <Widget>[
          //       Container(
          //         height: MediaQuery.of(context).size.height / 2,
          //         margin: EdgeInsets.only(top: 20),
          //         child: DottedBorder(
          //           color: Colors.black,
          //           radius: Radius.circular(60),
          //           strokeWidth: 1,
          //           child: Container(
          //             alignment: Alignment.center,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: <Widget>[
          //                 Container(
          //                   child: IconButton(
          //                       icon: Icon(Icons.file_upload,
          //                           color: Color(0xFF8A8A8A)),
          //                       onPressed: getImage),
          //                 ),
          //                 Container(
          //                   padding: EdgeInsets.only(bottom: 12),
          //                   child: Text(
          //                     'Picture Taking',
          //                     style: TextStyle(
          //                       color: Theme.of(context).accentColor,
          //                       fontSize: 16.0,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   )
          : Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: getImage,
                    child: Image.file(img,
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
    );
  }
}
