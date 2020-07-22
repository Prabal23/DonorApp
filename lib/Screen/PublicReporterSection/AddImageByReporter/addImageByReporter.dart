import 'dart:convert';
import 'dart:io';

import 'package:design_app/JsonAPI/CallApi.dart';
import 'package:design_app/Screen/BeneficiarySection/Beneficiary/Beneficiary.dart';
import 'package:design_app/Screen/PublicReporterSection/PublicReporter/PublicReporter.dart';
import 'package:design_app/Screen/permissions_service.dart';
import 'package:design_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;
import 'package:video_player/video_player.dart';

class AddImageByReporter extends StatefulWidget {
  final value;
  AddImageByReporter(this.value);
  @override
  _AddImageByReporterState createState() => _AddImageByReporterState();
}

class _AddImageByReporterState extends State<AddImageByReporter> {
  File _image;
  File _video;
  bool _isImage = false;
  bool _isVideo = false;
  int imgPercent = 1;
  List imgList = [];
  int videoPercent = 1;
  List videoList = [];
  var user;
  var _showImage;
  var _showVideo;
  bool isLoading = false;
  bool _isCancelImg = false;
  bool _isCancelVideo = false;
  CancelToken token = CancelToken();
  var dio = new Dio();
  VideoPlayerController _cameraVideoPlayerController;
  bool isCameraSelected = false;
  bool isVideoSelected = false;

  var userToken;

  bool isDenied = false;
  bool isPermitted = false;
  bool checkingDone = false;

  String fullUrl, mainUrl;
  String tryUrl;
  String fullUrl2;
  String tryUrl2;

  @override
  void initState() {
    _getUserInfo();
    // postPicData();
    // postPicData2();
    // print(widget.value['message']);
   // checkingDone? checked() : cameraPermission();
    //retrieveLostData();
    super.initState();
  }

  postPicData() async {
    var imageApiUrl = '/app/incidentUpload';
    fullUrl = await CallApi().getUrl() + imageApiUrl;
    tryUrl = fullUrl;
    print("full url is : $fullUrl");
    print("full url is : $tryUrl");

    return fullUrl;
  }

  postPicData2() async {
    var videoApiUrl = '/app/ReporterVideoUpload';
    fullUrl2 = await CallApi().getUrl() + videoApiUrl;
    tryUrl2 = fullUrl2;
    print("full url is : $fullUrl2");
    print("full url is : $tryUrl2");
    return fullUrl2;
  }

  void checked() {
    print('checking is Done');
    print(checkingDone);
  }

  void cameraPermission() {
    PermissionsService().requestPermission(PermissionGroup.camera);
    if (isGranted == true) {
      setState(() {
        isPermitted = true;
        checkingDone = true;
        imgOrVideo();
      });
    } else if (isGranted == false) {
      setState(() {
        isPermitted = false;
       // _showMessage('please allow camera access');
      });
    }
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userToken = localStorage.getString('token');

    print('userToken');
    print(userToken);
  }

  // Future getImage() async {
  //   var image = await ImagePicker.pickImage(
  //       source: ImageSource.camera, imageQuality: 80);
  //   if (image == null) {
  //   } else {
  //     _uploadImg(image);

  //     setState(() {
  //       _image = image;
  //     });
  //   }
  // }

  File _pickedImage;

  Future pickImage() async {
    // final imageSource = await showDialog<ImageSource>(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text("Select the image source"),
    //           actions: <Widget>[
    //             MaterialButton(
    //               child: Text("Camera"),
    //               onPressed: () => Navigator.pop(context, ImageSource.camera),
    //             ),
    //             MaterialButton(
    //               child: Text("Gallery"),
    //               onPressed: () => Navigator.pop(context, ImageSource.gallery),
    //             )
    //           ],
    //         ));

    // if (imageSource != null) {
    //   var img = await ImagePicker.pickImage(source: imageSource, imageQuality: 80);
    //   // if (file != null) {
    //   //   setState(() => _pickedImage = file);
    //   // }

    var img = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 80);

    if (img == null) {
    } else {
      _uploadImg(img);

      setState(() {
        _image = img;
      });
    }
    //  }
  }

  void _uploadImg(filePath) async {
    setState(() {
      _isImage = true;
      // postPicData();
    });
   // postPicData();
    var imageApiUrl = '/app/incidentUpload';
    mainUrl = await CallApi().getUrl();
    fullUrl = await CallApi().getUrl() + imageApiUrl;
    tryUrl = fullUrl;
    print(tryUrl);

    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData = new FormData.from({
      "imgUrl": new UploadFileInfo(filePath, fileName),
      "url": '$mainUrl',
    });
         // new FormData.from({"imgUrl": new UploadFileInfo(filePath, fileName)});

      Response response = await Dio().post(
          '$tryUrl',//'http://test.appifylab.com/app/incidentUpload',//'https://bayanihan.santamariabulacan.org/app/incidentUpload',//
          data: formData,
          cancelToken: token, onSendProgress: (int sent, int total) {
        //imgPercent=0;
        setState(() {
          imgPercent = ((sent / total) * 100).toInt();

          print("percent");
          print(imgPercent);
        });
      });
      print('this is the response $response');

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
      //_showMessage(response.data['message']);
    } catch (e) {
      // print("Exception Caught: $e");
    }
  }

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
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 26),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 1.8,
        title: Text(
          'PUBLIC REPORTER',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 20),
        color: Colors.white,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            // SliverToBoxAdapter(
            //   child: _isImage
            //       ? Column(
            //           children: <Widget>[
            //             GestureDetector(
            //               onTap: () {
            //                 cancelImg();
            //               },
            //               child: Container(
            //                 height: 150,
            //                 width: 150,
            //                 color: Colors.grey.withOpacity(0.2),
            //                 child: Center(
            //                   child: Container(
            //                       child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: <Widget>[
            //                       Text("$imgPercent % loading..",
            //                           style: TextStyle(fontSize: 15)),
            //                       Text("Cancel Upload",
            //                           style: TextStyle(fontSize: 15)),
            //                     ],
            //                   )),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )
            //       : Column(
            //           children: <Widget>[
            //             GestureDetector(
            //               onTap: () {
            //                 pickImage();
            //                // getImage();
            //               },
            //               child: Container(
            //                 height: 150,
            //                 width: 150,
            //                 color: Colors.grey.withOpacity(0.2),
            //                 child: Container(
            //                     child: Icon(
            //                   Icons.photo_camera,
            //                   size: 30,
            //                 )),
            //               ),
            //             ),
            //           ],
            //         ),
            // ),
            // SliverPadding(
            //   padding: EdgeInsets.only(left: 10, right: 10),
            //   sliver: Container(
            //     //color: Colors.redAccent,
            //     child: SliverGrid(
            //       delegate: SliverChildBuilderDelegate(
            //         (BuildContext context, int index) {
            //           return
            //               // _isImage
            //               //     ? Container(
            //               //         padding: const EdgeInsets.all(12.0),
            //               //         margin: EdgeInsets.only(top: 20),
            //               //         decoration: BoxDecoration(
            //               //             shape: BoxShape.circle,
            //               //             border:
            //               //                 Border.all(color: appColor, width: 2)),
            //               //         child: Padding(
            //               //           padding: const EdgeInsets.all(12.0),
            //               //           child: Text(imgPercent.toString() + "%"),
            //               //         ))
            //               //     //  Padding(
            //               //     //     padding: const EdgeInsets.all(8.0),
            //               //     //     child: Center(
            //               //     //       child: CircularProgressIndicator(),
            //               //     //     ))
            //               //     :
            //               imgList.length == 0
            //                   ? Container()
            //                   : Container(
            //                       child: Stack(
            //                         children: <Widget>[
            //                           Container(
            //                             margin: EdgeInsets.only(left: 12),
            //                             child: Container(
            //                               margin: EdgeInsets.only(top: 10),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color: Colors.grey),
            //                                   shape: BoxShape.rectangle),
            //                               child: Container(
            //                                 child: Image.network(
            //                                   // 'assets/images/camera.jpg',
            //                                   // 'http://test.appifylab.com' +
            //                                   imgList[index]['imgUrl'],
            //                                   height: 80,
            //                                   width: 100,
            //                                   fit: BoxFit.cover,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Center(
            //                               child: Container(
            //                                   margin: EdgeInsets.only(
            //                                       top: 100, right: 20),
            //                                   width: 100,
            //                                   child: Text(
            //                                     "Photo ${index + 1}",
            //                                     textAlign: TextAlign.center,
            //                                   ))),
            //                           Container(
            //                             decoration: BoxDecoration(
            //                                 color: Colors.grey.withOpacity(.5),
            //                                 borderRadius:
            //                                     BorderRadius.circular(50)),
            //                             //   alignment: Alignment.topRight,
            //                             child: GestureDetector(
            //                               child: Padding(
            //                                 padding: const EdgeInsets.all(3.0),
            //                                 child: Icon(
            //                                   Icons.close,
            //                                   size: 16,
            //                                 ),
            //                               ),
            //                               onTap: () {
            //                                 _deleteImg(index);
            //                                 // imgList.removeAt(index);
            //                                 // setState(() {}
            //                                 // );
            //                               },
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     );
            //         },
            //         childCount: imgList.length,
            //       ),
            //       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //         maxCrossAxisExtent: 170.0,
            //         mainAxisSpacing: 0.0,
            //         crossAxisSpacing: 0.0,
            //         childAspectRatio: 1.0,
            //       ),
            //     ),
            //   ),
            // ),
            isCameraSelected
                ? SliverToBoxAdapter(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  isCameraSelected
                                      ? pickImage()
                                      : checkingDone? pickImage() : cameraPermission();
                                      // setState(() {
                                      //   PermissionsService().requestContactsPermission(
                                      // onPermissionDenied: () {
                                      //     isDenied = true;
                                      // print('Permission has been denied');
                                      // });
                                     // imgOrVideo();
                                  // });
                                  // getImage();
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
                  )
                : SliverToBoxAdapter(
                    child: _isVideo
                        ? Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  cancelVideo();
                                },
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Center(
                                    child: Container(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            videoPercent.toString() +
                                                "%", //"$videoPercent % ",
                                            style: TextStyle(
                                                fontSize: 15, height: 1.5)),
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
                                  isVideoSelected
                                      ? pickVideo()
                                      : checkingDone? pickVideo() : cameraPermission();
                                      // setState(() {
                                      //   PermissionsService().requestContactsPermission(
                                      // onPermissionDenied: () {
                                      //     isDenied = true;
                                      // print('Permission has been denied');
                                      // });
                                      //imgOrVideo();
                                  // });
                                  // pickVideo();
                                  // pickImage();
                                  // getImage();
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

            isCameraSelected
                ? SliverPadding(
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
                                                margin:
                                                    EdgeInsets.only(top: 10),
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
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              //   alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
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
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    sliver: Container(
                      //color: Colors.redAccent,
                      child: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            initVideo(videoList[index]['videoUrl']);
                            return
                                // _isVideo
                                //     ? Container(
                                //         padding: const EdgeInsets.all(12.0),
                                //         margin: EdgeInsets.only(top: 20),
                                //         decoration: BoxDecoration(
                                //             shape: BoxShape.circle,
                                //             border:
                                //                 Border.all(color: appColor, width: 2)),
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(12.0),
                                //           child: Text(videoPercent.toString() + "%"),
                                //         ))
                                //     //  Padding(
                                //     //     padding: const EdgeInsets.all(8.0),
                                //     //     child: Center(
                                //     //       child: CircularProgressIndicator(),
                                //     //     ))
                                // :
                                videoList.length == 0
                                    ? Container()
                                    :
                                    // _isVideo
                                    // ? Container(
                                    //     padding: const EdgeInsets.all(12.0),
                                    //     margin: EdgeInsets.only(top: 20),
                                    //     decoration: BoxDecoration(
                                    //         shape: BoxShape.circle,
                                    //         border:
                                    //             Border.all(color: appColor, width: 2)),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(12.0),
                                    //       child: Text(videoPercent.toString() + "%"),
                                    //     )):
                                    Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 12),
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            shape: BoxShape
                                                                .rectangle),
                                                        child:
                                                            // initVideo(videoList[index]['videoUrl'])
                                                            // _cameraVideoPlayerController.value.initialized
                                                            // ?
                                                            AspectRatio(
                                                          aspectRatio:
                                                              _cameraVideoPlayerController
                                                                  .value
                                                                  .aspectRatio,
                                                          child: VideoPlayer(
                                                              _cameraVideoPlayerController),
                                                        )
                                                        // : Container()
                                                        // child: Image.network(
                                                        //   // 'assets/images/camera.jpg',
                                                        //   // 'http://test.appifylab.com' +
                                                        //   videoList[index]['videoUrl'],
                                                        //   height: 80,
                                                        //   width: 100,
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                        ),
                                                  ),
                                                  // Center(
                                                  //     child: Container(
                                                  //         margin: EdgeInsets.only(
                                                  //             top: 10, right: 0),
                                                  //         width: 100,
                                                  //         child: Text(
                                                  //         "Video ${index + 1}",
                                                  //           textAlign: TextAlign.center,
                                                  //           style: TextStyle(color: Colors.white, fontSize: 16),
                                                  //         ))),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    //   alignment: Alignment.topRight,
                                                    child: GestureDetector(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        _deleteVideo(index);
                                                        // imgList.removeAt(index);
                                                        // setState(() {}
                                                        // );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, right: 0),
                                                width: 100,
                                                child: Text(
                                                  "Video ${index + 1}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                )),
                                          ],
                                        ),
                                      );
                          },
                          childCount: videoList.length,
                        ),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 170.0,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: (itemWidth / 250), //1.0,
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
                        // if (isCameraSelected == false && isVideoSelected == false) {
                        //   return _showMessage(
                        //       'No picture/video is added, add one!!');
                        // } else {
                        checkSOS();
                        // }
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
                          isLoading ? 'Please Wait...' : 'Send Report',
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
    // if( isDenied == true) {
    //   return _showMessage('No picture/video is added, add one!!');
    // }
    // else
    if (isCameraSelected == false && isVideoSelected == false) {
      return _showMessage('No picture/video is added, add one!!');
    }
    setState(() {
      isLoading = true;
    });

    var items = {
      //"beneficiarId": user['id'],
      "situationId": widget.value['situationId'],
      "messageForAuthorities": widget.value['message'],
      //"status": "Pending",
      "lat": widget.value['lat'],
      "lng": widget.value['lan'],
      "address": widget.value['address'],
      "imgUrl": imgList,
      "videoUrl": videoList,
    };

    var res =
        await CallApi().postData(items, '/app/addPublicReport?token=$token');

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
                              builder: (context) => PublicReporter()));
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

  /////////////////////////// Upload Viedo ///////////////////////////

  // File _pickedVideo;

  Future pickVideo() async {
    // final videoSource = await showDialog<ImageSource>(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text("Select the video source"),
    //           actions: <Widget>[
    //             MaterialButton(
    //               child: Text("Camera"),
    //               onPressed: () => Navigator.pop(context, ImageSource.camera),
    //             ),
    //             MaterialButton(
    //               child: Text("Gallery"),
    //               onPressed: () => Navigator.pop(context, ImageSource.gallery),
    //             )
    //           ],
    //         ));

    // if (videoSource != null) {
    //   var video = await ImagePicker.pickVideo(source: videoSource);
    //   // if (file != null) {
    //   //   setState(() => _pickedImage = file);
    //   // }

    var video = await ImagePicker.pickVideo(source: ImageSource.camera);

    if (video == null) {
    } else {
      _uploadVideo(video);

      setState(() {
        _video = video;
        //  _cameraVideoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
        // setState(() { });
        // _cameraVideoPlayerController.play();
        // });
      });
    }
    //  }
  }

  Future<void> _initializeVideoPlayerFuture;

  void initVideo(String link) {
    _cameraVideoPlayerController = VideoPlayerController.network(link);
    //  _controller.play();
    print(link);
    _initializeVideoPlayerFuture = _cameraVideoPlayerController.initialize();
    // _controller.setLooping(true);
  }

  void _uploadVideo(filePath) async {
    setState(() {
      _isVideo = true;
    });
    var videoApiUrl = '/app/ReporterVideoUpload';
    mainUrl = await CallApi().getUrl();
    fullUrl2 = await CallApi().getUrl() + videoApiUrl;
    tryUrl2 = fullUrl2;
    print("full url is : $fullUrl2");
    print("full url is : $tryUrl2");

    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData = new FormData.from(
          {"videoUrl": new UploadFileInfo(filePath, fileName),
          "url": '$mainUrl',
          });

      Response response = await Dio().post(
          '$tryUrl2',//'http://test.appifylab.com/app/ReporterVideoUpload',//'https://bayanihan.santamariabulacan.org/app/ReporterVideoUpload',//
          data: formData,
          cancelToken: token, onSendProgress: (int sent, int total) {
        //imgPercent=0;
        setState(() {
          videoPercent = ((sent / total) * 100).toInt();

          print("percent");
          print(videoPercent);
        });
      });
      print('this is the response $response');
      print(response.data.toString());

      if (_isCancelVideo == true) {
        _isCancelVideo = false;
      } else {
        setState(() {
          _showVideo = response.data['videoUrl'];
          _isVideo = false;
          videoPercent = 0;
        });
        print('this is the response');
        print(_showVideo);

        videoList.add({'videoUrl': response.data['videoUrl']});
      }
      //     setState(() {
      //   _isImage = false;
      // });
      print('videoList');
      print(videoList);

      // Show the incoming message in snakbar
      //_showMessage(response.data['message']);
      print(response.data.toString());
    } catch (e) {
      print("Exception Caught: $e");
      
    }
  }

  void _deleteVideo(index) {
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
                              videoList.removeAt(index);
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

  void cancelVideo() async {
    print("object");
    setState(() {
      // _isImage = false;
      // _isCancelImg = true;
      _isVideo = false;
      _isCancelVideo = true;
    });
  }

  void imgOrVideo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Select the source ?",
            textAlign: TextAlign.center,
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
                            "Camera",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            pickImage();
                            Navigator.pop(context);
                            isCameraSelected = true;
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
                              "Video",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              pickVideo();
                              Navigator.pop(context);
                              isVideoSelected = true;
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
