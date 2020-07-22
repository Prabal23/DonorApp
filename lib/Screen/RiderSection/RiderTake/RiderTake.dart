import 'dart:async';

import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/RiderSection/RiderPage/RiderPage.dart';
import 'package:design_app/Screen/RiderSection/RiderPhoto/RiderPhoto.dart';
import 'package:design_app/Services/callAndMsgServices.dart';
import 'package:design_app/Services/service_locator.dart';
import 'package:design_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

const double CAMERA_ZOOM = 14;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class RiderTake extends StatefulWidget {
  final pickingList;
  final value;
  RiderTake(this.pickingList, this.value);
  @override
  _RiderTakeState createState() => _RiderTakeState();
}

class _RiderTakeState extends State<RiderTake> {
  TextEditingController shareController = TextEditingController();

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
  var status = '';

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  var number = "";


  @override
  void initState() {
    super.initState();
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    date = widget.pickingList.pickupDate == null? "": "${widget.pickingList.pickupDate}";
    time = widget.pickingList.pickupTime == null? "": "${widget.pickingList.pickupTime}";
    status = widget.pickingList.status == null? "": "${widget.pickingList.status}";
    number = widget.pickingList.doner.mobileNumber == null? "": "${widget.pickingList.doner.mobileNumber}";
    print(status);
    print(number);
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
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///////// text top1//////////
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Expanded(
                        child: Container(
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
                        ),
                      )
                    ],
                  ),
                ),

                ///////// text top2//////////
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Rider:',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            //'David Ron',
                            widget.pickingList.rider == null
                                ? "No rider yet"
                                : "${widget.pickingList.rider.name}",
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

                ///////// text top3//////////
                Container(
                  margin: EdgeInsets.only(top: 10),
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

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Date : ',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.pickingList.updated_at == null
                                ? "- - -"
                                : "${widget.pickingList.updated_at}", //'Pending',
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
                              'What to receive',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            )),
                        Container(
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

                ///////////  map ////////////////
                Container(
                 // margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                  margin: EdgeInsets.only(top: 25),
                  height: 200,
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
                ),


                status == 'Taken'?
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                  )
                  :
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    onPressed: () => _service.call(number),
                    color: appColor,
                    child: Container(
                      //alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.call, color: Colors.white),
                          SizedBox(width: 8,),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              'Make a call',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ////////////// Donate button ////////
                status == 'Taken'?
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                  )
                  :
                  Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 30),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context, SlideLeftRoute(page: RiderPhoto(widget.pickingList)));
                    },
                    color: appColor,
                    child: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        'Take It',
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
                  "Success",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Item is now assigned to you",
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
}
