import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../incident_view_screen.dart';

class DonorCard extends StatefulWidget {
  final donorList;
  final incidentList;
  DonorCard(this.donorList, this.incidentList);
  @override
  _DonorCardState createState() => _DonorCardState();
}

class _DonorCardState extends State<DonorCard> {
  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //                       itemCount: 5,
    //                       itemBuilder: (BuildContext ctxt, int index) {
    //                         return  ListTile(
    //                           title: Text("hello"),
    //                         );
    //                       });

    return Container(
      child: Card(
        elevation: 1,
        //  margin: EdgeInsets.only(bottom: 5, left: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 16.0,
                // offset: Offset(0.0,3.0)
              )
            ],
            // border: Border.all(
            //   color: Color(0xFF08be86)
            // )
          ),
          padding: EdgeInsets.only(right: 12, left: 15, top: 10, bottom: 10),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          //color: Colors.blue,
          child: Column(
            children: <Widget>[
              Container(
                //color: Colors.red,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.donorList.status == ''
                                    ? "Pending"
                                    : "${widget.donorList.status}",
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: appColor,
                                    fontFamily: "Roboto-Regular",
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.donorList.doner.name == ''
                                    ? "Anonymous"
                                    : "${widget.donorList.doner.name}",
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto-Regular",
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            SlideLeftRoute(page: IncidentViewScreen(widget.donorList, widget.incidentList)));
                      },
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: appColor,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
