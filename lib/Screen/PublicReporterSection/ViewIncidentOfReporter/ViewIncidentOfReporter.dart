import 'package:design_app/RouteTransition/routeAnimation.dart';
import 'package:design_app/Screen/PublicReporterSection/PreviewVideo.dart';
import 'package:design_app/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../PreviewImage.dart';

class ViewIncidentOfReporter extends StatefulWidget {
  final incidentList;
  ViewIncidentOfReporter(this.incidentList);
  @override
  _ViewIncidentOfReporterState createState() => _ViewIncidentOfReporterState();
}

class _ViewIncidentOfReporterState extends State<ViewIncidentOfReporter> {

  List<String> photos = [];
  List<String> videos = [];

  bool _isVideo = false;
  bool _isPhoto = false;

  @override
  void initState() { 
    super.initState();
    photoList();
    videoList();
  }

  photoList() {
    for (int i = 0; i < widget.incidentList.photo.length; i++) {
      photos.add("${widget.incidentList.photo[i].imgUrl}");
    }
    if(photos.length == 0)
    {
      _isVideo = true;
    }
    print('photos areeeeeeeeeeee');
    print(photos);
    print(photos.length);
  }

  videoList() {
    for (int i = 0; i < widget.incidentList.video.length; i++) {
      videos.add("${widget.incidentList.video[i].videoUrl}");
    }
    if(videos.length == 0)
    {
      _isPhoto = true;
    }
    print('videos areeeeeeeeeeee');
    print(videos);
    print(videos.length);
  }

  Future<void> _initializeVideoPlayerFuture;
  VideoPlayerController _cameraVideoPlayerController;

  void initVideo(String link) {
    _cameraVideoPlayerController = VideoPlayerController.network(link);
      _cameraVideoPlayerController.play();
      print(link);
    _initializeVideoPlayerFuture = _cameraVideoPlayerController.initialize();
    // _cameraVideoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _cameraVideoPlayerController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColor, size: 28,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: Text(
            'View Incident',
            style: TextStyle(
                color: appColor,
                fontFamily: "Roboto-Bold",
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///////// text top1//////////
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Situation : ',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.incidentList.situation.situation == null
                                ? "- - -"
                                : "${widget.incidentList.situation.situation}",
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Regular",
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///////// text top2//////////

                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Address : ',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.incidentList.address == null
                                ? "- - -"
                                : "${widget.incidentList.address}",
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Regular",
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///////// text top3//////////

                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'Date : ',
                          style: TextStyle(
                              color: appColor,
                              fontFamily: "Roboto-Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.incidentList.created_at == null
                                ? "- - -"
                                : "${widget.incidentList.created_at}",
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "Roboto-Regular",
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                /////////////   what to share /////////

                Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    padding:
                        EdgeInsets.only(left: 10, right: 15, top: 5, bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 10, bottom: 8),
                            child: Text(
                              'Message For Authorities',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 8, top: 10),
                            padding: EdgeInsets.fromLTRB(12, 20, 8, 35),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white,
                                border: Border.all(width: 1, color: appColor)),
                            child: Text(
                              widget.incidentList.messageForAuthorities == null
                                ? "- - -"
                                : "${widget.incidentList.messageForAuthorities}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            )
                            // child: TextField(
                            //   cursorColor: Colors.grey,
                            //   controller: shareController,
                            //   keyboardType: TextInputType.text,
                            //   // textCapitalization: TextCapitalization.words,
                            //   // autofocus: true,
                            //   style: TextStyle(color: Colors.grey[600]),
                            //   decoration: InputDecoration(
                            //     //hintText: hint,
                            //     // labelText: label,
                            //     // labelStyle: TextStyle(color: appColor),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                            //     border: InputBorder.none,
                            //   ),
                            // )
                            ),
                      ],
                    )),

              Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Feature Image / Video',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: appColor,
                          fontFamily: "Roboto-Regular",
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    )),

                /////////////// image part 1//////////
                  _isPhoto? Container(
                    height: 150,
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 30, right: 40, top: 25),
                    child:
                    // photos == null?
                    // CircularProgressIndicator()
                    // :
                    photos.length == 0 || photos == null
                        ?
                        Center(
                            child: Container(
                                alignment: Alignment.center,
                                height: 100,
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/image/photo_placeholder.png',
                                      height: 70,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("No image found for this donation!"),
                                    ),
                                  ],
                                )))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            //shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return PreviewImage(photos[index]);
                                    }));
                                    // Navigator.push(context,
                                    // SlideLeftRoute(page: PreviewImage(photos[index])));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 12),
                                      child: Image.network(
                                        photos[index],
                                        height: 50,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                            itemCount: photos.length,
                          )):

                /////////////// image part 1//////////
                Container(
                    height: 150,
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 30, right: 10, top: 25, bottom: 30),
                    child: videos.length == 0 || videos == null
                        ?
                        Center(
                            child: Container(
                                alignment: Alignment.center,
                                height: 100,
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/image/photo_placeholder.png',
                                      height: 70,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("No image found for this donation!"),
                                    ),
                                  ],
                                )))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            //shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              initVideo(videos[index]);// initVideo("${widget.incidentList.video[index].videoUrl}");
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return PreviewVideo(videos[index]);
                                    }));
                                    // Navigator.push(context,
                                    // SlideLeftRoute(page: PreviewVideo(photos[index])));
                                  },
                                child: Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child: AspectRatio(
                                              aspectRatio:
                                                  _cameraVideoPlayerController.value.aspectRatio,
                                              child: VideoPlayer(_cameraVideoPlayerController),
                                            )),
                              );},
                            itemCount: videos.length,
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
