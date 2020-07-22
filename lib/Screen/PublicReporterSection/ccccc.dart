// import 'dart:convert';
// import 'dart:io';


// import 'package:bahrain_admin/KeyValueModel.dart';
// import 'package:bahrain_admin/Model/CategoryModel/CategoryModel.dart';
// import 'package:bahrain_admin/Model/SubCategoryModel/SubCategoryModel.dart';
// import 'package:bahrain_admin/Screen/ProductPage/ProductList.dart';
// import 'package:bahrain_admin/api/api.dart';
// import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
// import 'package:bahrain_admin/main.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart' as imgPick;
// import 'package:intl/intl.dart';
// import 'package:multi_media_picker/multi_media_picker.dart';
// import 'package:path/path.dart' as Path;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_parser/youtube_parser.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'dart:async';

// enum PhotoCrop {
//   free,
//   picked,
//   cropped,
// }

// class AddProductform extends StatefulWidget {
//   @override
//   _AddProductformState createState() => _AddProductformState();
// }

// class _AddProductformState extends State<AddProductform> {
//   TextEditingController nameController = new TextEditingController();
//   TextEditingController descriptionController = new TextEditingController();
//   TextEditingController priceController = new TextEditingController();
//   TextEditingController costController = new TextEditingController();
//   TextEditingController colorController = new TextEditingController();
//   TextEditingController sizeController = new TextEditingController();
//   TextEditingController stockController = new TextEditingController();
//   TextEditingController warrentyController = new TextEditingController();
//   TextEditingController utubeController = new TextEditingController();
//   // TextEditingController statusController = new TextEditingController();

//   ////////////// video //////////

//   TextEditingController _seekToController;

//   PlayerState _playerState;
//   YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;
//   int imgNum=0;
//   int count = 0;
//   String _sound = "";

//   /////////////// video/////////////////

//   String videoType = "";
//   String categoryName = "";
//   var categoryId = "";
//   var userId;
//   var customerId;
//   var categorysData;
//   var _showImage;
//   bool _subCatDrop = false;
//   bool _catDrop = false;
//   KeyValueModel categoryModel;
//   List<KeyValueModel> categoryList = <KeyValueModel>[];
//   bool _multiImage = false;

//   int imgPercent = 1;
//   int videoPercent = 1;
//   List videoList = [];
//   List imgList = [];

//   CancelToken token = CancelToken();
//   var dio = new Dio();
//   bool _buttonVideoType = false;
//   bool _isImage = false;
//   bool _isVideo = false;
//   bool _isCancelImg = false;
//   bool _isCancelVideo = false;

//   String subcategoryName = "";
//   var subcategoryId = "";
//   var subuserId;
//   var subcustomerId;
//   var subcategoryData;
//   SubKeyValueModel subcategoryModel;
//   List<SubKeyValueModel> subcategoryList = <SubKeyValueModel>[];
//   //final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   //List categoryList = [];
//   _showMsg(msg) {
//     //
//     final snackBar = SnackBar(
//       content: Text(msg),
//       action: SnackBarAction(
//         label: 'Close',
//         onPressed: () {
//           // Some code to undo the change!
//         },
//       ),
//     );
//     //Scaffold.of(context).showSnackBar(snackBar);
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   bool _isLoading = false;
//   var body;
//   var categoryData;
//   var localCategoryData;
//   SharedPreferences localStorage;
//   List<Object> images = List<Object>();
//   Future<File> _imageFile;
//   List img = [];

//   File _image;
//   File _cameraImage;
//   File _video;
//   File _cameraVideo;

//   VideoPlayerController _videoPlayerController;
//   VideoPlayerController _cameraVideoPlayerController;

// //BuildContext context;
//   String _platformMessage = 'No Error';
//   //List images;
//   int maxImageNo = 10;
//   bool selectSingleImage = false;
//   void listener() {
//     if (_isPlayerReady && mounted && !_ucontroller.value.isFullScreen) {
//       setState(() {
//         _playerState = _ucontroller.value.playerState;

//         _videoMetaData = _ucontroller.metadata;
//       });
//     }
//   }

//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     print("object_deactivate");
//     // _ucontroller.pause();
//     super.deactivate();
//   }

//   @override
//   void dispose() {
   
//     super.dispose();
//   }

//   // This funcion will helps you to pick a Video File
//   _pickVideo() async {
  
//    File video = await imgPick.ImagePicker.pickVideo(source: imgPick.ImageSource.gallery); // ImagePicker.pickVideo(source: ImageSource.gallery);
//     if (video == null) {
//       print("null");
//     } else {
//         print("video");
    
//       _uploadVideo(video);
//       _video = video;
//     }
//   }

//   Future getImageMulti() async {
//     var images = await MultiMediaPicker.pickImages(source: ImageSource.gallery);

   
   
//     if(images!=null){
//        setState(() {
//       _isImage = true;
//     });
//        for (int i = 0; i < images.length; i++) {
//       _uploadImg(images[i], images.length, i);
//     }
//    }

  
//   }

//   YoutubePlayerController _ucontroller;

//   @override
//   void initState() {
//     utubeController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//     setState(() {
//       images.add("Add Image");
//     });
//     imgPercent = 1;
//     videoPercent = 0;
//     print(images);
//     state = PhotoCrop.free;
//     format = DateFormat("yyyy-MM-dd").format(selectedDate);

//     _showCategory();

//     if (store.state.categoryListsRedux.length != 0) {
//       // categoryModel = store.state.categoryListsRedux[0];
//       for (int i = 0; i < store.state.categoryListsRedux.length; i++) {
//         categoryList.add(KeyValueModel(
//             key: "${store.state.categoryListsRedux[i].name}",
//             value: "${store.state.categoryListsRedux[i].id}"));
//       }
//     }

//     // super.initState();
//   }

//   Future<void> _showCategory() async {
//     setState(() {
//       _catDrop = true;
//     });

//     var res = await CallApi().getData('/app/indexCategory');
//     body = json.decode(res.body);

//     if (res.statusCode == 200) {
//       var category = CategoryModel.fromJson(body);
//       if (!mounted) return;
//       setState(() {
//         categoryData = category.category;
//         _isLoading = false;
//       });

//       for (int i = 0; i < categoryData.length; i++) {
//         categoryList.add(KeyValueModel(
//             key: "${categoryData[i].name}", value: "${categoryData[i].id}"));
//       }
//     }

//     setState(() {
//       _catDrop = false;
//     });
//   }

//   // //////////////// get  products end ///////////////

//   Future<void> _showsubCategory() async {
//     // var key = 'subcategory-list';
//     // await _getLocalsubCategoryData(key);

//     setState(() {
//       _subCatDrop = true;
//     });

//     var res = await CallApi()
//         .getData('/app/showsubCategoryforProduct?categoryId=$categoryId');
//     body = json.decode(res.body);

//     if (res.statusCode == 200) {
//       //_subcategoryState();

//       var subcategory = SubCategoryModel.fromJson(body);
//       if (!mounted) return;
//       setState(() {
//         subcategoryData = subcategory.subCategoryforProduct;
//         _isLoading = false;
//       });

//       for (int i = 0; i < subcategoryData.length; i++) {
//         subcategoryList.add(SubKeyValueModel(
//             key: "${subcategoryData[i].name}",
//             value: "${subcategoryData[i].id}"));
//       }


//     }

//     setState(() {
//       _subCatDrop = false;
//     });
//   }

//   //////////////// get  products end ///////////////

//   /// Define
//   //List images;
//   // int maxImageNo = 5;
//   // bool selectSingleImage = false;
//   var imgs;
//   bool _cat = false;

//   PhotoCrop state;
//   File imageFile;
//   String image;
//   var imagePath;

//   String date = '';

//   DateTime selectedDate = DateTime.now();
//   var format;

//   Container addProductCon(String label, String hint,
//       TextEditingController control, TextInputType type) {
//     return Container(
//         padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
//         child: Column(
//           children: <Widget>[
//             Container(
//                 alignment: Alignment.topLeft,
//                 margin: EdgeInsets.only(left: 10, bottom: 8),
//                 child: Text(label,
//                     textAlign: TextAlign.left,
//                     style: TextStyle(color: appColor, fontSize: 13))),
//             Container(
//                 margin: EdgeInsets.only(left: 8, top: 0),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                     color: Colors.grey[100],
//                     border: Border.all(width: 0.2, color: Colors.grey)),
//                 child: TextField(
//                   cursorColor: Colors.grey,
//                   controller: control,
//                   keyboardType: type,
//                   // textCapitalization: TextCapitalization.words,
//                   // autofocus: true,
//                   style: TextStyle(color: Colors.grey[600]),
//                   decoration: InputDecoration(
//                     hintText: hint,
//                     // labelText: label,
//                     // labelStyle: TextStyle(color: appColor),
//                     contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
//                     border: InputBorder.none,
//                   ),
//                 )),
//           ],
//         ));
//   }

//   Future<Null> _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         //  locale: Locale("yyyy-MM-dd"),
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         date = "${DateFormat("dd - MMMM - yyyy").format(selectedDate)}";
//       });
//   }

//   VideoPlayerController _controller;
//   Future<void> _initializeVideoPlayerFuture;

// //   int c1 = 0, c2 = 0, idx = 0;
// // int last = 1;
// //     int first = 1;
//   void initVideo(String link) {
//     _controller = VideoPlayerController.network(link);
//     //  _controller.play();

//     _initializeVideoPlayerFuture = _controller.initialize();

//     // _controller.setLooping(true);
//   }

//   void sound() {
//     // _ucontroller.dispose();
//     print("sound");
//     print(_sound);
//   }

//   void utube(String link) {
//     String utubelink = getIdFromUrl(link);
//     // print("test link");
//     // print(utubelink);
//     _ucontroller = YoutubePlayerController(
//       initialVideoId: utubelink,
//       flags: YoutubePlayerFlags(
//         mute: false,
//         autoPlay: false,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHideAnnotation: true,
//       ),
//     )..addListener(listener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: appColor,
//         title: Text("Add Product"),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.only(bottom: 30),
//           child: Column(
//             children: <Widget>[
//               _isImage
//                   ? Container(
//                       padding: const EdgeInsets.all(12.0),
//                       margin: EdgeInsets.only(top: 20),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: appColor, width: 2)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Text(imgPercent.toString() + "%"),
//                       ))
//                   //  Padding(
//                   //     padding: const EdgeInsets.all(8.0),
//                   //     child: Center(
//                   //       child: CircularProgressIndicator(),
//                   //     ))
//                   : imgList.length == 0
//                       ? Container()
//                       : Container(
//                           height: 150,
//                           margin: EdgeInsets.only(top: 5, bottom: 10),
//                           padding: EdgeInsets.only(top: 2, bottom: 2),
//                           child: ListView.builder(
//                             physics: BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (BuildContext context, int index) =>
//                                 Stack(
//                               children: <Widget>[
//                                 Container(
//                                   margin: EdgeInsets.only(left: 12),
//                                   child: Container(
//                                     margin: EdgeInsets.only(top: 10),
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.grey),
//                                         shape: BoxShape.rectangle),
//                                     child: Container(
//                                       child: Image.network(
//                                         // 'assets/images/camera.jpg',
//                                         imgList[index]['link'],
//                                         height: 120,
//                                         width: 160,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: 0,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey.withOpacity(.5),
//                                         borderRadius:
//                                             BorderRadius.circular(50)),
//                                     //   alignment: Alignment.topRight,
//                                     child: GestureDetector(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(3.0),
//                                         child: Icon(Icons.close),
//                                       ),
//                                       onTap: () {
//                                         _deleteImg(index);
//                                         // imgList.removeAt(index);
//                                         // setState(() {}
//                                         // );
//                                       },
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             itemCount: imgList.length,
//                           )),

//               _isImage
//                   ? RaisedButton.icon(
//                       color: Colors.blueGrey,
//                       onPressed: () {
//                         cancelImg();
//                       },
//                       icon: new Icon(Icons.image, color: Colors.white),
//                       label: new Text(
//                         "Cancel Uploading",
//                         style: TextStyle(color: Colors.white),
//                       ))
//                   : RaisedButton.icon(
//                       color: Colors.blueGrey,
//                       onPressed: () {
//                         //  Toast.show("It allows png file only", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//                         // loadAssets();
//                         //  initMultiPickUp();
//                         // getImage();
//                         getImageMulti();
//                       },
//                       icon: new Icon(Icons.image, color: Colors.white),
//                       label: new Text(
//                         "Add Product Image",
//                         style: TextStyle(color: Colors.white),
//                       )),

//               SizedBox(
//                 height: 5,
//               ),
//               // Container(
//               //   child: buildGridView(),
//               // ),
//               // if (_video != null)

//               _isVideo
//                   ? Container(
//                       padding: const EdgeInsets.all(12.0),
//                       margin: EdgeInsets.only(top: 20),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: appColor, width: 2)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Text(videoPercent.toString() + "%"),
//                       ))
//                   : videoList.length == 0
//                       ? Container()
//                       : Container(
//                           height: 150,
//                           margin: EdgeInsets.only(top: 5, bottom: 10),
//                           padding: EdgeInsets.only(top: 2, bottom: 2),
//                           child: ListView.builder(
//                             physics: BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (BuildContext context, int index) {
//                               _sound == ""
//                                   ? videoList[index]['type'] == "upload"
//                                       ? initVideo(videoList[index]['link'])
//                                       : utube(videoList[index]['link'])
//                                   : sound();
//                               //  : _playUtubeVideo(videoList[index]['link']);

//                               return Stack(
//                                 children: <Widget>[
//                                   videoList[index]['type'] == "upload"
//                                       ? Container(
//                                           margin: EdgeInsets.only(left: 12),
//                                           child: AspectRatio(
//                                             aspectRatio:
//                                                 _controller.value.aspectRatio,
//                                             child: VideoPlayer(_controller),
//                                           ))
//                                       :
//                                       // Container(

//                                       //   child: Text("you tube"),
//                                       // )
//                                       YoutubePlayer(
//                                           controller: _ucontroller,
//                                           showVideoProgressIndicator: false,
//                                           //progressIndicatorColor: Colors.blueAccent,
//                                           topActions: <Widget>[
//                                             SizedBox(width: 8.0),
//                                           ],
//                                           onReady: () {
//                                             // print("dfsifugsdf");
//                                             if (_sound == "") {
//                                               setState(() {
//                                                 _isPlayerReady = true;
//                                               });
//                                             } else if (_sound == "no") {
//                                               setState(() {
//                                                 _isPlayerReady = false;
//                                                 print("no sound for paly");
//                                               });
//                                             }

//                                             // print(_isPlayerReady);
//                                           },
//                                         ),
//                                   Positioned(
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         _deleteVideo(index);
//                                       },
//                                       child: Container(
//                                           alignment: Alignment.topRight,
//                                           padding: EdgeInsets.all(5),
//                                           child: Container(
//                                             padding: EdgeInsets.all(2),
//                                             decoration: BoxDecoration(
//                                                 color: Colors.black
//                                                     .withOpacity(0.4),
//                                                 borderRadius:
//                                                     BorderRadius.circular(15)),
//                                             child: Icon(
//                                               Icons.close,
//                                               size: 25,
//                                               color: Colors.white,
//                                             ),
//                                           )),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                             itemCount: videoList.length,
//                           )),

//               videoType == "gallery"
//                   ? _isVideo
//                       ? Container(
//                           //  color: appColor,
//                           child: RaisedButton.icon(
//                               color: Colors.blueGrey,
//                               onPressed: () {
//                                 cancelVideo();
//                               },
//                               icon:
//                                   new Icon(Icons.videocam, color: Colors.white),
//                               label: new Text(
//                                 "Cancel Uploading",
//                                 style: TextStyle(color: Colors.white),
//                               )))
//                       : Container(
//                           //  color: appColor,
//                           child: RaisedButton.icon(
//                               color: Colors.blueGrey,
//                               onPressed: () {
//                                 _pickVideo();
//                               },
//                               icon:
//                                   new Icon(Icons.videocam, color: Colors.white),
//                               label: new Text(
//                                 "Add Product Video From gallery",
//                                 style: TextStyle(color: Colors.white),
//                               )))
//                   : videoType == "youtube"
//                       ? Container(
//                           padding: EdgeInsets.only(
//                               left: 15, right: 15, top: 5, bottom: 5),
//                           child: Container(
//                               child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                   alignment: Alignment.topLeft,
//                                   margin: EdgeInsets.only(left: 10, bottom: 8),
//                                   child: Text("You tube Video url",
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(
//                                           color: appColor, fontSize: 13))),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Container(
//                                       alignment: Alignment.topLeft,
//                                       width: (MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2) +
//                                           (MediaQuery.of(context).size.width /
//                                               4),
//                                       margin: EdgeInsets.only(left: 8, top: 0),
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(5.0)),
//                                           color: Colors.grey[100],
//                                           border: Border.all(
//                                               width: 0.2, color: Colors.grey)),
//                                       child: TextField(
//                                         cursorColor: Colors.grey,
//                                         controller: utubeController,
//                                         keyboardType: TextInputType.text,
//                                         style:
//                                             TextStyle(color: Colors.grey[600]),
//                                         decoration: InputDecoration(
//                                           contentPadding: EdgeInsets.fromLTRB(
//                                               15.0, 10.0, 20.0, 15.0),
//                                           border: InputBorder.none,
//                                         ),
//                                       )),
//                                   Container(
//                                       alignment: Alignment.center,
//                                       child: IconButton(
//                                           icon: Icon(Icons.add_box,
//                                               color: appColor),
//                                           onPressed: () {
//                                             _addToYoutube();
//                                           })),
//                                 ],
//                               ),
//                             ],
//                           )),
//                         )
//                       : Container(),

//               Container(
//                 margin: EdgeInsets.only(left: 20),
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(top: 15, bottom: 10),
//                       child: Row(
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 videoType = "gallery";
//                               });
//                             },
//                             child: Icon(
//                               videoType == "gallery"
//                                   ? Icons.radio_button_checked
//                                   : Icons.radio_button_unchecked,
//                               color: appColor,
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text(
//                               //"\$ 5678",
//                               "Add video from gallery",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: appColor,
//                                   fontFamily: "sourcesanspro",
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(top: 15, bottom: 10),
//                       child: Row(
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 videoType = "youtube";
//                               });
//                             },
//                             child: Icon(
//                               videoType == "youtube"
//                                   ? Icons.radio_button_checked
//                                   : Icons.radio_button_unchecked,
//                               color: appColor,
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text(
//                               //"\$ 5678",
//                               "Add video from you tube",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: appColor,
//                                   fontFamily: "sourcesanspro",
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 15),

//               addProductCon(
//                   " Product Name", "", nameController, TextInputType.text),
//               addProductCon(" Description", "", descriptionController,
//                   TextInputType.text),
//               addProductCon(
//                   " Price", "", priceController, TextInputType.number),
//               addProductCon(" Cost", "", costController, TextInputType.number),
//               // addProductCon(" Size", "", sizeController, TextInputType.text),
//               // addProductCon(" Color", "", colorController, TextInputType.text),
//               addProductCon(
//                   " Stock", "", stockController, TextInputType.number),

//               _catDrop
//                   ? Container(
//                       alignment: Alignment.topCenter,
//                       margin: EdgeInsets.only(bottom: 8, top: 30),
//                       child: Text("Please wait to select Category...",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(color: appColor, fontSize: 15)))
//                   : Column(
//                       children: <Widget>[
//                         Container(
//                           //  color: Colors.blue,
//                           margin: EdgeInsets.only(
//                               right: 15, left: 30, bottom: 0, top: 10),
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Category: ",
//                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                                 color: appColor,
//                                 fontFamily: "sourcesanspro",
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 42,
//                           margin: EdgeInsets.only(
//                               left: 20, right: 15, top: 6, bottom: 6),
//                           decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5.0)),
//                               color: Colors.grey[100],
//                               border:
//                                   Border.all(width: 0.2, color: Colors.grey)),
//                           //  borderRadius: BorderRadius.circular(20),
//                           // color: Colors.white),
//                           //  alignment: Alignment.center,
//                           child: DropdownButtonHideUnderline(
//                             child: ButtonTheme(
//                               // alignedDropdown: true,

//                               child: DropdownButton<KeyValueModel>(
//                                 items: categoryList.map((KeyValueModel user) {
//                                   return new DropdownMenuItem<KeyValueModel>(
//                                     value: user,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(left: 15),
//                                       child: new Text(
//                                         user.key,
//                                         style: new TextStyle(
//                                             color: Colors.grey[600],
//                                             fontSize: 15),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 // items: categoryNameList
//                                 //     .map((data) => DropdownMenuItem<String>(
//                                 //           child: Text(data.key),
//                                 //          // key: data.key.,
//                                 //           value: data.key,
//                                 //         ))
//                                 //     .toList(),
//                                 onChanged: (KeyValueModel value) {
//                                   setState(() {
//                                     categoryModel = value;
//                                     categoryName = categoryModel.key;
//                                     categoryId = categoryModel.value;
//                                     subcategoryList = [];
//                                     subcategoryName = "";
//                                   });

//                                   print(categoryId);

//                                   _showsubCategory();
//                                 },
//                                 // hint: Text('Select Category'),
//                                 value: categoryModel,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//               //  ),

//               //// sub category//

//               _subCatDrop
//                   ? Container(
//                       alignment: Alignment.topCenter,
//                       margin: EdgeInsets.only(bottom: 8, top: 30),
//                       child: Text("Please wait to select Sub-Category...",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(color: appColor, fontSize: 15)))
//                   : Column(
//                       children: <Widget>[
//                         Container(
//                           //  color: Colors.blue,
//                           margin: EdgeInsets.only(
//                               right: 15, left: 30, bottom: 0, top: 10),
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Sub-Category: ",
//                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                                 color: appColor,
//                                 fontFamily: "sourcesanspro",
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         Container(
//                           //color: Colors.yellow,
//                           width: MediaQuery.of(context).size.width,
//                           height: 42,
//                           margin: EdgeInsets.only(
//                               left: 20, right: 15, top: 6, bottom: 6),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5.0)),
//                                 color: Colors.grey[100],
//                                 border:
//                                     Border.all(width: 0.2, color: Colors.grey)),
//                             //  borderRadius: BorderRadius.circular(20),
//                             // color: Colors.white),
//                             //  alignment: Alignment.center,
//                             child: DropdownButtonHideUnderline(
//                               child: ButtonTheme(
//                                 //alignedDropdown: true,
//                                 child: DropdownButton<SubKeyValueModel>(
//                                   items: subcategoryList
//                                       .map((SubKeyValueModel subuser) {
//                                     return new DropdownMenuItem<
//                                             SubKeyValueModel>(
//                                         value: subuser,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(left: 15),
//                                           child: new Text(
//                                             subuser.key,
//                                             style: new TextStyle(
//                                                 color: Colors.grey[600],
//                                                 fontSize: 15),
//                                           ),
//                                         ));
//                                   }).toList(),
//                                   // items: categoryNameList
//                                   //     .map((data) => DropdownMenuItem<String>(
//                                   //           child: Text(data.key),
//                                   //          // key: data.key.,
//                                   //           value: data.key,
//                                   //         ))
//                                   //     .toList(),
//                                   onChanged: (SubKeyValueModel value) {
//                                     setState(() {
//                                       subcategoryModel = value;
//                                       subcategoryName = subcategoryModel.key;
//                                       subcategoryId = subcategoryModel.value;
//                                     });

//                                     //_showsubCategory();
//                                   },
//                                   //  hint: Text('Select Subcategory'),
//                                   value: subcategoryModel,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//               ////////////   warrenty start

//               addProductCon(
//                   " Warranty", "", warrentyController, TextInputType.text),

//               GestureDetector(
//                 onTap: () {
//                   setState(() {});
//                   _isLoading ? null : _addProducts();
//                 },
//                 child: Container(
//                   margin:
//                       EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 25),
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                       color: appColor.withOpacity(0.9),
//                       border: Border.all(width: 0.2, color: Colors.grey)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Icon(
//                         Icons.create_new_folder,
//                         size: 20,
//                         color: Colors.white,
//                       ),
//                       Container(
//                           margin: EdgeInsets.only(left: 5),
//                           child: Text(_isLoading ? "Creating..." : "Create",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 17)))
//                     ],
//                   ),
//                 ),
//               ),

//               /////////////////   profile editing save end ///////////////
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _addProducts() async {
//     if (nameController.text.isEmpty) {
//       return _showMsg("Product Name is empty");
//     } else if (descriptionController.text.isEmpty) {
//       return _showMsg("Product Description is empty");
//     } else if (priceController.text.isEmpty) {
//       return _showMsg("Product Price is empty");
//     } else if (costController.text.isEmpty) {
//       return _showMsg("Product Cost is empty");
//     }
//     // else if (sizeController.text.isEmpty) {
//     //   return _showMsg("Product Size is empty");
//     // }
//     //  else if (colorController.text.isEmpty) {
//     //   return _showMsg("Product Color is empty");
//     // }
//     else if (stockController.text.isEmpty) {
//       return _showMsg("Product stock is empty");
//     } else if (categoryId == "") {
//       return _showMsg("Product Category is empty");
//     }
//     else if (subcategoryId == "") {
//       return _showMsg("Product Sub-Category is empty");
//     }
//     else if (imgList.length == 0) {
//       return _showMsg("Upload Product Image");
//     }

//     setState(() {
//       _isLoading = true;
//     });
//     //  for (int i=0;i<videoList.length;i++){
//     //   print("fef");

//     //   if(videoList[i]['type']=='youtube'){

//     //  print(videoList[i]['type']);
//     //  print(videoList[i]['link']);
//     //        var videoId = YoutubePlayer.convertUrlToId(
//     //               videoList[i]['link']
//     //             );
//     //       _ucontroller.cue(videoId);
//     //   }
//     // }

//     var data = {
//       'name': nameController.text,
//       'description': descriptionController.text,
//       // 'color': colorController.text,
//       // 'size': sizeController.text,
//       'price': priceController.text,
//       'cost': costController.text,
//       'stock': stockController.text,
//       'warranty': warrentyController.text,
//       'uploadList': imgList,
//       'videotList': videoList,
//       'isNew': 1,
//       'isFetured': 1,
//       'categoryId': categoryId,
//       'subCategoryId': subcategoryId,
//       'image': imgList[0]['link']
//     };

//     print(data);

//     var res = await CallApi().postData(data, '/app/storeProduct');

//     var body = json.decode(res.body);
//     print(body);

//     if (res.statusCode == 422) {
//       _showMsg(body['message']);
//     } else {
//       //  if (body['success'] == true) {
//       if (res.statusCode == 200) {
//         //  deactivate();
//         _showSuccess();
//       } 
     
//       else {
//         _showMsg("Something is wrong! Try Again");
//       }
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void cancelImg() async {
//     print("object");

//     setState(() {
//       _isImage = false;
//       _isCancelImg = true;
//     });
//   }

//   void cancelVideo() async {
//     setState(() {
//       _isVideo = false;
//       _isCancelVideo = true;
//     });
//   }

//   void _uploadImg(filePath, int len, int index) async {
//     // setState(() {
//     //   _isImage = true;
//     // });
//     // print("path");
//     // print(filePath.path);

//     try {
//       String fileName = Path.basename(filePath.path);
//       print("File base name: $fileName");

//       FormData formData =
//           new FormData.from({"img": new UploadFileInfo(filePath, fileName)});
//       print("formData");
//       print(formData);
//       Response response = await Dio().post(
//           'https://admin.bahrainunique.com/app/upload',
//           data: formData,
//           cancelToken: token, onSendProgress: (int sent, int total) {
//         //imgPercent=0;
//         setState(() {
//           imgPercent = ((sent / total) * 100).toInt();

//           print("percent");
//           print(imgPercent);
//         });
//       });

//       if (_isCancelImg == true) {
//         _isCancelImg = false;
//       } else {
//         setState(() {
//           _showImage = response.data['imageUrl'];
//           // _isImage = false;
//           imgPercent = 0;
//         });
//         print(_showImage);

//         imgList.add({'link': response.data['imageUrl']});
//         if ((imgList.length-imgNum) == len) {
//           print("if");
//           setState(() {
//             _isImage = false;
//              imgNum= imgNum+len;
//           });
//         }
//       }
//       // setState(() {
//       //   _isImage = false;
//       // });
//       print(imgList);
//     } catch (e) {
//       // print("Exception Caught: $e");
//     }
//   }

//   void _addToYoutube() {
//     videoList.add({'link': utubeController.text, 'type': 'youtubelink'});

//     setState(() {
//       _isVideo = false;
//       utubeController.text = "";
//     });

//     print(videoList);
//   }

//   void _uploadVideo(filePath) async {
//     setState(() {
//       _isVideo = true;
//     });

//     print("video");
//     print(_isVideo);

//     String fileName = Path.basename(filePath.path);
//     print("File base name: $fileName");

//     try {
//       FormData formData =
//           new FormData.from({"video": new UploadFileInfo(filePath, fileName)});

//       Response response = await Dio().post(
//           'https://admin.bahrainunique.com/app/videoUpload',
//           data: formData,
//           // cancelToken: token,

//           onSendProgress: (int sent, int total) {
//         setState(() {
//           videoPercent = ((sent / total) * 100).toInt();
//         });
//         // print("$sent $total");
//       });

//       print("File upload response: $response");

//       if (_isCancelVideo == true) {
//         _isCancelVideo = false;
//       } else {
//         videoList.add({'link': response.data['videoUrl'], 'type': 'upload'});

//         setState(() {
//           _isVideo = false;
//           videoPercent = 0;
//         });
//       }
//       print(videoList);

//       // Show the incoming message in snakbar
//      // _showMsg(response.data['message']);
//     } catch (e) {
//       print("Exception Caught: $e");
//     }
//   }

//   void _deleteImg(index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           contentPadding: EdgeInsets.all(5),
//           title: Text(
//             "Are you sure want to remove this?",
//             // textAlign: TextAlign.,
//             style: TextStyle(
//                 color: Color(0xFF000000),
//                 fontFamily: "grapheinpro-black",
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500),
//           ),
//           content: Container(
//               height: 70,
//               width: 250,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         width: 110,
//                         height: 45,
//                         margin: EdgeInsets.only(
//                           top: 25,
//                           bottom: 15,
//                         ),
//                         child: OutlineButton(
//                           child: new Text(
//                             "No",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           color: Colors.white,
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5),
//                           shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(20.0)),
//                         )),
//                     Container(
//                         decoration: BoxDecoration(
//                           color: appColor.withOpacity(0.9),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         width: 110,
//                         height: 45,
//                         margin: EdgeInsets.only(top: 25, bottom: 15),
//                         child: OutlineButton(
//                             // color: Colors.greenAccent[400],
//                             child: new Text(
//                               "Yes",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             onPressed: () {
//                               imgList.removeAt(index);
//                               setState(() {});
//                               Navigator.pop(context);
//                               // _deleteOrders();
//                             },
//                             borderSide:
//                                 BorderSide(color: Colors.green, width: 0.5),
//                             shape: new RoundedRectangleBorder(
//                                 borderRadius: new BorderRadius.circular(20.0))))
//                   ])),
//         );
//         //return SearchAlert(duration);
//       },
//     );
//   }

//   void _deleteVideo(index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           contentPadding: EdgeInsets.all(5),
//           title: Text(
//             "Are you sure want to remove this?",
//             // textAlign: TextAlign.,
//             style: TextStyle(
//                 color: Color(0xFF000000),
//                 fontFamily: "grapheinpro-black",
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500),
//           ),
//           content: Container(
//               height: 70,
//               width: 250,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         width: 110,
//                         height: 45,
//                         margin: EdgeInsets.only(
//                           top: 25,
//                           bottom: 15,
//                         ),
//                         child: OutlineButton(
//                           child: new Text(
//                             "No",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           color: Colors.white,
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5),
//                           shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(20.0)),
//                         )),
//                     Container(
//                         decoration: BoxDecoration(
//                           color: appColor.withOpacity(0.9),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         width: 110,
//                         height: 45,
//                         margin: EdgeInsets.only(top: 25, bottom: 15),
//                         child: OutlineButton(
//                             // color: Colors.greenAccent[400],
//                             child: new Text(
//                               "Yes",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             onPressed: () {
//                               videoList.removeAt(index);
//                               setState(() {});
//                               Navigator.pop(context);
//                               // _deleteOrders();
//                             },
//                             borderSide:
//                                 BorderSide(color: Colors.green, width: 0.5),
//                             shape: new RoundedRectangleBorder(
//                                 borderRadius: new BorderRadius.circular(20.0))))
//                   ])),
//         );
//         //return SearchAlert(duration);
//       },
//     );
//   }

//   void _showSuccess() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           contentPadding: EdgeInsets.all(5),
//           title: Column(
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   ////////////   Address  start ///////////

//                   ///////////// Address   ////////////

//                   Container(
//                       alignment: Alignment.topLeft,
//                       margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
//                       child: Text("Your Product has been uploaded successfully",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(color: appColor, fontSize: 15))),
//                 ],
//               ),
//             ],
//           ),
//           content: Container(
//               height: 70,
//               width: 250,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         width: 80,
//                         height: 45,
//                         margin: EdgeInsets.only(
//                           top: 25,
//                           bottom: 15,
//                         ),
//                         child: OutlineButton(
//                           child: new Text(
//                             "Ok",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           color: Colors.white,
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             Navigator.push(
//                                 context, SlideLeftRoute(page: ProductList()));
//                           },
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5),
//                           shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(20.0)),
//                         )),
//                   ])),
//         );
//         //return SearchAlert(duration);
//       },
//     );
//   }

//   Widget get _space => SizedBox(height: 10);

//   Widget _loadCueButton(String action) {
//     return MaterialButton(
//       color: Colors.blueAccent,
//       onPressed: _isPlayerReady
//           ? () {
//               print("fes");
//               if (utubeController.text.isNotEmpty) {
//                 print(utubeController.text);
//                 var id = YoutubePlayer.convertUrlToId(
//                   utubeController.text,
//                 );
//                 if (action == 'LOAD') _ucontroller.load(id);
//                 if (action == 'CUE') _ucontroller.cue(id);
//                 FocusScope.of(context).requestFocus(FocusNode());
//               } else {
//                 _showSnackBar('Source can\'t be empty!');
//               }
//             }
//           : null,
//       disabledColor: Colors.grey,
//       disabledTextColor: Colors.black,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14.0),
//         child: Text(
//           action,
//           style: TextStyle(
//             fontSize: 18.0,
//             color: Colors.white,
//             fontWeight: FontWeight.w300,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   void _showSnackBar(String message) {
//     _scaffoldKey.currentState.showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 16.0,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         behavior: SnackBarBehavior.floating,
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//     );
//   }
// }