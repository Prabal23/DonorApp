import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/BeneficiarySection/Beneficiary/Beneficiary.dart';
import 'package:design_app/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorThanks extends StatefulWidget {
  final donorList;
  final incidentList;
  DonorThanks(this.donorList, this.incidentList);

  @override
  _DonorThanksState createState() => _DonorThanksState();
}

class _DonorThanksState extends State<DonorThanks> {
  TextEditingController shareController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  var userToken = "";
  bool _isImage = false;
  bool _isLoading = false;
  int imgPercent = 1;
  List imgList = [];
  File _image;
  bool _isDonerNull = false;
  var donerId = '';
  var donationId = '';
  var status = '';
  List<String> photos = [];

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    setState(() {
      shareController.text = widget.donorList.shareMessage;
      // if(widget.donorList.doner == null)
      // {
      //   _isDonerNull = true;
      // }
      print('ddd');
      print(widget.donorList.donerId);
    });
    donerId = widget.donorList.donerId == null? "": "${widget.donorList.donerId}";
    donationId = widget.donorList.id == null? "": "${widget.donorList.id}";
    status = widget.donorList.status == null? "": "${widget.donorList.status}";
    print('status');
    print(status);
    _getUserInfo();
    photoList();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user = localStorage.getString('user');
    if (token != null ) {
      setState(() {
        userToken = token;
      });
    }
  }

  photoList() {
    for (int i = 0; i < widget.donorList.photo.length; i++) {
      photos.add("${widget.donorList.photo[i].imgUrl}");
    }
    print('photos areeeeeeeeeeee');
    print(photos);
    print(photos.length);
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
            'DONOR',
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
                          widget.donorList.pickupDate == ''
                              ? "N/A"
                              : "${widget.donorList.pickupDate}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF8A8A8A),
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        color: appColor,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
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
                          widget.donorList.pickupTime == ''
                              ? "N/A"
                              : "${widget.donorList.pickupTime}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF8A8A8A),
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        color: appColor,
                        child: Icon(
                          Icons.watch_later,
                          color: Colors.white,
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
                              'What to share',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            )),
                        Container(
                            //height: 100,
                            margin: EdgeInsets.only(left: 8, top: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white,
                                border: Border.all(width: 1, color: appColor)),
                            child: TextField(
                              enabled: false,
                              maxLines: 100,
                              minLines: 1,
                              cursorColor: Colors.grey,
                              controller: shareController,
                              keyboardType: TextInputType.text,
                              // textCapitalization: TextCapitalization.words,
                              // autofocus: true,
                              style: TextStyle(color: Colors.grey[600]),
                              decoration: InputDecoration(
                                //hintText: hint,
                                // labelText: label,
                                // labelStyle: TextStyle(color: appColor),
                                contentPadding:
                                    EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 40.0),
                                border: InputBorder.none,
                              ),
                            )),
                      ],
                    )),

                 ////////////  Featured Image /////////////
                ///
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: Text(
                      'Feature Image',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: appColor,
                          fontFamily: "Roboto-Regular",
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    )),

                /////////////////// pick images//////////

                ///////////// image part 1//////////
                Container(
                    height: 150,
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 30, right: 40, top: 5),
                    child:
                    //  photos == null? Center(child: CircularProgressIndicator())
                    // :
                    // photos.length == 0
                    //     ?
                    photos.length == 0 || photos == null
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

                ////////////// Donate button ////////
                status == 'Taken'?
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
                      //DonorThanks.dartshowMsg();
                      sendThanks();

                      // Navigator.push(
                      //      context, SlideLeftRoute(page: RiderPage()));
                    },
                    color: _isLoading ? Colors.grey : appColor,
                    child: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        _isLoading ? 'Please wait...' : 'Send Thanks',
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
                :
                Container(
                  // color: Colors.red,
                  // height: 100,
                  margin:
                      EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendThanks() async {
    setState(() {
      _isLoading = true;
    });

    var items = {
      //"from_beneficier_id ": widget.incidentList.beneficiarId,
      // "token ": userToken,
      "to_doner_id": donerId,
      "donationId": donationId,
      "message": "Thanks",
    };

    var res = await CallApi().postData(items, '/app/giveThanks?token=$userToken');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      showMsg('Message sent !');
    } else if (res.statusCode == 400){
      showMsg(body['message'].toString());
    }

    print(items);

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
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 13.0);
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

  void showMsg(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  msg,// "Message sent!",
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
                              builder: (context) => Beneficiary()));
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
                        'OK',
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
