
import 'package:design_app/Screen/splash_screen.dart';
import 'package:design_app/redux/reducer.dart';
import 'package:design_app/redux/state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'Services/service_locator.dart';

// void main() => runApp(MyApp());

void main() {
  setupLocator();
  runApp(MyApp());}

int index = 0;

Color appColor = Color(0xFF009998);
String loggedData = '';
bool isGranted = false;

final store = Store<AppState>(reducer,
    initialState: AppState(
        demoState: "",

        unseenState: 0, seenState: 0),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: appColor,
      accentColor: Color(0xFF8A8A8A)) ,
      home: Design(),
    );
  }
}

class Design extends StatefulWidget {
  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SplashScreen()),
    );
  }
}