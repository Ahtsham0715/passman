import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllerModel extends GetxController {
  VideoPlayerController? _controller;

  VideoPlayerController get controller => _controller!;
  set controller(VideoPlayerController value) {
    _controller = value;
    update();
  }
}
