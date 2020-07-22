import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/PublicReporterSection/ViewIncidentOfReporter/ViewIncidentOfReporter.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class ReporterCard extends StatefulWidget {
  final incidentList;
  ReporterCard(this.incidentList);
  @override
  _ReporterCardState createState() => _ReporterCardState();
}

class _ReporterCardState extends State<ReporterCard> {
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
                                // 'hhhhh',
                                widget.incidentList.situation.situation == ''
                                    ? "---"
                                    : "${widget.incidentList.situation.situation}",
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
                                // 'jjjjjjj',
                                widget.incidentList.address == ''
                                    ? "---"
                                    : "${widget.incidentList.address}",
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
                            SlideLeftRoute(page: ViewIncidentOfReporter(widget.incidentList)));
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