import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/UpdateQr/UpdateQr.dart';

import '../customWidgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ScreenTwo extends StatefulWidget {
  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'BAYANIHAN',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/19692.png"),
            //     fit: BoxFit.cover,
            //     colorFilter: new ColorFilter.mode(
            //         Colors.white.withOpacity(0.1), BlendMode.dstATop),
            //   ),
            // ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(13.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Host',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                    CustomTextField(),
                    Text(
                      'Device Id',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                    CustomTextField(),
                    Container(
                      padding: EdgeInsets.only(top: 43),
                      child: RaisedButton(
                        onPressed: () {


                            Navigator.push(
                  context, SlideLeftRoute(page: UpdateQr()));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Update',
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
        ],
      ),
    );
  }
}
