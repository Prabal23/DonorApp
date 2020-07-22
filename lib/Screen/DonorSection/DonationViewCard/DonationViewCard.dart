// import 'dart:async';

// import 'package:design_app/RouteTransition/routeAnimation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// import '../../../main.dart';
// import '../donate_cancel_screen.dart';
// import 'DonationViewCardDetails.dart';

// class DonationViewCard extends StatefulWidget {
//   final donorList;
//   DonationViewCard(this.donorList);
//   @override
//   _DonationViewCardState createState() => _DonationViewCardState();
// }

// class _DonationViewCardState extends State<DonationViewCard> {

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 3),
//       child: Card(
//         elevation: 1,
//        // margin: EdgeInsets.only(bottom: 5, top: 5),
//         color: Colors.red,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey[200],
//                 blurRadius: 16.0,
//                 // offset: Offset(0.0,3.0)
//               )
//             ],
//             // border: Border.all(
//             //   color: Color(0xFF08be86)
//             // )
//           ),
//           padding: EdgeInsets.only(right: 12, left: 15, top: 10, bottom: 10),
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           //color: Colors.blue,
//           child: Column(
//             children: <Widget>[
//               Container(
//                 // color: Colors.red,
//                 child: Row(
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                         //color: Colors.red,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Container(
//                               child: Row(
//                                 children: <Widget>[
//                                   Text(
//                                     "ID  :  ",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color: Color(0xFFEC4647),
//                                         fontFamily: "Roboto-Bold",
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     widget.donorList.id == ''
//                                         ? ""
//                                         : "${widget.donorList.id}",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: "Roboto-Regular",
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(top: 5),
//                               child: Row(
//                                 children: <Widget>[
//                                   Text(
//                                     "Status  :  ",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: "Roboto-Regular",
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                   Text(
//                                     //"Donate Status",
//                                     widget.donorList.status == ''
//                                         ? "Pending"
//                                         : "${widget.donorList.status}", //"Donate Status",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: "Roboto-Regular",
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(context,
//                             SlideLeftRoute(page: DonationViewCardDetails(widget.donorList)));
//                       },
//                       child: Container(
//                           //color: Colors.red,
//                           padding: EdgeInsets.fromLTRB(10, 10, 2, 10),
//                           child: Icon(
//                             Icons.remove_red_eye,
//                             color: appColor,
//                             size: 26,
//                           )),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }