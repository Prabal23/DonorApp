import 'dart:async';
import 'dart:convert';

import 'package:design_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../donate_cancel_screen.dart';
import 'package:http/http.dart' as http;

class DonationViewCardDetails extends StatefulWidget {
  final donorList;
  DonationViewCardDetails(this.donorList);
  @override
  _DonationViewCardDetailsState createState() =>
      _DonationViewCardDetailsState();
}

class _DonationViewCardDetailsState extends State<DonationViewCardDetails> {
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  double lat;
  double lan;

  String address = "";
  var collection;
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController addController = new TextEditingController();
  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025));

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
    // print("collection['plus_code']");
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

  @override
  void initState() {
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    date = widget.donorList.pickupDate == null
        ? ""
        : "${widget.donorList.pickupDate}";
    time = widget.donorList.pickupTime == null
        ? ""
        : "${widget.donorList.pickupTime}";
    setState(() {
      lat = double.parse(widget.donorList.lat);
      lan = double.parse(widget.donorList.lng);
    });
    _myLocation(lat, lan);
    moveCamera();
    _initialPosition = CameraPosition(target: LatLng(lat, lan), zoom: 14);
    // incidentId = widget.donorList.incidentId == null ? "" : '${widget.donorList.incidentId}';
    super.initState();
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
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     elevation: 0,
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back),
    //       color: Theme.of(context).primaryColor,
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //     title: Text(
    //       'DONATION-VIEW/EDIT',
    //       style: TextStyle(
    //         color: Theme.of(context).primaryColor,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    //   body:
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(left: 18.0, right: 18.0, bottom: 30.0, top: 30),
        decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white
                            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 26.0, bottom: 10.0),
                  child: Text(
                    'Rider: ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.donorList.rider == null
                          ? "No rider yet"
                          : "${widget.donorList.rider.name}", //'David Ron',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 17.0, bottom: 10.0),
                  child: Text(
                    'Status: ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.donorList.status == null
                          ? "---"
                          : "${widget.donorList.status}", //'Pending',
                      style: TextStyle(
                        color: Color.fromARGB(255, 236, 70, 71),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
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
            /////////////////  pick up date //////////
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 30),
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
              margin: EdgeInsets.only(top: 20),
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
              margin: EdgeInsets.only(top: 15),
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
              margin: EdgeInsets.only(top: 20, bottom: 20),
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
            Text(
              'What to share?',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.0,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.fromLTRB(12, 20, 8, 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    border: Border.all(width: 1, color: appColor)),
                child: Text(
                  widget.donorList.shareMessage == null
                      ? "- - -"
                      : "${widget.donorList.shareMessage}", //'data',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color(0xFF8A8A8A),
                      fontFamily: "Roboto-Regular",
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                )),
            // Container(
            //   margin: EdgeInsets.only(top: 12),
            //   child: TextField(
            //     keyboardType: TextInputType.multiline,
            //     minLines: 2,
            //     maxLines: null,
            //    // controller: shareController,
            //     decoration: InputDecoration(
            //       // contentPadding: EdgeInsets.all(15.0),
            //       hintText: widget.donorList.shareMessage == null
            //         ? "- - -"
            //         : "${widget.donorList.shareMessage}",
            //       focusedBorder: OutlineInputBorder(
            //         borderSide:
            //             BorderSide(color: Theme.of(context).primaryColor),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide:
            //             BorderSide(color: Theme.of(context).primaryColor),
            //       ),
            //       disabledBorder: OutlineInputBorder(
            //         borderSide:
            //             BorderSide(color: Theme.of(context).primaryColor),
            //       ),
            //     ),
            //   ),
            // ),
            widget.donorList.status == 'Pending'
                ? Container(
                    padding: EdgeInsets.only(top: 43),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DonateCancelScreen(widget.donorList)),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Cancel donation',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        //  ),
      ),
    );
  }
}
