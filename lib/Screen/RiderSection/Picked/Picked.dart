import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/UpdateQr/UpdateQr.dart';
import 'package:design_app/main.dart';
import 'package:design_app/model/DirectionList/DirectionList.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';


const double CAMERA_ZOOM = 14;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class Picked extends StatefulWidget {
  final pickingList;
  final value;
  Picked(this.pickingList, this.value);
  @override
  _PickedState createState() => _PickedState();
}

class _PickedState extends State<Picked> {
  TextEditingController shareController = TextEditingController();
  // double lat;
  // double lan;

  // double dropLat;
  // double dropLan;

  // var distance = '';
  // var duration = '';
  // var path;
  // var endAddress;
  // var startAddress;

  // String address = "";
  // var collection;
  // GoogleMapController controller;
  // Completer<GoogleMapController> _controller = Completer();
  // TextEditingController addController = new TextEditingController();
  // Set<Marker> _markers = Set();
  // Set<Polyline> _polylines = Set();
  // CameraPosition _initialPosition ;

  // void _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }
  Completer<GoogleMapController> _controller = Completer();
    // this set will hold my markers
    Set<Marker> _markers = {};
    // this will hold the generated polylines
    Set<Polyline> _polylines = {};
    // this will hold each polyline coordinate as Lat and Lng pairs
    List<LatLng> polylineCoordinates = [];
    // this is the key object - the PolylinePoints
    // which generates every polyline between start and finish
    PolylinePoints polylinePoints = PolylinePoints();
    String googleAPIKey = "AIzaSyAiXNjJ3WpC-U-NKUPY66eQK471y1CiWTY";
    // for my custom icons
    BitmapDescriptor sourceIcon;
    BitmapDescriptor destinationIcon;

    double lat;
    double lan;

    double dropLat;
    double dropLan;

    LatLng sOURCELOCATION;
    LatLng dESTLOCATION;

    CameraPosition initialLocation;

  DateTime selectedDate = DateTime.now();
  var format;
  var date = "";

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  // @override
  // void initState() {
  //   format = DateFormat("yyyy-MM-dd").format(selectedDate);
   
  //   setState(() {
  //     // lat = widget.pickingList.rider == null || widget.pickingList.rider.lat == null? 0.0 : double.parse(widget.pickingList.rider.lat);
  //     // lan = widget.pickingList.rider == null || widget.pickingList.rider.lng == null? 0.0 : double.parse(widget.pickingList.rider.lng);
  //     lat = double.parse('23.8136396');
  //     lan = double.parse('90.4041637');
  //     dropLat = widget.pickingList.doner == null || widget.pickingList.doner.lat == null? 0.0 : double.parse(widget.pickingList.doner.lat);
  //     dropLan = widget.pickingList.doner == null || widget.pickingList.doner.lng == null? 0.0 : double.parse(widget.pickingList.doner.lng);
  //     print('lat');
  //     print(lat);
  //     print('dropLat');
  //     print(dropLat);
  //     _initialPosition =
  //     CameraPosition(target: LatLng(lat, lan), zoom: 14.5);
  //   });
  //   riderLocation();
  //   dropLocation();
  //   super.initState();
  // }

  @override
    void initState() {
      super.initState();
      // lat = widget.value['lat'];//double.parse('23.8136396');
      // lan = widget.value['lan'];//double.parse('90.4041637');
      lat = widget.pickingList.rider == null || widget.pickingList.rider.lat == null? 0.0 : double.parse(widget.pickingList.rider.lat);
      lan = widget.pickingList.rider == null || widget.pickingList.rider.lng == null? 0.0 : double.parse(widget.pickingList.rider.lng);
      dropLat = widget.pickingList.doner == null || widget.pickingList.doner.lat == null? 0.0 : double.parse(widget.pickingList.doner.lat);
      dropLan = widget.pickingList.doner == null || widget.pickingList.doner.lng == null? 0.0 : double.parse(widget.pickingList.doner.lng);
      print('lat');
      print(lat);
      print('dropLat');
      print(dropLat);
      sOURCELOCATION = LatLng(lat, lan);
      dESTLOCATION = LatLng(dropLat, dropLan);
      print('sOURCELOCATION');
      print(sOURCELOCATION);
      print('dESTLOCATION');
      print(dESTLOCATION);
      setSourceAndDestinationIcons();
      initialLocation = CameraPosition(
          zoom: CAMERA_ZOOM,
         // bearing: CAMERA_BEARING,
          tilt: CAMERA_TILT,
          target: sOURCELOCATION);
    }

  void setSourceAndDestinationIcons() {
      sourceIcon = BitmapDescriptor.defaultMarker;
      // fromAssetImage(
      //     ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
      destinationIcon = BitmapDescriptor.defaultMarker;
      // fromAssetImage(
      //     ImageConfiguration(devicePixelRatio: 2.5),
      //     'assets/destination_map_marker.png');
    }

  void onMapCreated(GoogleMapController controller) {
    //  controller.setMapStyle(Utils.mapStyles);
      _controller.complete(controller);
      setMapPins();
      setPolylines();
    }

    void setMapPins() {
      setState(() {
        // source pin
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            position: sOURCELOCATION,//SOURCE_LOCATION,
            icon: sourceIcon));
        // destination pin
        _markers.add(Marker(
            markerId: MarkerId('destPin'),
            position: dESTLOCATION,//DEST_LOCATION,
            icon: destinationIcon));
      });
    }

    setPolylines() async {

        List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
            googleAPIKey,
            lat,
            lan,
            dropLat,
            dropLan
            // SOURCE_LOCATION.latitude,
            // SOURCE_LOCATION.longitude,
            // DEST_LOCATION.latitude,
            // DEST_LOCATION.longitude
            );
        if (result.isNotEmpty) {
          // loop through all PointLatLng points and convert them
          // to a list of LatLng, required by the Polyline
          result.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }

      setState(() {
          // create a Polyline instance
          // with an id, an RGB color and the list of LatLng pairs
          Polyline polyline = Polyline(
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(255, 40, 122, 198),
              points: polylineCoordinates);

          // add the constructed polyline as a set of points
          // to the polyline set, which will eventually
          // end up showing up on the map
          _polylines.add(polyline);
      });
  }


  // void _distanceList() async {
  //   // GoogleMapController controller = await _controller.future;
  //   // controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lan), _zoom));
  //   String url =
  //       "https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$lan&destination=$dropLat,$dropLan&key=AIzaSyAiXNjJ3WpC-U-NKUPY66eQK471y1CiWTY";

  //   // "https://maps.googleapis.com/maps/api/directions/json?origin=Sylhet&destination=Dhaka&key=AIzaSyAiXNjJ3WpC-U-NKUPY66eQK471y1CiWTY";
  //   print('url compose page');
  //   print(url);

  //   var response = await http
  //       .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

  //   collection = json.decode(response.body);
  //   print(collection);

  //   var data = DirectionList.fromJson(collection);

  //   // var status = data.status;

  //   // if (status == 'OK') {
  //   for (var d in data.routes) {
  //     path = d.overview_polyline.points;
  //   }
  //   print(path);

  //   // } else {
  //   //   path = "";
  //   // }

  //   for (var d in data.routes) {
  //     for (var dd in d.legs) {
  //       distance = dd.distance.text;
  //       duration = dd.duration.text;
  //       startAddress = dd.start_address;
  //       endAddress = dd.start_address;
  //     }
  //   }

  //   setState(() {
  //     _polylines.clear();
  //     _polylines.add(Polyline(
  //         visible: true,
  //         color: Colors.red,
  //         polylineId: PolylineId("polyLineId"),
  //         ));
  //   });


  // }

  // void dropLocation() {
  //   _markers.add(
  //     Marker(
  //       icon: BitmapDescriptor.defaultMarker,

  //       markerId: MarkerId('drop'),
  //       position: LatLng(dropLat, dropLan),
  //       infoWindow: InfoWindow(title: '$endAddress', snippet: 'Welcome to $endAddress')
  //     ),
  //   );
  //   _distanceList();
  // }

  // void riderLocation() {
  //   _markers.add(
  //     Marker(
  //       icon: BitmapDescriptor.defaultMarker,

  //       markerId: MarkerId('LocationId'),
  //       position: LatLng(lat, lan),
  //     ),
  //   );
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
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///////// text top1//////////
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Sent By:',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          widget.pickingList.doner == null
                              ? "- - -"
                              : "${widget.pickingList.doner.name}", //'Anonymous',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),

                ///////// text top2//////////
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Status:',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          widget.pickingList.status == null
                              ? "- - -"
                              : "${widget.pickingList.status}", //'Pending',
                          style: TextStyle(
                              color: Color(0xFFEC4647),
                              fontFamily: "Roboto-Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),

                ///////////  map ////////////////
                Stack(
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                      margin: EdgeInsets.only(top: 25),
                      height: 400,
                      child: GoogleMap(
                      // myLocationEnabled: true,
                        //myLocationEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: false,
                        markers: _markers,
                        polylines: _polylines,
                        mapType: MapType.normal,
                        initialCameraPosition: initialLocation,
                        onMapCreated: onMapCreated,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                       // tiltGesturesEnabled: true,
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
                                () => ScaleGestureRecognizer()),)),
                      // child: GoogleMap(
                      //   markers: _markers,
                      //  // mapToolbarEnabled: true,
                      //   polylines: _polylines,
                      //   mapType: MapType.normal,
                      //  // myLocationEnabled: true,
                      //  // myLocationButtonEnabled: true,
                      //   onMapCreated: _onMapCreated,
                      //   scrollGesturesEnabled: true,
                      //   rotateGesturesEnabled: true,
                      //   zoomGesturesEnabled: true,
                      //   tiltGesturesEnabled: true,
                      //   initialCameraPosition: _initialPosition,
                      //   gestureRecognizers: Set()
                      // ..add(Factory<PanGestureRecognizer>(
                      //     () => PanGestureRecognizer()))
                      // ..add(
                      //   Factory<VerticalDragGestureRecognizer>(
                      //       () => VerticalDragGestureRecognizer()),
                      // )
                      // ..add(
                      //   Factory<HorizontalDragGestureRecognizer>(
                      //       () => HorizontalDragGestureRecognizer()),
                      // )
                      // ..add(
                      //   Factory<ScaleGestureRecognizer>(
                      //       () => ScaleGestureRecognizer()),
                      // ),
                      //   //onCameraMove: ((_position) => _updatePosition(_position)),
                      //  // myLocationEnabled:true,
                      //   // onCameraMove: _onCameraMove,
                      //   // initialCameraPosition: CameraPosition(
                      //   //     target: _center,
                      //   //     zoom: 11.0,
                      //   // ),
                      // ),
                    ),
                  ],
                ),

                // //////////// Donate button ////////
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      //Navigator.push(context, SlideLeftRoute(page: DropLocation(date)));
                      //Navigator.push(context, SlideLeftRoute(page: MapPage(widget.pickingList, widget.value)));
                    },
                    color: appColor,
                    child: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        'Picked!',
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
}
