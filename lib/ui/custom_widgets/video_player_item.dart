import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController,
      _videoPlayerController2,
      _videoPlayerController3;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings();

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((value) => setState(() {}));
    _videoPlayerController2 = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController3 = VideoPlayerController.network(widget.videoUrl);
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      additionalVideoSources: {
        "240p": _videoPlayerController2,
        "480p": _videoPlayerController3,
        "720p": _videoPlayerController,
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _customVideoPlayerController.dispose();
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Get.height / 4,
          width: Get.width * 0.9,
          child: CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController,
          ),
        ),
      ],
    );
  }
}
