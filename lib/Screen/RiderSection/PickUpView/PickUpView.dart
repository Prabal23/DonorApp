import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/RiderSection/Picked/Picked.dart';
import 'package:design_app/Screen/RiderSection/RiderPage/RiderPage.dart';
import 'package:design_app/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickUpView extends StatefulWidget {
  final pickingList;
  final value;
  PickUpView(this.pickingList, this.value);
  @override
  _PickUpViewState createState() => _PickUpViewState();
}

class _PickUpViewState extends State<PickUpView> {
  TextEditingController shareController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  var donationId = '';
  var status = '';
  List<String> photos = [];
  bool isLoading = false;
  var userToken = '';

  double riderLat;
  double riderLan;
  // var value;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    date = widget.pickingList.pickupDate == null? "": "${widget.pickingList.pickupDate}";
    time = widget.pickingList.pickupTime == null? "": "${widget.pickingList.pickupTime}";
    donationId = widget.pickingList.id == null? "": "${widget.pickingList.id}";
    status = widget.pickingList.status == null? "": "${widget.pickingList.status}";
    print('donationId');
    print(donationId);
    photoList();
    _getUserInfo();
    //_myLocation();
    super.initState();
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

  photoList() {
    for (int i = 0; i < widget.pickingList.photo.length; i++) {
      photos.add("${widget.pickingList.photo[i].imgUrl}");
    }
    print('photos areeeeeeeeeeee');
    print(photos);
    print(photos.length);
  }

  // void _myLocation() async {
  //  // controller = await _controller.future;

    // LocationData currentLocation;
    // var location = Location();
    // try {
    //   currentLocation = await location.getLocation();
    //   // print("currentLocation ;lkjg df;gj dgj ldgj lgjl dgjd gj");
    //   // print(currentLocation);
    //   // Fluttertoast.showToast(
    //   //     msg: "$currentLocation",
    //   //     //toastLength: Toast.LENGTH_SHORT,
    //   //     gravity: ToastGravity.CENTER,
    //   //     timeInSecForIos: 1,
    //   //     backgroundColor: Colors.red,
    //   //     textColor: Colors.white,
    //   //     fontSize: 16.0);
    // } on Exception {
    //   currentLocation = null;
    // }

    // setState(() {
    //   // riderLat = currentLocation.latitude;
    //   // riderLan = currentLocation.longitude;
    //   value = {
    //     "lat": currentLocation.latitude,
    //     "lan": currentLocation.longitude,
    //   };
    // });
    // }

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
            'Pickup-view',
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
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///////// text top1//////////
                // Container(
                //   margin: EdgeInsets.only(top: 30),
                //   child: Row(
                //     children: <Widget>[
                //       Container(
                //         width: MediaQuery.of(context).size.width / 4,
                //         margin: EdgeInsets.only(
                //           left: 20,
                //         ),
                //         child: Text(
                //           'Rider:',
                //           style: TextStyle(
                //               color: appColor,
                //               fontFamily: "Roboto-Regular",
                //               fontSize: 16,
                //               fontWeight: FontWeight.normal),
                //         ),
                //       ),
                //       Container(
                //        // margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'David Ron',
                //           style: TextStyle(
                //               color: appColor,
                //               fontFamily: "Roboto-Bold",
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                ///////// text top2//////////
                // Container(
                //   margin: EdgeInsets.only(top: 15),
                //   child: Row(
                //     children: <Widget>[
                //       Container(
                //         width: MediaQuery.of(context).size.width / 4,
                //         margin: EdgeInsets.only(
                //           left: 20,
                //         ),
                //         child: Text(
                //           'Status:',
                //           style: TextStyle(
                //               color: appColor,
                //               fontFamily: "Roboto-Regular",
                //               fontSize: 16,
                //               fontWeight: FontWeight.normal),
                //         ),
                //       ),
                //       Container(
                //         //margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           widget.pickingList.status == null
                //               ? "- - -"
                //               : "${widget.pickingList.status}",//'Pending',
                //           style: TextStyle(
                //               color: Color(0xFFEC4647),
                //               fontFamily: "Roboto-Bold",
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                /////////////////  pick up date //////////
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20, top: 20),
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
                          date.toString(),
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
                            // setState(() {
                            //   _selectDate(context);
                            //   //_showDate();
                            // });
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
                          time.toString(),
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
                            // setState(() {
                            //   _selectedTime(context);
                            //   //_showDate();
                            // });
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
                    padding:
                        EdgeInsets.only(left: 10, right: 15, top: 5, bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 10, bottom: 8),
                            child: Text(
                              'Pickup Details : ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            )),
                        Container(
                           // height: 100,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 8, top: 10),
                            padding: EdgeInsets.fromLTRB(12, 20, 8, 30),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white,
                                border: Border.all(width: 1, color: appColor)),
                                child: Text(
                              widget.pickingList.shareMessage == null
                                  ? "- - -"
                                  : "${widget.pickingList.shareMessage}", //'data',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            )
                            // child: TextField(
                            //   cursorColor: Colors.grey,
                            //   controller: shareController,
                            //   keyboardType: TextInputType.text,
                            //   // textCapitalization: TextCapitalization.words,
                            //   // autofocus: true,
                            //   style: TextStyle(color: Colors.grey[600]),
                            //   decoration: InputDecoration(
                            //     //hintText: hint,
                            //     // labelText: label,
                            //     // labelStyle: TextStyle(color: appColor),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                            //     border: InputBorder.none,
                            //   ),
                            // )
                            ),
                      ],
                    )),

                ////////////  Featured Image /////////////
                ///
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, top: 10),
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

                /////////////// image part 1//////////
                Container(
                    height: 150,
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 30, right: 40, top: 5),
                    child: photos.length == 0 || photos == null
                        ?
                        Center(
                            child: Container(
                                alignment: Alignment.center,
                                height: 100,
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/image/photo_placeholder.png',
                                      height: 70,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("No image found for this donation!"),
                                    ),
                                  ],
                                )))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            //shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Image.network(
                                      photos[index],
                                      height: 50,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )),
                            itemCount: photos.length,
                          )),
                /////////////// image part 1//////////
                // Container(
                //   margin: EdgeInsets.only(left: 20, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       featureImage(_image, "photo 4"),
                //       featureImage(_image, "photo 5"),
                //       featureImage(_image, "photo 6"),
                //     ],
                //   ),
                // ),

                ///////////// location details //////////

                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SlideLeftRoute(page: Picked(widget.pickingList, widget.value)));
                  },
                  child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 20, top: 30),
                      child: Text(
                        'Location Details',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "Roboto-Regular",
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )),
                ),
                ////////////// Donate button ////////
                status == 'Picked' || status == 'Taken'? Container(
                  margin:
                      EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),)
                  : 
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
                        //(isLoading || status == 'Picked' || status == 'Taken')? null : recieveRequest();
                        isLoading ? null : recieveRequest();

                      // Navigator.push(
                      //      context, SlideLeftRoute(page: Picked()));
                    },
                    color: appColor,
                    child: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        isLoading? 'Picking..' : 'I will pick',
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

  Future<void> recieveRequest() async {

    setState(() {
      isLoading = true;
    });

    var items = {
      "status": "Picked",
    };

    print(items);

    var res = await CallApi().postData(items, '/app/addRiderforDonation/$donationId?token=$userToken');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      // sendSOS();
      showMsg(body['message'].toString());
    }

    print(items);

    setState(() {
      isLoading = false;
    });
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
                  "Success",
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
}
