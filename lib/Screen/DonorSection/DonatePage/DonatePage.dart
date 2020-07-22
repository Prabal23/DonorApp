import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/DonorSection/DonorIncidentPage/DonorIncidentPage.dart';
import 'package:design_app/main.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

class DonatePage extends StatefulWidget {
  final incidentList;
  DonatePage(this.incidentList);
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
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

  double donarLat;
  double donarLng;
  int incidentId = 0;
  int donarId = 0;

  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";

  String address = "";
  var collection;

  String fullUrl, mainUrl;
  String tryUrl;

  @override
  void initState() {
    var location = new Location();

    location.onLocationChanged().listen((LocationData currentLocation) {
      if (this.mounted) {
        setState(() {
          donarLat = currentLocation.latitude;
          donarLng = currentLocation.longitude;

          print("currentLocation.latitude");
          print(donarLat);
          print("currentLocation.longitude");
          print(donarLng);
        });
      }
      _myLocation(donarLat,donarLng);
    });
    _getUserInfo();
    postPicData();

    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    incidentId = widget.incidentList.id;
    print('incidentId');
    print(incidentId);
    super.initState();
  }

  postPicData() async {
    var apiUrl = '/app/DonationImgUpload';
    mainUrl = await CallApi().getUrl();
    fullUrl = await CallApi().getUrl() + apiUrl;
    tryUrl = fullUrl;
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    print("full url is : $tryUrl");
    return fullUrl;
  }


  void _myLocation(double lat, double lan) async {

    LocationData currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      //
    } on Exception {
      currentLocation = null;
    }

    // setState(() {
    //   lat = currentLocation.latitude;
    //   lan = currentLocation.longitude;
    // });

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lan&key=AIzaSyAiXNjJ3WpC-U-NKUPY66eQK471y1CiWTY";
    print(url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    collection = json.decode(response.body);
    print("collection['plus_code']");
    //print(collection['plus_code']['compound_code']);
    address = collection['results'][0]['formatted_address'];

    print(address);
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("yyyy-MM-dd").format(selectedDate)}";
      });
  }

  TimeOfDay _time = new TimeOfDay.now();
  String time = "";

  TimeOfDay _timePicked;
  Future<Null> _selectedTime(BuildContext context) async {
    _timePicked = await showTimePicker(context: context, initialTime: _time);

    if (_timePicked != null) {
      setState(() {
        _time = _timePicked;
        time = _time.toString().substring(10, 15);
        // print(_time.toString().substring(10, 15));

        // time =TimeOfDay.fromDateTime(DateTime.parse(_time));//"${DateFormat("HH:mm").format(_time)}";
      });
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
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
          '$tryUrl',//'http://test.appifylab.com/app/DonationImgUpload',
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

        imgList.add({'imgUrl': response.data['imgUrl']});
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

  void _deleteImg(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to remove this?",
            // textAlign: TextAlign.,
            style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "grapheinpro-black",
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
              height: 70,
              width: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 25,
                          bottom: 15,
                        ),
                        child: OutlineButton(
                          child: new Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(top: 25, bottom: 15),
                        child: OutlineButton(
                            // color: Colors.greenAccent[400],
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              imgList.removeAt(index);
                              setState(() {});
                              Navigator.pop(context);
                              // _deleteOrders();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

  void cancelImg() async {
    print("object");

    // token.cancel("cancelled");

    //     Response response;
    // try {
    //   response=await dio.get('https://admin.bahrainunique.com/app/upload', cancelToken: token);
    //   print(response);
    // }catch (e){
    //   if (CancelToken.isCancel(e)) {
    //     print(' $e');
    //   }
    // }

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
            'DONATE-ADD',
            style: TextStyle(
                color: appColor,
                fontFamily: "Roboto-Bold",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        //               actions: <Widget>[
        //  Container(
        //                     margin: EdgeInsets.only(right: 20, top: 10),
        //                     decoration:
        //                         BoxDecoration(color: appColor, shape: BoxShape.circle),
        //                     child: IconButton(
        //                       icon: Icon(
        //                         Icons.add,
        //                         color: Colors.white,
        //                         size: 25,
        //                       ),
        //                       onPressed: () {
        //                         Navigator.push(
        //                             context, SlideLeftRoute(page: Beneficiary()));
        //                                                     },
        //                                                   ),
        //                                                 )
        //                                             ],
      ),
      body: SafeArea(
        child: CustomScrollView(physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /////////////////  pick up date //////////
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20, top: 30),
                    child: Text(
                      'Pickup Date',
                      style: TextStyle(
                          color: appColor,
                          fontFamily: "Roboto-Regular",
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),

                  /////////////////// date picker field /////////////

                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //color: Colors.white,
                        border: Border.all(width: 1, color: appColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            date,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontFamily: "Roboto-Regular",
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          color: appColor,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _selectDate(context);
                                //_showDate();
                              });
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////////////  pick up time ////////////
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      'Pickup Time',
                      style: TextStyle(
                          color: appColor,
                          fontFamily: "Roboto-Regular",
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),

                  /////////////////// time picker field /////////////

                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //color: Colors.white,
                        border: Border.all(width: 1, color: appColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            time,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontFamily: "Roboto-Regular",
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          color: appColor,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedTime(context);
                                //_showDate();
                              });
                            },
                            icon: Icon(
                              Icons.watch_later,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /////////////   what to share /////////

                  Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(
                          left: 10, right: 15, top: 5, bottom: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 10, bottom: 8),
                              child: Text(
                                'What to share',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: appColor,
                                    fontFamily: "Roboto-Regular",
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )),
                          Container(
                             // height: 100,
                              padding: EdgeInsets.only(top: 10, bottom: 30),
                              margin: EdgeInsets.only(left: 8, top: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: appColor)),
                              child: TextField(
                                cursorColor: Colors.grey,
                                controller: shareController,
                                keyboardType: TextInputType.text,
                                maxLines: 100,
                                minLines: 1,
                                // textCapitalization: TextCapitalization.words,
                                // autofocus: true,
                                style: TextStyle(color: Colors.grey[600]),
                                decoration: InputDecoration(
                                  //hintText: hint,
                                  // labelText: label,
                                  // labelStyle: TextStyle(color: appColor),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 20.0, 15.0),
                                  border: InputBorder.none,
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            ),
          ), /////
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                ////////////  Featured Image /////////////
                ///
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, top: 15, bottom: 20),
                    child: Text(
                      'Feature Image',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: appColor,
                          fontFamily: "Roboto-Regular",
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    )),

                ///////////////////// pick images//////////
                _isImage
                    ? Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              cancelImg();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey.withOpacity(0.2),
                              child: Center(
                                child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("$imgPercent % loading..",
                                            style: TextStyle(fontSize: 15)),
                                        Text("Cancel Upload",
                                            style: TextStyle(fontSize: 15)),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey.withOpacity(0.2),
                              child: Container(
                                  child: Icon(
                                Icons.photo_camera,
                                size: 30,
                              )),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10),
            sliver: Container(
              //color: Colors.redAccent,
              child: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return
                        // _isImage
                        //     ? Container(
                        //         padding: const EdgeInsets.all(12.0),
                        //         margin: EdgeInsets.only(top: 20),
                        //         decoration: BoxDecoration(
                        //             shape: BoxShape.circle,
                        //             border:
                        //                 Border.all(color: appColor, width: 2)),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(12.0),
                        //           child: Text(imgPercent.toString() + "%"),
                        //         ))
                        //     //  Padding(
                        //     //     padding: const EdgeInsets.all(8.0),
                        //     //     child: Center(
                        //     //       child: CircularProgressIndicator(),
                        //     //     ))
                        //     :
                        imgList.length == 0
                            ? Container()
                            : Container(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 12),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            shape: BoxShape.rectangle),
                                        child: Container(
                                          child: Image.network(
                                            // 'assets/images/camera.jpg',
                                                imgList[index]['imgUrl'],
                                            height: 80,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 100, right: 20),
                                            width: 100,
                                            child: Text(
                                              "Photo ${index + 1}",
                                              textAlign: TextAlign.center,
                                            ))),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.5),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      //   alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _deleteImg(index);
                                          // imgList.removeAt(index);
                                          // setState(() {}
                                          // );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                  },
                  childCount: imgList.length,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 170.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: 1.0,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              ////////////// Donate button ////////
              child: Container(
            width: MediaQuery.of(context).size.width,
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
              // child: Column(
              //   children: <Widget>[
              //     Container(
              //       width: MediaQuery.of(context).size.width,
              //       padding: EdgeInsets.only(top: 43),
              //       child: RaisedButton(
              //         onPressed: () {
              //           checkSOS();
              //         },
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5.0),
              //         ),
              //         color: isLoading
              //             ? Colors.grey
              //             : Theme.of(context).primaryColor,
              //         elevation: 3.0,
              //         child: Padding(
              //           padding: const EdgeInsets.all(15.0),
              //           child: Text(
              //             isLoading ? 'Please Wait...' : 'Send SOS',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 20.0,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              )
        ]),
      ),
    );
  }

  Container featureImage(File img, String label) {
    return Container(
      // margin: EdgeInsets.only(,
      child: img == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: DottedBorder(
                    color: Colors.black,
                    radius: Radius.circular(60),
                    strokeWidth: 1,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 25, right: 25, top: 8, bottom: 8),
                      child: IconButton(
                          icon: Icon(Icons.photo, color: Color(0xFF8A8A8A)),
                          onPressed: getImage),
                    ),
                  ),
                ),
                Container(
                  //alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Text(
                    label,
                    //  textAlign: TextAlign.center,
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto-Regular",
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                )
              ],
            )
          : Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Image.file(img,
                      height: 80, width: 100, fit: BoxFit.contain),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto-Regular",
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
    );
  }

  Future<void> checkSOS() async {
    if (date == "") {
      return _showMessage("Date field is empty");
    } else if (time == "") {
      return _showMessage("Time field is empty");
    } else if (shareController.text == "") {
      return _showMessage("Share field is empty");
    }

    setState(() {
      isLoading = true;
    });

    var items = {
      "pickupDate": date,
      "pickupTime": time,
      "incidentId": incidentId,
      "donerId": donarId,
      "lat": donarLat,
      "lng": donarLng,
      "address": address,
      "shareMessage": shareController.text,
      "status": 'Pending',
      "imgUrl": imgList,
    };

    print(items);

    var res = await CallApi().postData(items, '/app/addDonation');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      // sendSOS();
      showMsg();
      date = '';
      time = '';
      shareController.text = '';
      imgList = [];
    }

    print(items);

    setState(() {
      isLoading = false;
    });
  }
  //SelectableText

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

