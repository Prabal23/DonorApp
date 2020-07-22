import 'dart:async';
import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/Screen/PublicReporterSection/AddImageByReporter/addImageByReporter.dart';
import 'package:design_app/model/KeyValueModel/KeyValueModel.dart';
import 'package:design_app/model/SituationModel/SituationModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class AddIncidentByReporter extends StatefulWidget {
  @override
  _AddIncidentByReporterState createState() => _AddIncidentByReporterState();
}

class _AddIncidentByReporterState extends State<AddIncidentByReporter> {
String _value;
  double lat;
  double lan;

  List<String> situations = [];
  String currentSituationSelected;
  var currentSituationId;
  var situationBody, situationList;

  String categoryName = "";
  var categoryId = "";
  KeyValueModel categoryModel;
  List<KeyValueModel> categoryList = <KeyValueModel>[];

  String address = "";
  var collection;
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController addController = new TextEditingController();
  TextEditingController sitController = new TextEditingController();
  TextEditingController msgController = new TextEditingController();
  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025));

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  initState() {
    super.initState();

    getData();
    _myLocation();
    getSituationList();
    // var location = new Location();

    // location.onLocationChanged().listen((LocationData currentLocation) {
    //   setState(() {
    //     lat = currentLocation.latitude;
    //     lan = currentLocation.longitude;
    //   });

    //   print(lat);
    //   print(lan);
    // });
  }

  Future<void> getSituationList() async {
    var res = await CallApi().getData('/app/showSituation');
    situationBody = json.decode(res.body);
    print(situationBody);

    if (res.statusCode == 200) {
      var situationcontent = res.body;
      final situation = json.decode(situationcontent);

      var situationdata = SituationModel.fromJson(situation);

      if (!mounted) return;
      setState(() {
        situationList = situationdata.m_situation;
        for (int i = 0; i < situationList.length; i++) {
          // situations.add("${situationList[i].situation}");

          categoryList.add(KeyValueModel(
              key: "${situationList[i].situation}",
              value: "${situationList[i].id}"));
        }
        // currentSituationSelected = ;
        print("situationssssssss");
        print(categoryList);
        // print("categoryId");
        // print(categoryId);
      });
      print("situationList.length");
      print(situationList);
    }
  }

  void _myLocation() async {
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

    setState(() {
      lat = currentLocation.latitude;
      lan = currentLocation.longitude;
    });

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
      addController.text = address;
    });
    moveCamera();
    //var addressData = SearchAddressModel.fromJson(collection);
    // latitude = 24.9112692;
    // longitude = 91.8499715;

    //var coordinates = new Coordinates(latitude, longitude);
    //addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // first = addresses.first;

    //});
  }

  void moveCamera() {
    controller.moveCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lan), 14));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'PUBLIC REPORTER',//'INCIDENT-ADD',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
          // margin: EdgeInsets.only(top: 13.0, bottom: 13.0, left: 6.5, right: 6.5),
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          // margin: EdgeInsets.all(13.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10.0, top: 10),
                child: Text(
                  'GEO Location',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                //  height: 45.0,
                padding: EdgeInsets.only(top: 5.0, bottom: 17.0),
                child: TextField(
                  controller: addController,
                  maxLines: 30,
                  minLines: 1,
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
              // To add google map
              // Container(
              //   margin: EdgeInsets.only(top: 10, bottom: 15),
              //   height: 200,
              //   child: GoogleMap(
              //     mapType: MapType.normal,
              //     initialCameraPosition: _kGooglePlex,
              //     onMapCreated: (GoogleMapController controller) {
              //       _controller.complete(controller);
              //     },
              //   ),
              // ),
              Container(
                // color: Colors.red,
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height/1.8,
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
                padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: Text(
                  'Situation',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.fromLTRB(2, 10, 20, 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    border: Border.all(width: 1, color: appColor)),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<KeyValueModel>(
                    iconSize: 30,
                    iconEnabledColor: appColor,
                    iconDisabledColor: appColor,
                    isExpanded: true,
                    // isDense: true,
                    underline: Container(
                      height: 0,
                      color: Colors.white,
                    ),
                    items: categoryList.map((KeyValueModel user) {
                      return new DropdownMenuItem<KeyValueModel>(
                        value: user,
                        child: new Text(
                          user.key,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                    onChanged: (KeyValueModel value) {
                      setState(() {
                        categoryModel = value;
                        categoryName = categoryModel.key;
                        categoryId = categoryModel.value;
                      });
                      // categoryId =
                      //_onDropdownSelectedStatus(categoryName);
                      _onSelectedSituation(categoryName);
                      // if (int.parse(categoryId) == 6) {
                      //   _showDialog(context);
                      // }
                      print(categoryId);
                    },
                    hint: Container(
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            categoryName == ''
                                ? 'Select a situation'
                                : categoryName, //widget.index.status == null ? "" : widget.index.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // child: DropdownButton<String>(
                //   value: currentSituationSelected,
                //   iconSize: 30,
                //   iconEnabledColor: appColor,
                //   iconDisabledColor: appColor,
                //   isExpanded: true,
                //   //isDense: true,
                //   underline: Container(
                //     height: 0,
                //     color: Colors.white,
                //   ),

                //   onChanged: (String newValue) {
                //     _onSelectedSituation(newValue);
                //   },
                //   items: situations
                //       .map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(
                //         value,
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontFamily: 'Roboto',
                //             fontSize: 14,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     );
                //   }).toList(),
                //   hint: Text('Select a situation'),
                // )
              ),

              Container(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Message for authorities',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.fromLTRB(2, 10, 0, 8),
                child: TextField(
                  controller: msgController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  minLines: 3,
                  maxLines: 30,
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
                    // contentPadding: EdgeInsets.only(left: 2)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 43),
                child: RaisedButton(
                  onPressed: () {
                    if (categoryId == null || categoryId == '') {
                      _showMessage("Situation field is empty");
                    } else if (msgController.text == "") {
                      _showMessage("Message field is empty");
                    } else if (addController.text == "") {
                      _showMessage("Location field is empty");
                    } else if (lat == null) {
                      _showMessage("Allow this app to access location");
                    } else {
                      var value;
                      setState(() {
                        value = {
                          "lat": lat,
                          "lan": lan,
                          "situationId": categoryId,
                          "message": msgController.text,
                          "address": addController.text
                        };
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddImageByReporter(value)),
                    );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Next',
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

  void getData() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    String data = localstorage.getString('user');
    var token = localstorage.getString('token');
    var user = json.decode(data);
    var userData = user;
    // print(userData['email']);
    print(token);
  }

  void _onSelectedSituation(String newValue) {
    setState(() {
      this.currentSituationSelected = newValue;
      print(currentSituationSelected);
    });
  }
}
