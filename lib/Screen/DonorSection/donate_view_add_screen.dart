// import '../screens/donate_cancel_screen.dart';

import 'dart:async';
import 'dart:convert';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/Screen/PublicReporterSection/PreviewImage.dart';
import 'package:design_app/main.dart';
import 'package:design_app/model/DonorModel/DonorModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'DonationViewCard/DonationViewCard.dart';
import 'DonationViewCard/DonationViewCardDetails.dart';

class DonateViewAddScreen extends StatefulWidget {
  final incidentList;
  DonateViewAddScreen(this.incidentList);
  @override
  _DonateViewAddScreenState createState() => _DonateViewAddScreenState();
}

class _DonateViewAddScreenState extends State<DonateViewAddScreen> {
  DateTime selectedDate = DateTime.now();
  var format;
  var date = "", incidentMsg = "";
  var donorList, donorBody;
  var id = '';
  List donations = [];
  List<String> photos = [];
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    id = '${widget.incidentList.id}';
    // print('id');
    // print(id);
    donationList();
    sendedMoneyRecieptList();
    //getDonorList();
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

  // Future<void> getDonorList() async {
  //   var res =
  //       await CallApi().getData('/app/showDonation/${widget.incidentList.id}');
  //   donorBody = json.decode(res.body);
  //   print(donorBody);

  //   if (res.statusCode == 200) {
  //     var donorcontent = res.body;
  //     final donor = json.decode(donorcontent);

  //     var donordata = DonorModel.fromJson(donor);

  //     donorList = donordata.donations;
  //     if (donorList != null) {
  //       setState(() {
  //         //  String dd = donorList.created_at;
  //         //  var spDate = dd.split(" ");
  //         //  alertDate = spDate[0];
  //         // situation = donorList.situation;
  //         print('donorList');
  //         print(donorList);
  //       });
  //       print(donor);
  //     } else {
  //       setState(() {
  //         incidentMsg = "No donation found !";
  //       });
  //     }
  //     print("donorList.length");
  //     print(donorList.length);
  //   }
  // }

  donationList() {
    for (int i = 0; i < widget.incidentList.donation.length; i++) {
      donations.add(widget.incidentList.donation[i]);
    }
    print(donations.length);
    print('donations');
    print(donations);
  }

  sendedMoneyRecieptList() {
    for (int i = 0; i < widget.incidentList.money_donation.length; i++) {
      photos.add("${widget.incidentList.money_donation[i].payment_img}");
    }
    print('photos aredddrdr');
    print(photos);
    print(photos.length);
  }

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
            'DONATION-VIEW/EDIT', //'DONATION LIST',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 0, top: 25),
                    child: Text(
                      'Donated Money Reciepts  :  ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: appColor,
                          //decoration: TextDecoration.underline,
                          //fontFamily: "Roboto-bold",
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 10),
                  child: Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        // Container(
                        //     alignment: Alignment.center,
                        //     margin: EdgeInsets.only(left: 0, top: 25),
                        //     child: Text(
                        //       'Donated Money Reciepts  :  ',
                        //       textAlign: TextAlign.left,
                        //       style: TextStyle(
                        //           color: appColor,
                        //           //decoration: TextDecoration.underline,
                        //           //fontFamily: "Roboto-bold",
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w400),
                        //     )),
                        photos == null
                            ? Center(child: CircularProgressIndicator())
                            : photos.length == 0
                                                ? Container(
                                                    // alignment: Alignment.center,
                                                    height: 200,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    //color: Colors.red,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/image/photo_placeholder.png',
                                                          height: 70,
                                                          width: 100,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8),
                                                          child: Text(
                                                              "No image found !!"),
                                                        ),
                                                      ],
                                                    ))
                                                    :
                             Container(
                                height: 250,
                                // width: MediaQuery.of(context).size.width,
                                // margin: EdgeInsets.only(left: 5, right: 5, bottom: 30, top: 0),
                                child: ListView.builder(
                                    // shrinkWrap: false,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: photos.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: 
                                            // photos.length == 0
                                            //     ? Container(
                                            //         // alignment: Alignment.center,
                                            //         height: 100,
                                            //         width:
                                            //             MediaQuery.of(context)
                                            //                 .size
                                            //                 .width,
                                            //         padding: EdgeInsets.only(
                                            //             right: 20),
                                            //         //color: Colors.red,
                                            //         child: Column(
                                            //           mainAxisAlignment:
                                            //               MainAxisAlignment
                                            //                   .center,
                                            //           crossAxisAlignment:
                                            //               CrossAxisAlignment
                                            //                   .center,
                                            //           children: <Widget>[
                                            //             Image.asset(
                                            //               'assets/image/photo_placeholder.png',
                                            //               height: 70,
                                            //               width: 100,
                                            //             ),
                                            //             Padding(
                                            //               padding:
                                            //                   EdgeInsets.only(
                                            //                       top: 8),
                                            //               child: Text(
                                            //                   "No image found !!"),
                                            //             ),
                                            //           ],
                                            //         ))
                                               // :
                                                 GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return PreviewImage(photos[index]);
                                                      }));
                                                      // Navigator.push(context,
                                                      // SlideLeftRoute(page: PreviewVideo(photos[index])));
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20),
                                                      child: Image.network(
                                                        photos[index],
                                                        height: 200,
                                                        width: 300,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        ],
                                      );
                                    })),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 0, top: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Donated Goods  :  ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: appColor,
                              //decoration: TextDecoration.underline,
                              //fontFamily: "Roboto-bold",
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        donations.length == 0 ? Text(
                          'None',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: appColor,
                              //decoration: TextDecoration.underline,
                              //fontFamily: "Roboto-bold",
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ) : Text('')
                      ],
                    )),
                donations == null
                    ? Center(child: CircularProgressIndicator())
                    :
                    // : donations.length == 0
                    //     ? Container(
                    //         margin: EdgeInsets.only(
                    //             left: 5, right: 5, bottom: 30, top: 0),
                    //         child: Center(
                    //             child: Card(
                    //           elevation: 1,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           child: Container(
                    //               alignment: Alignment.center,
                    //               decoration: BoxDecoration(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(10)),
                    //                 //color: Colors.red
                    //               ),
                    //               height: 300,
                    //               child: Text("No donation found !")),
                    //         )),
                    //       )
                    //     :
                      Container(
                            // height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              //color: Colors.red
                            ),
                            margin: EdgeInsets.only(
                                left: 5, right: 5, bottom: 30, top: 0),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: donations.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Column(
                                      children: <Widget>[
                                        DonationViewCardDetails(
                                            donations[index])
                                      ],
                                    );
                                  }),
                            )),
              ],
            ),
          ),
        )

        // donations == null
        //     ? Center(child: CircularProgressIndicator())
        //     : donations.length == 0
        //         ? Center(
        //             child: Container(
        //                 alignment: Alignment.center,
        //                 height: 300,
        //                 child: Text("No donation found !")))
        //         : Container(
        //             // height: 150,
        //             width: MediaQuery.of(context).size.width,
        //             margin: EdgeInsets.only(left: 5, right: 5, bottom: 30, top: 0),
        //             child: ListView.builder(
        //                 shrinkWrap: true,
        //                 physics: BouncingScrollPhysics(),
        //                 itemCount: donations.length,
        //                 itemBuilder: (BuildContext ctxt, int index) {
        //                   return Column(
        //                     children: <Widget>[
        //                       DonationViewCardDetails(donations[index])
        //                     ],
        //                   );
        //                 })),
        );
  }
}
