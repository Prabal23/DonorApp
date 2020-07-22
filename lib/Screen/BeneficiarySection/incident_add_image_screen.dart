import 'dart:convert';
import 'dart:io';
//import '../screens/incident_view_screen.dart';
import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import './incident_add_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';
import 'Beneficiary/Beneficiary.dart';

class IncidentAddImageScreen extends StatefulWidget {
  final value;
  IncidentAddImageScreen(this.value);
  @override
  _IncidentAddImageScreenState createState() => _IncidentAddImageScreenState();
}

class _IncidentAddImageScreenState extends State<IncidentAddImageScreen> {
  File _image;
  bool _isImage = false;
  int imgPercent = 1;
  List imgList = [];
  var user;
  var _showImage;
  bool isLoading = false;
  bool _isCancelImg = false;
  CancelToken token = CancelToken();
  var dio = new Dio();

  String fullUrl, mainUrl;
  String tryUrl;


  @override
  void initState() {
    _getUserInfo();
    postPicData();
    print(widget.value['message']);
    //retrieveLostData();
    super.initState();
  }

  postPicData() async {
    var apiUrl = '/app/incidentUpload';
    mainUrl = await CallApi().getUrl();
    fullUrl = await CallApi().getUrl() + apiUrl;
    tryUrl = fullUrl;
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    print("full url is : $tryUrl");
    return fullUrl;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 80);
    if (image == null) {
    } else {
      _uploadImg(image);

      setState(() {
        _image = image;
      });
    }
  }

  void _uploadImg(filePath) async {
    setState(() {
      _isImage = true;
    });

    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData =
          new FormData.from({"imgUrl": new UploadFileInfo(filePath, fileName),
          "url": '$mainUrl',
          });

      Response response = await Dio().post(
          '$tryUrl',//'http://test.appifylab.com/app/incidentUpload',
          data: formData,
          cancelToken: token, onSendProgress: (int sent, int total) {
        //imgPercent=0;
        setState(() {
          imgPercent = ((sent / total) * 100).toInt();

          print("percent");
          print(imgPercent);
        });
      });

      if (_isCancelImg == true) {
        _isCancelImg = false;
      } else {
        setState(() {
          _showImage = response.data['imgUrl'];
          _isImage = false;
          imgPercent = 0;
        });
        print(_showImage);

        imgList.add({'imgUrl': response.data['imgUrl']});
      }
      //     setState(() {
      //   _isImage = false;
      // });
      print(imgList);

      // Show the incoming message in snakbar
      //_showMsg(response.data['message']);
    } catch (e) {
      // print("Exception Caught: $e");
    }
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    if (userJson != null) {
      var users = json.decode(userJson);
      setState(() {
        user = users;
      });
    }
    print("user");
    print(user);
  }

  // Container featureImage(File img, String label) {
  //   return Container(
  //     // margin: EdgeInsets.only(,
  //     child: img == null
  //         ? Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: <Widget>[
  //               Container(
  //                 margin: EdgeInsets.only(top: 20),
  //                 child: DottedBorder(
  //                   color: Colors.black,
  //                   radius: Radius.circular(60),
  //                   strokeWidth: 1,
  //                   child: Container(
  //                     padding: EdgeInsets.only(
  //                         left: 25, right: 25, top: 8, bottom: 8),
  //                     child: IconButton(
  //                         icon: Icon(Icons.photo, color: Color(0xFF8A8A8A)),
  //                         onPressed: getImage),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 //alignment: Alignment.center,
  //                 margin: EdgeInsets.only(
  //                   top: 10,
  //                 ),
  //                 child: Text(
  //                   label,
  //                   //  textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: appColor,
  //                       fontFamily: "Roboto-Regular",
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.normal),
  //                 ),
  //               )
  //             ],
  //           )
  //         : Column(
  //             children: <Widget>[
  //               Container(
  //                 margin: EdgeInsets.only(
  //                   top: 20,
  //                 ),
  //                 child: Image.file(img,
  //                     height: 80, width: 100, fit: BoxFit.contain),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(left: 10),
  //                 child: Text(
  //                   label,
  //                   style: TextStyle(
  //                       color: appColor,
  //                       fontFamily: "Roboto-Regular",
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.normal),
  //                 ),
  //               )
  //             ],
  //           ),
  //   );
  // }

  // File _pickedImage;

  // void _pickImage() async {
  //   final imageSource = await showDialog<ImageSource>(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text("Select the image source"),
  //             actions: <Widget>[
  //               MaterialButton(
  //                 child: Text("Camera"),
  //                 onPressed: () => Navigator.pop(context, ImageSource.camera),
  //               ),
  //               MaterialButton(
  //                 child: Text("Gallery"),
  //                 onPressed: () => Navigator.pop(context, ImageSource.gallery),
  //               )
  //             ],
  //           ));

  //   if (imageSource != null) {
  //     final file = await ImagePicker.pickImage(source: imageSource);
  //     if (file != null) {
  //       setState(() => _pickedImage = file);
  //     }
  //   }
  // }

  void _deleteImg(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to remove this?",
            // textAlign: TextAlign.,
            style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "grapheinpro-black",
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
              height: 70,
              width: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 25,
                          bottom: 15,
                        ),
                        child: OutlineButton(
                          child: new Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(top: 25, bottom: 15),
                        child: OutlineButton(
                            // color: Colors.greenAccent[400],
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              imgList.removeAt(index);
                              setState(() {});
                              Navigator.pop(context);
                              // _deleteOrders();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

  void cancelImg() async {
    print("object");

    // token.cancel("cancelled");

    //     Response response;
    // try {
    //   response=await dio.get('https://admin.bahrainunique.com/app/upload', cancelToken: token);
    //   print(response);
    // }catch (e){
    //   if (CancelToken.isCancel(e)) {
    //     print(' $e');
    //   }
    // }

    setState(() {
      _isImage = false;
      _isCancelImg = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'INCIDENT-ADD',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        color: Colors.white,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _isImage
                  ? Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            cancelImg();
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey.withOpacity(0.2),
                            child: Center(
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("$imgPercent % loading..",
                                      style: TextStyle(fontSize: 15)),
                                  Text("Cancel Upload",
                                      style: TextStyle(fontSize: 15)),
                                ],
                              )),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey.withOpacity(0.2),
                            child: Container(
                                child: Icon(
                              Icons.photo_camera,
                              size: 30,
                            )),
                          ),
                        ),
                      ],
                    ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(left: 10, right: 10),
              sliver: Container(
                //color: Colors.redAccent,
                child: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return
                          // _isImage
                          //     ? Container(
                          //         padding: const EdgeInsets.all(12.0),
                          //         margin: EdgeInsets.only(top: 20),
                          //         decoration: BoxDecoration(
                          //             shape: BoxShape.circle,
                          //             border:
                          //                 Border.all(color: appColor, width: 2)),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(12.0),
                          //           child: Text(imgPercent.toString() + "%"),
                          //         ))
                          //     //  Padding(
                          //     //     padding: const EdgeInsets.all(8.0),
                          //     //     child: Center(
                          //     //       child: CircularProgressIndicator(),
                          //     //     ))
                          //     :
                          imgList.length == 0
                              ? Container()
                              : Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 12),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              shape: BoxShape.rectangle),
                                          child: Container(
                                            child: Image.network(
                                              // 'assets/images/camera.jpg',
                                              // 'http://test.appifylab.com' +
                                              imgList[index]['imgUrl'],
                                              height: 80,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 100, right: 20),
                                              width: 100,
                                              child: Text(
                                                "Photo ${index + 1}",
                                                textAlign: TextAlign.center,
                                              ))),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(.5),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        //   alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                          onTap: () {
                                            _deleteImg(index);
                                            // imgList.removeAt(index);
                                            // setState(() {}
                                            // );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                    },
                    childCount: imgList.length,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 170.0,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 43),
                    child: RaisedButton(
                      onPressed: () {
                        if (imgList == [] || imgList.length == 0) {
                          return _showMessage(
                              'No picture is added, add a picture!!');
                        } else {
                          checkSOS();
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: isLoading
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          isLoading ? 'Please Wait...' : 'Send SOS',
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkSOS() async {
    setState(() {
      isLoading = true;
    });

    var items = {
      "beneficiarId": user['id'],
      "situationId": widget.value['situationId'],
      "messageForDoner": widget.value['message'],
      "status": "Pending",
      "lat": widget.value['lat'],
      "lng": widget.value['lan'],
      "address": widget.value['address'],
      "imgUrl": imgList,
    };

    var res = await CallApi().postData(items, '/app/addIncident');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      sendSOS();
    }

    print(items);

    setState(() {
      isLoading = false;
    });
  }

  void sendSOS() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  "Item has sent! Take a few moments for admin verification for final posting",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 112, 112, 112)),
                  textAlign: TextAlign.center,
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Beneficiary()));
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
                        'OK',
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

//   Future<void> retrieveLostData() async {
//   final LostDataResponse response =
//       await ImagePicker.retrieveLostData();
//   if (response == null) {
//     return;
//   }
//   if (response.file != null) {
//     setState(() {
//       if (response.type == RetrieveType.video) {

//       } else {
//         getImage();
//       }
//     });
//   }
//   // else {
//   //   _handleError(response.exception);
//   // }
// }
}
