import 'package:barcode_scan/barcode_scan.dart';
import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../login.dart';

class UpdateQr extends StatefulWidget {
  @override
  _UpdateQrState createState() => _UpdateQrState();
}

class _UpdateQrState extends State<UpdateQr> {
  var qrText = "";
  var urlString;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String barcode = "";

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
            'BAYANIHAN',
            style: TextStyle(
                color: appColor,
                fontFamily: "Roboto-Bold",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        //  margin: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          children: <Widget>[
            Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                        //  mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            //   alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(top: 30, left: 30, right: 30),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: DottedBorder(
                              color: Colors.black,
                              radius: Radius.circular(60),
                              strokeWidth: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 60, top: 60),
                                  child: Text(
                                    'Scan QR Code',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  //   child: RaisedButton(
                  //       color: Colors.blue,
                  //       textColor: Colors.white,
                  //       splashColor: Colors.blueGrey,
                  //       onPressed: scan,
                  //       child: const Text('START CAMERA SCAN')),
                  // ),
                  Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
              child: RaisedButton(
                color: appColor,
                onPressed: scan,
                child: Text('START CAMERA SCAN',
                    style:
                        TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: <Widget>[
                        Text("This is the result of scan: "),
                        SizedBox(height: 10),
                        Text(
                          barcode,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
              child: RaisedButton(
                color: appColor,
                onPressed: () {
                  (barcode == '' || barcode == null)
                      ? _showMessage('No url found , scan a QRCode')
                      : _showDialog();
                },
                child: Text('GET URL',
                    style:
                        TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: appColor.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 20.0);
  }

  _showDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 2, top: 0),
                        padding: EdgeInsets.fromLTRB(12, 5, 8, 5),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 1, color: appColor)),
                        child: Text(
                          (barcode == '' || barcode == null)
                              ? "- - -"
                              : "$barcode", //'data',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF8A8A8A),
                              fontFamily: "Roboto-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Do you want to change the host url?",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 5, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (barcode != '' || barcode != null) {
                                // qrText = 'http://test.appifylab.com';
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                localStorage.setString('qrText', barcode);
                                urlString = localStorage.getString('qrText');
                                print('urlString isssssssssssssssssssssss');
                                print(urlString);
                                //CallApi().hostUrl(qrText);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Login();
                                }));
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:design_app/JsonAPI/CallApi.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../main.dart';
// import '../login.dart';

// const flash_on = "FLASH ON";
// const flash_off = "FLASH OFF";
// const front_camera = "FRONT CAMERA";
// const back_camera = "BACK CAMERA";
// class UpdateQr extends StatefulWidget {
//   @override
//   _UpdateQrState createState() => _UpdateQrState();
// }

// class _UpdateQrState extends State<UpdateQr> {
// var qrText = "";
// var urlString;
//   var flashState = flash_on;
//   var cameraState = front_camera;
//   QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //   elevation: 0,
//       //   backgroundColor: Colors.white,
//       //   centerTitle: false,
//       //   leading: IconButton(
//       //     icon: Icon(Icons.arrow_back, color: appColor),
//       //     onPressed: () {
//       //       Navigator.of(context).pop();
//       //     },
//       //   ),
//       //   title: Container(
//       //     child: Text(
//       //       'BAYANIHAN',
//       //       style: TextStyle(
//       //           color: appColor,
//       //           fontFamily: "Roboto-Bold",
//       //           fontSize: 20,
//       //           fontWeight: FontWeight.bold),
//       //     ),
//       //   ),
//       // ),
//       body: Container(
//       //  margin: EdgeInsets.only(left: 12, right: 12),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: QRView(
//                 key: qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//                 overlay: QrScannerOverlayShape(
//                   borderColor: Colors.red,
//                   borderRadius: 10,
//                   borderLength: 30,
//                   borderWidth: 10,
//                   cutOutSize: 300,
//                 ),
//               ),
//               flex: 4,
//             ),
//             Expanded(
//               child: FittedBox(
//                 fit: BoxFit.contain,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                       child: Text("This is the result of scan: $qrText")),//${CallApi().hostUrl(qrText)}
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   crossAxisAlignment: CrossAxisAlignment.center,
//                     //   children: <Widget>[
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 60,
//                           margin: EdgeInsets.all(10.0),
//                           child: RaisedButton(
//                             color: appColor,
//                             onPressed: () {
//                               (qrText == '' || qrText == null)? _showMessage('No url found , scan a QRCode') : _showDialog() ;
//                             },
//                             child: Text('Url', style: TextStyle(fontSize: 20)),
//                           ),
//                         ),
//                     //     Container(
//                     //       margin: EdgeInsets.all(8.0),
//                     //       child: RaisedButton(
//                     //         onPressed: () {
//                     //           controller?.resumeCamera();
//                     //         },
//                     //         child: Text('resume', style: TextStyle(fontSize: 20)),
//                     //       ),
//                     //     )
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//               flex: 1,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) async {
//       setState(()  {
//         qrText = scanData;
//         print('qrText ssssssssssssssssssssssssssssssssssss');
//         print(qrText);
//        // print(CallApi().hostUrl(qrText));
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   _showMessage(String message) {
//     Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIos: 1,
//         backgroundColor: appColor.withOpacity(0.9),
//         textColor: Colors.white,
//         fontSize: 20.0);
//   }

//   _showDialog(){
//     return showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return new AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           title: Center(
//             child: SingleChildScrollView(
//               child: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                             height: 100,
//                             width: MediaQuery.of(context).size.width,
//                             margin: EdgeInsets.only(left: 8, top: 0),
//                             padding: EdgeInsets.fromLTRB(12, 5, 8, 5),
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5.0)),
//                                 color: Colors.white,
//                                 border: Border.all(width: 1, color: appColor)),
//                             child: Text(
//                               (qrText == '' || qrText == null)
//                                   ? "- - -"
//                                   : "$qrText", //'data',
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                   color: Color(0xFF8A8A8A),
//                                   fontFamily: "Roboto-Regular",
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.normal),
//                             )
//                             ),
//                     Container(
//                         margin: EdgeInsets.only(top: 12),
//                         child: Text(
//                           "Do you want to change the host url?",
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 14,
//                               fontFamily: 'Oswald',
//                               fontWeight: FontWeight.w400),
//                         )),
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 Navigator.of(context).pop();
//                               });
//                             },
//                             child: Container(
//                                 padding: EdgeInsets.all(10),
//                                 margin: EdgeInsets.only(
//                                     left: 0, right: 5, top: 20, bottom: 0),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: Colors.grey, width: 0.2),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(100))),
//                                 child: Text(
//                                   "No",
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 17,
//                                     fontFamily: 'BebasNeue',
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 )),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async {
//                               if (qrText != '' || qrText != null)
//                               {
//                                // qrText = 'http://test.appifylab.com';
//                                 SharedPreferences localStorage = await SharedPreferences.getInstance();
//                                 localStorage.setString('qrText', qrText);
//                                 urlString = localStorage.getString('qrText');
//                                 print('urlString isssssssssssssssssssssss');
//                                 print(urlString);
//                                 //CallApi().hostUrl(qrText);
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                                   return Login();
//                                 }));
//                               }
//                             },
//                             child: Container(
//                                 padding: EdgeInsets.all(10),
//                                 margin: EdgeInsets.only(
//                                     left: 5, right: 0, top: 20, bottom: 0),
//                                 decoration: BoxDecoration(
//                                     color: appColor,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(100))),
//                                 child: Text(
//                                   "Yes",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 17,
//                                     fontFamily: 'BebasNeue',
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
