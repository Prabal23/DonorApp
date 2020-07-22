import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/DonorSection/DonatePage/DonatePage.dart';
import 'package:design_app/Screen/DonorSection/SendMoney/SendMoney.dart';
import 'package:design_app/Screen/PublicReporterSection/PreviewImage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DonateAddCompose extends StatefulWidget {
  final incidentList;
  DonateAddCompose(this.incidentList);
  @override
  _DonateAddComposeState createState() => _DonateAddComposeState();
}

class _DonateAddComposeState extends State<DonateAddCompose> {
  String formattedTime;
  List<String> photos = [];
  double lat;
  double lan;
  var paymayaNumber = 'hg';
  var gCashNumber;

  String address = "";
  var collection;
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController addController = new TextEditingController();
  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025));


  @override
  void initState() {
    todayDate();
    photoList();
    setState(() {
      lat = double.parse(widget.incidentList.lat);
      lan = double.parse(widget.incidentList.lng);
      addController.text = widget.incidentList.address;
      print('lat');
      print(lat);
      print(addController.text);
    });

    paymayaNumber = (widget.incidentList.beneficiar.paymaya == null)
                    ? "---"
                    : "${widget.incidentList.beneficiar.paymaya}";
    gCashNumber = (widget.incidentList.beneficiar.gcash == null)
                    ? "---"
                    : "${widget.incidentList.beneficiar.gcash}";
    _myLocation(lat, lan);
    moveCamera();
    _initialPosition = CameraPosition(target: LatLng(lat, lan), zoom: 14);
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _myLocation(double lat, double lan) async {
    controller = await _controller.future;

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
    setState(() {
      address = collection['results'][0]['formatted_address'];
      //addController.text = address;
    });
    // moveCamera();
  }

  void moveCamera() {
    _markers.add(
      Marker(
        markerId: MarkerId('locationId'),
        position: LatLng(lat, lan),
        // infoWindow: InfoWindow(title: "$latitude"),
      ),
    );
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );


  todayDate() {
    var dateTime = DateTime.parse("${widget.incidentList.created_at}");
    formattedTime = DateFormat('EEE, MMM d, yyyy').format(dateTime);
    print(formattedTime);
    print(dateTime);
  }

  photoList() {
    for (int i = 0; i < widget.incidentList.photo.length; i++) {
      photos.add("${widget.incidentList.photo[i].imgUrl}");
    }
    print(photos.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /////// appbar ///////

                // Row(
                //   children: <Widget>[
                //     /////////  back button ////////
                //     IconButton(
                //       icon: Icon(Icons.arrow_back, color: appColor),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),

                //     ///////  title /////////
                //     Container(
                //       margin: EdgeInsets.only(left: 10),
                //       child: Text(
                //         'DONATE-ADD',
                //         style: TextStyle(
                //             color: appColor,
                //             fontFamily: "Roboto-Bold",
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     )
                //   ],
                // ),

                ///////// text top1//////////
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'What : ',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Regular",
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.incidentList.situation == null
                                ? ""
                                : "${widget.incidentList.situation.situation}", //'Fire Alarm',
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Bold",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///////// text top2//////////
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Beneficiary : ',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Regular",
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            //'Jos Wen',
                            widget.incidentList.beneficiar.name == null
                                ? ""
                                : "${widget.incidentList.beneficiar.name}",
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Bold",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                   ///// Adresss ///////////////////
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Address : ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.0,
                        ),
                      ),
              ),
              Expanded(
                  child: Container(
                    //  height: 45.0,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(bottom: 17.0),
                    child: TextField(
                      controller: addController,
                      minLines: 1,
                      maxLines: 30,
                      enabled: false,
                      decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
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
              ),
                    ],
                  ),
                ),
              ///////// Mobile number ////////////////
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Mobile Number  : ',
                          style: TextStyle(
                              color: appColor,
                              // fontFamily: "Roboto-Regular",
                              fontSize: 17,
                              // fontWeight: FontWeight.normal
                              ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            //'Jos Wen',
                            widget.incidentList.beneficiar.mobileNumber == null
                                ? ""
                                : "${widget.incidentList.beneficiar.mobileNumber}",
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Bold",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///////// Paymaya number ////////////////
              Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Paymaya Number  : ',
                          style: TextStyle(
                              color: appColor,
                             // fontFamily: "Roboto-Regular",
                              fontSize: 17,
                              // fontWeight: FontWeight.normal
                              ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child: GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(new ClipboardData(text: paymayaNumber,));
                              _showMessage('Copied to clipboard');
                            },
                            child: Text(
                              "$paymayaNumber",//'Jos Wen',
                              // widget.incidentList.beneficiar.paymaya == null
                              //     ? "---"
                              //     : "${widget.incidentList.beneficiar.paymaya}",
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///////// GCash number ////////////////
              Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'GCash Number      :  ',
                          style: TextStyle(
                              color: appColor,
                             // fontFamily: "Roboto-Regular",
                              fontSize: 17,
                              // fontWeight: FontWeight.normal
                              ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child: GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(new ClipboardData(text: gCashNumber,));
                              _showMessage('Copied to clipboard');
                            },
                            child: Text(
                              '$gCashNumber',//'Jos Wen',
                              // widget.incidentList.beneficiar.gcash == null
                              //     ? "---"
                              //     : "${widget.incidentList.beneficiar.gcash}",
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  height: 200,
                  child: GoogleMap(
                    // myLocationEnabled: true,
                    //myLocationEnabled: true,
                    markers: _markers,
                    mapType: MapType.normal,
                    // myLocationEnabled: true,
                    // myLocationButtonEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    gestureRecognizers: Set()
                      ..add(Factory<PanGestureRecognizer>(
                          () => PanGestureRecognizer()))
                      ..add(
                        Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer()),
                      )
                      ..add(
                        Factory<HorizontalDragGestureRecognizer>(
                            () => HorizontalDragGestureRecognizer()),
                      )
                      ..add(
                        Factory<ScaleGestureRecognizer>(
                            () => ScaleGestureRecognizer()),
                      )),
                ),

                Container(
                    height: 150,
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
                    child: photos.length == 0
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
                                      child: Text("No image found for this incident!"),
                                    ),
                                  ],
                                )))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            //shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                          return PreviewImage(photos[index]);
                                        }));
                                     // Navigator.push(context,
                                         // SlideLeftRoute(page: PreviewVideo(photos[index])));
                                        },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 12),
                                      child: Image.network(
                                        photos[index],
                                        height: 50,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                            itemCount: photos.length,
                          )),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10, left: 0),
                  child: Text(
                    'Situations Reports',
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto-Bold",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10, left: 0),
                  child: Text(
                    '$formattedTime', //'Monday 14 April 2019',
                    style: TextStyle(
                        color: Color(0xFF272020),
                        fontFamily: "Roboto-Regular",
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10, left: 50, right: 50),
                  child: Text(
                    widget.incidentList.messageForDoner == null
                        ? ""
                        : "${widget.incidentList.messageForDoner}",
                    //'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF8A8A8A),
                        fontFamily: "Roboto-Regular",
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                ////////////// compose button ////////
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                        Navigator.push(
                            context, SlideLeftRoute(page: SendMoney(widget.incidentList)));
                    },
                    color: appColor,
                    child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          'Send Money',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto-Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                    ),
                  ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context, SlideLeftRoute(page: DonatePage(widget.incidentList)));
                          },
                          color: appColor,
                          child: Container(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              'Send goods',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
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
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}
