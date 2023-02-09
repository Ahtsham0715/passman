import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../media files/controllers/video_player_controller.dart';

class FullScreenVideoPage extends StatelessWidget {
  final Uint8List? videoUrl;

  FullScreenVideoPage({this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerControllerModel>(
      init: VideoPlayerControllerModel(),
      builder: (videocont) => Scaffold(
        body: Center(
          child: videocont.controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: videocont.controller.value.aspectRatio,
                  child: VideoPlayer(videocont.controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            videocont.controller.value.isPlaying
                ? videocont.controller.pause()
                : videocont.controller.play();
            videocont.update();
          },
          child: Icon(
            videocont.controller.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
      ),
      initState: (_) async {
        final videofile = await File('video.mp4').writeAsBytes(videoUrl!);
        _.controller!.controller =
            (VideoPlayerController.file(videofile)..initialize().then((_) {}));
        _.controller!.update();
      },
    );
  }
}
