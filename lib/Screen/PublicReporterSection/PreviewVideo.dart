import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  final index;
  PreviewVideo(this.index);
  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  // @override
  // void initState() {
  //   super.initState();
  //   _initializeVideoPlayerFuture = _cameraVideoPlayerController.initialize();
  // }

  // Future<void> _initializeVideoPlayerFuture;
  // VideoPlayerController _cameraVideoPlayerController;

  // void initVideo(String link) {
  //   _cameraVideoPlayerController = VideoPlayerController.network(link);
  //     _cameraVideoPlayerController.play();
  //     print(link);
  //   _initializeVideoPlayerFuture = _cameraVideoPlayerController.initialize();
  //   // _cameraVideoPlayerController.setLooping(true);
  // }

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.index)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.pause();
        });
      });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
    // return Container(
    //   color: Colors.white,
    // //   child: Container(
    // //     margin: EdgeInsets.all(10),
    // //     // color: Colors.white,
    // //     padding: EdgeInsets.only(top: 30, bottom: 20),
    // //       child: Image.network(
    // //     widget.index,
    // //     // height: 50,
    // //     // width: 100,
    // //     fit: BoxFit.cover,
    // //   )),
    // // );
    //  child: Container(
    //     margin: EdgeInsets.all(10),
    //     // color: Colors.white,
    //     padding: EdgeInsets.only(top: 30, bottom: 20),
    //      child: Container(
    //                                         margin: EdgeInsets.only(left: 12),
    //                                         child: AspectRatio(
    //                                           aspectRatio:
    //                                               _cameraVideoPlayerController.value.aspectRatio,
    //                                           child: VideoPlayer(_cameraVideoPlayerController),
    //                                         )),),
    // );
  }
}

// Container(
//               alignment: Alignment.center,
//              // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
//               child: IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _controller.value.isPlaying
//                         ? _controller.pause()
//                         : _controller.play();
//                   });
//                 },
//                 icon: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                     color: Colors.grey
//                   ),
//                   child: Stack(
//                     children: <Widget>[
//                       Icon(
//                         _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                         size: 50,
//                         color: Colors.white
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
