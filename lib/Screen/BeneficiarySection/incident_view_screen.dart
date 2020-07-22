import 'dart:async';
import 'dart:convert';
import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'DonorThanks/DonorThanks.dart';

class IncidentViewScreen extends StatefulWidget {
  final donorList;
  final incidentList;
  IncidentViewScreen(this.donorList, this.incidentList);

  @override
  _IncidentViewScreenState createState() => _IncidentViewScreenState();
}

class _IncidentViewScreenState extends State<IncidentViewScreen> {
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";
  String _value;
  double lat;
  double lan;
  String address = "";
  var collection;
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController addController = new TextEditingController();
  TextEditingController sitController = new TextEditingController();
  TextEditingController msgController = new TextEditingController();
  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();
  CameraPosition _initialPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _myLocation(double lat, double lan) async {
    controller = await _controller.future;

    LocationData currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      // print("currentLocation ;lkjg df;gj dgj ldgj lgjl dgjd gj");
      // print(currentLocation);
      // Fluttertoast.showToast(
      //     msg: "$currentLocation",
      //     //toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIos: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
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
    // if (collection['results'].length == null) {
    // setState(() {
    //   address = collection['results'][0]['formatted_address'];
    //   addController.text = address;
    // });
    // moveCamera();
    //var addressData = SearchAddressModel.fromJson(collection);
    // latitude = 24.9112692;
    // longitude = 91.8499715;

    //var coordinates = new Coordinates(latitude, longitude);
    //addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // first = addresses.first;

    //});
    // }
  }

  void moveCamera() {
    //controller.moveCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lan), 17));
    //controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lan), 17));
    //setState(() {
    //myAddress = first.addressLine;
    //_markers.clear();
    //   controller.animateCamera(
    //  CameraUpdate.newCameraPosition(
    //   CameraPosition(target: LatLng(lat, lan), zoom: 17),
    // ),
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

  @override
  void initState() {
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    setState(() {
      // lat = widget.donorList.doner.lat == null ? lat : double.parse(widget.donorList.doner.lat);
      // lan = widget.donorList.doner.lng == null ? lan : double.parse(widget.donorList.doner.lng);
      lat = double.parse(widget.donorList.doner.lat);
      lan = double.parse(widget.donorList.doner.lng);
      msgController.text = widget.donorList.shareMessage;
    });
    _myLocation(lat, lan);
    moveCamera();
    _initialPosition = CameraPosition(target: LatLng(lat, lan), zoom: 14);
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
  ////// <<<<< Time Picker start>>>>> //////
  // TimeOfDay _time = TimeOfDay.now();
  // TimeOfDay picked;
  // var timeTextController = new TextEditingController();

  // Future<Null> selectTime(BuildContext context) async {
  //   picked = await showTimePicker(
  //     context: context,
  //     initialTime: _time,
  //   );
  //   if(picked != null && picked != _time){
  //   setState(() {
  //     _time = picked;
  //   });
  //   }
  // }
  ////// <<<<< Time Picker end >>>>> //////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'INCIDENT-VIEW',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(top: 20, left: 20.0, right: 20.0, bottom: 20.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Text(
                        'Sent By: ',
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
                          widget.donorList.doner == null
                              ? "No donor yet"
                              : "${widget.donorList.doner.name}",
                          //'${widget.donorList.doner.name}',
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
                              : "${widget.donorList.rider.name}",
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        widget.donorList.status == ''
                            ? "Pending"
                            : "${widget.donorList.status}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 236, 70, 71),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height/1.8,
                  margin: EdgeInsets.only(top: 20),
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
                Text(
                  'What to receive?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: msgController,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: null,
                    enabled: false,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.all(15.0),
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
                Container(
                  padding: EdgeInsets.only(top: 43),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: DonorThanks(
                                  widget.donorList, widget.incidentList)));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'More',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
